"""
1. Download Nextclade dataset
2. Run Nextclade on the dataset reference
3. Move reference and translations to output folder
"""


rule all:
    input:
        artefacts="artefacts/" + config["output_dir"],


rule download_dataset:
    output:
        "dataset/reference.fasta",
        "dataset/genome_annotation.gff3",
        "dataset/pathogen.json",
    params:
        dataset_server=config["dataset_server"],
        dataset_name=config["dataset_name"],
    shell:
        """
        nextclade dataset get \
            --name {params.dataset_name} \
            --output-dir dataset \
            --server {params.dataset_server}
        """


rule run_nextclade:
    input:
        reference="dataset/reference.fasta",
        genome_annotation="dataset/genome_annotation.gff3",
        pathogen="dataset/pathogen.json",
    output:
        translations=directory("output"),
        reference="output/reference.fasta",
    params:
        translation_template=lambda w: f"output/{{cds}}.fasta",
    shell:
        """
        nextclade run \
            --input-ref {input.reference} \
            --input-annotation {input.genome_annotation} \
            --output-translations {params.translation_template} \
            -- {input.reference}
        cp {input.reference} {output.reference}
        """


rule postprocess:
    input:
        translations="output",
    output:
        directory("artefacts/" + config["output_dir"]),
    shell:
        """
        mkdir -p {output}
        for f in {input.translations}/*.fasta; do
            # Remove the header, use single line sequence
            seqkit seq -sw0 $f > {output}/$(basename $f)
        done
        """
