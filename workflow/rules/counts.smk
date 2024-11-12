rule counts:
    """Join individual count tables into one"""
    input:
        [
            STAR / f"{sample_id}.{library_id}.ReadsPerGene.out.tab"
            for sample_id, library_id in SAMPLE_LIBRARY
        ],
    output:
        tsv=RESULTS / "counts.tsv.gz",
    log:
        RESULTS / "counts.log",
    conda:
        "../environments/counts.yml"
    params:
        folder=STAR,
    shell:
        """
        Rscript --no-init-file workflow/scripts/join_star_table.R \
            --input-folder {params.folder} \
            --output-file {output.tsv} \
        2> {log} 1>&2
        """


rule counts__all:
    input:
        RESULTS / "counts.tsv.gz",
