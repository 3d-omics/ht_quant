rule reference__decompress_dna:
    input:
        fasta=features["dna"],
    output:
        REFERENCE / f"{HOST_NAME}.fa",
    log:
        REFERENCE / f"{HOST_NAME}.fa.log",
    conda:
        "../environments/reference.yml"
    cache: True
    shell:
        """
        gzip \
            --decompress \
            --stdout \
            {input.fasta} \
        > {output} \
        2> {log}
        """


rule reference__decompress_gtf:
    input:
        gtf=features["gtf"],
    output:
        REFERENCE / f"{HOST_NAME}.gtf",
    log:
        REFERENCE / f"{HOST_NAME}.gtf.log",
    conda:
        "../environments/reference.yml"
    cache: True
    shell:
        """
        gzip \
            --decompress \
            --stdout \
            {input.gtf} \
        > {output} \
        2> {log}
        """


rule reference__all:
    input:
        rules.reference__decompress_dna.output,
        rules.reference__decompress_gtf.output,
