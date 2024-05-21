# Translation helper

Run with:

```bash
snakemake -F
```

## Config

To use translate different Nextclade datasets, configure via `profiles/default/configfile.yaml` or passing
config options explicitly to the snakemake command.

Example:

```bash
s --config dataset_name=nextstrain/ebola/zaire dataset_server="https://raw.githubusercontent.com/nextstrain/nextclade_data/ebola/data_output" output_dir="ebola-zaire"
```
