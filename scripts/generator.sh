#!/usr/bin/env bash
set -euo pipefail

yq -r '.HA | to_entries[] | "\(.key) \(.value)"' scripts/config.yml |
while read -r subtype accession; do

  echo "▶ Processing $subtype ($accession)"

  base="artefacts/influenza/HA/$subtype/$accession"

  mkdir -p "$base/segments" "$base/genes"

  snakemake -F \
    --config \
      dataset_name="flu/HA/$subtype/$accession" \
      dataset_server="https://raw.githubusercontent.com/genspectrum/nextclade-datasets/flu/data" \
      output_dir="influenza/HA/$subtype/$accession/output"

  cp -rn "$base/output/"* "$base/genes/"

  mv "$base/genes/reference.fasta" \
     "$base/segments/seg4.fasta"

done

yq -r '.NA | to_entries[] | "\(.key) \(.value)"' scripts/config.yml |
while read -r subtype accession; do

  echo "▶ Processing $subtype ($accession)"

  base="artefacts/influenza/NA/$subtype/$accession"

  mkdir -p "$base/segments" "$base/genes"

  snakemake -F \
    --config \
      dataset_name="flu/NA/$subtype/$accession" \
      dataset_server="https://raw.githubusercontent.com/genspectrum/nextclade-datasets/flu/data" \
      output_dir="influenza/NA/$subtype/$accession/output"

  cp -rn "$base/output/"* "$base/genes/"

  mv "$base/genes/reference.fasta" \
     "$base/segments/seg6.fasta"

done