from Bio import SeqIO
import click


@click.command(help="Parse downloaded NCBI FASTA protein or nucleotide file and save sequences to individual files")
@click.option("--input-file", required=True, type=click.Path())
@click.option(
    "--file-type",
    default="protein",
    type=click.Choice(["protein", "nucleotide"]),
)
def main(input_file: str, file_type: str)-> None:
    if file_type == "nucleotide":
        count = 0
        for record in SeqIO.parse(input_file, "fasta"):
            if count > 0:
                print("warning: more than one sequence found in the input file")
                break
            count += 1
            description = record.description
            with open("reference.fasta", "w") as output_file:
                output_file.write(str(record.seq)) 
        return None
    for record in SeqIO.parse(input_file, "fasta"):
        description = record.description
        gene_name = None
        for part in description.split():
            if part.startswith("[gene="):
                gene_name = part.split("=")[1].strip("]")

        # If a gene name was found, save the sequence to a new file
        if gene_name:
            with open(f"{gene_name}.fasta", "w") as output_file:
                output_file.write(str(record.seq) + "*") 

if __name__ == "__main__":
    main()