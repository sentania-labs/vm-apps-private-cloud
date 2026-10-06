# Diagrams

Architecture diagrams for this workspace are authored in Excalidraw format and rendered to PNG.

- `topology.excalidraw`: VM Apps Private Cloud, VCF Automation as the vSphere API.
  Its twin for the native Terraform path lives in sentania-labs/tf-private-cloud
  (`docs/diagrams/topology.excalidraw`), drawn on the same layout so the two compare side by side.

## Regenerate

```bash
cd docs/diagrams && uv run render.py topology.excalidraw
```

First run only: `uv run playwright install chromium`.

Source files: `*.excalidraw`
Rendered output: `*.png`
