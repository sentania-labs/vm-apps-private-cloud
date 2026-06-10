# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A **single root Terraform configuration** (not a reusable child module) that acts as the
**control plane** for a VCF Automation (Aria Automation 8.18) VM-Apps environment. Applying
it stands up the platform-level plumbing — cloud accounts, cloud zones, flavor/image profiles,
tenant projects, blueprints — and then provisions a **GitHub repo per project** from a template,
injecting the secrets each app team needs to self-deploy. See `README.md` for the product-level
narrative and the two-phase decommission lifecycle.

It composes published `sentania-labs/*/vra` registry modules; this repo holds almost no resource
logic of its own, just wiring and ordering. A parallel "All-Apps" tenant repo is planned (per README)
but does not live here.

## Commands

No build, no tests. The entire workflow is Terraform CLI:

```bash
terraform init                                   # backend key is hardcoded in backend.tf (lab env)
terraform fmt                                    # MUST run before commit — CI fails on fmt -check
terraform validate
terraform plan  -var-file="envs/lab.tfvars"
terraform apply -var-file="envs/lab.tfvars"
```

`envs/lab.tfvars` is the live lab environment. Add new environments as `envs/<name>.tfvars` and,
if isolating state, override the backend key: `terraform init -backend-config="key=vra/vm-apps-private-cloud/<env>/terraform.tfstate"`.

Regenerate the architecture diagram (only when topology changes):
```bash
cd docs/diagrams && uv run render.py     # *.excalidraw -> *.png; render is deterministic
```

## Credentials are NOT in tfvars

The tfvars files carry only non-secret topology. These four variables are **sensitive and supplied
out-of-band** — via `TF_VAR_*` env vars (see `.github/workflows/configure-private-cloud.yml`) or a
local untracked tfvars:

- `vcfa_refresh_token` — auth for the `vra` provider (the control-plane API)
- `serviceAccountUserName` / `serviceAccountPassword` — used by the **cloud account modules** to
  register the vSphere and NSX endpoints (a different credential path than the provider token)
- `github_access_token` — for the `github` provider (repo creation, secret injection)

## Apply-ordering — the core thing to understand

Resource creation order is **not** what file alphabetization suggests; it's driven by an explicit
dependency chain that fans out per discovered region. Reading any single file understates this.

1. **`cloudAccounts.tf`** — NSX accounts first (`module.cloud_accounts_nsxt`), then vSphere accounts
   (`module.cloud_accounts_vsphere`), because each vSphere account references its NSX manager's id via
   `module.cloud_accounts_nsxt[each.value.nsx_manager]`.
2. **`main.tf`** — `time_sleep.wait_cloud_account_creation` (60s) exists solely to let the API
   fully populate before region data is read. `data.vra_region.all` depends on it and discovers the
   enabled regions of every cloud account, keyed by region name.
3. **Per-region fan-out** — `cloudzone.tf`, `flavors.tf`, `images.tf` all `for_each` over
   `data.vra_region.all` (or the `local.cloud_account_regions` flatten in `main.tf`), creating one
   cloud zone / flavor profile / image profile per region.
4. **`projects.tf`** — `module.projects` attaches **all** cloud zone ids (`local.all_cloud_zone_ids`)
   and also waits on the `time_sleep`.
5. **`blueprints.tf`** — depends on projects (reads `module.projects[k].project.id` via
   `local.projects_expanded`), renders `blueprint_templates/simpleIac.tpl.yaml` per project.
6. **`repositories.tf`** — `for_each = module.projects`; creates a GitHub repo from the
   `sentania-labs/vcf-lab-application-template` template (via `mineiros-io/repository/github`) and
   injects `VCFA_PROJECT_NAME` / `VCFA_PROJECT_ID` / `VCFA_ORGANIZATION_NAME` as plaintext secrets so
   the generated repo can deploy into its own project.

If you add a resource that needs cloud accounts or regions to exist, hang it off
`time_sleep.wait_cloud_account_creation` or `data.vra_region.all`, not directly off the account module.

## Non-obvious conventions / gotchas

- **Cloud-account map keys are cosmetic.** Both account modules iterate
  `for ca in var.vsphere_accounts : ca.name => ca` (and likewise for NSX). The Terraform instance key is
  the object's `name` field, **not** the tfvars map key. A vSphere account's `nsx_manager` must match an
  NSX account's `name`, not its map key.
- **`flavors.tf` hardcodes the flavor list** (small/medium/large). It is not driven by tfvars — edit the
  file to change sizing.
- **Template escaping** is double-layered. In `simpleIac.tpl.yaml` and in `basename` values, `${...}` is a
  Terraform `templatefile`/HCL interpolation, while `$${...}` escapes to a literal `${...}` that VCFA itself
  consumes at deploy time (e.g. `$${input.image}`, `vra-sandbox-$${####}`). Don't "fix" the doubled `$$`.
- **Content-library images** must be named `"<library> / <template>"` (note the spaces around `/`) in
  `image_mappings.template_name`.
- **`aws` provider** is declared only because the S3 backend needs credentials — there are no AWS resources.
- **`vra` provider** (`vmware/vra`) is the published provider for what the repo brands as VCFA / Aria
  Automation 8.18; don't be thrown by the `vra` vs `vcfa` naming mismatch.

## State & CI

- **Backend:** S3 bucket `sentania-labs-terraform-state`, key
  `vra/vm-apps-private-cloud/lab/terraform.tfstate`, `use_lockfile = true` (S3-native locking, no DynamoDB).
- **CI:** `.github/workflows/configure-private-cloud.yml` runs on a `[self-hosted, terraform]` runner.
  All `pull_request` jobs are **fork-gated** (`github.event.pull_request.head.repo.owner.login == 'sentania-labs'`)
  — preserve this guard on any new job (recent commits #8–#10 exist specifically to harden it). Flow:
  fmt-check → `init -migrate-state -upgrade` → validate → plan (always, artifact uploaded) →
  **apply only on push to `main`**.

## Versions

Terraform `>= 1.14.0` (hard floor — the `sentania-labs/*/vra` modules require it; the self-hosted
CI runner must satisfy this too); providers `vmware/vra >= 0.16.0`, `integrations/github >= 4.20.0 < 6.0.0`,
`hashicorp/aws ~> 4.18.0`. The `sentania-labs/*/vra` modules are pinned to fixed versions in each
`*.tf` (vsphereaccount 0.11.0, nsxaccount 0.5.0, cloudzone 0.8.0, flavor-profile 0.7.0,
image-profile 0.6.0, project 0.11.0, blueprint 0.9.0) — bump them deliberately, not via `~>` ranges.
