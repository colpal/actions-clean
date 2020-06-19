# Clean

A Github Action to clean the runner workspace

If you are using a self-hosted runner, it is **highly** recommended you set this action to run unconditionally as your
last step.

## Usage

```yaml
# ...
steps:
  - uses: actions/checkout@v2.3.0
  # ...
  - uses: colpal/actions-clean@v1.0.1
    if: ${{ always() }} # To ensure this step runs even when earlier steps fail
```
