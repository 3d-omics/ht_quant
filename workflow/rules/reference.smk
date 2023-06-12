rule reference_set_dna:
    """Decompress the reference genome and save it in the reference folder."""
    input:
        fa=features["dna"],
    output:
        fa=temp(REFERENCE / "genome.fa"),
    log:
        REFERENCE / "genome.log",
    conda:
        "../envs/reference.yml"
    shell:
        "pigz -dc {input.fa} > {output.fa} 2> {log}"


rule reference_set_gtf:
    """Decompress the reference annotation and save it in the reference folder."""
    input:
        gtf=features["gtf"],
    output:
        gtf=temp(REFERENCE / "annotation.gtf"),
    log:
        REFERENCE / "annotation.log",
    conda:
        "../envs/reference.yml"
    shell:
        "pigz -dc {input.gtf} > {output.gtf}"
