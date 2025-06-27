# Translation helper

## Config

To use translate different Nextclade datasets, pass config options using the snakemake command.

Example:

```bash
s --config dataset_name=nextstrain/ebola/zaire dataset_server="https://raw.githubusercontent.com/nextstrain/nextclade_data/ebola/data_output" output_dir="ebola-zaire"
```

If you want to download multiple segments you will have to move the contents of each download as they will otherwise be overwritten by default. An example of how this could be accomplished for influenza is shown below: 

```
mkdir artefacts/influenza/h1n1pdm
mkdir artefacts/influenza/h1n1pdm/segments
mkdir artefacts/influenza/h1n1pdm/genes
segment_names=("pb2" "pb1" "pa" "ha/CY121680" "np" "na/MW626056" "mp" "ns")
for i in {1..8}; do
    segment="${segment_names[i]}"
    echo $segment
    snakemake -F --config dataset_name=nextstrain/flu/h1n1pdm/$segment dataset_server="https://raw.githubusercontent.com/nextstrain/nextclade_data/master/data_output" output_dir="influenza/h1n1pdm/output"
    cp -rn artefacts/influenza/h1n1pdm/output/* artefacts/influenza/h1n1pdm/genes/
    mv artefacts/influenza/h1n1pdm/genes/reference.fasta artefacts/influenza/h1n1pdm/segments/seg$i.fasta
done
```

## Dependencies

The following tools are required:

- snakemake
- nextclade
- seqkit
