rule reference_set_dna:
    input:
        fa=features["dna"],
    output:
        fa=temp(REFERENCE / "genome.fa"),
    log:
        REFERENCE / "genome.log",
    conda:
        "../envs/empty.yml"
    shell:
        "pigz -dc {input.fa} > {output.fa} 2> {log}"


rule reference_set_gtf:
    input:
        gtf=features["gtf"],
    output:
        gtf=temp(REFERENCE / "annotation.gtf"),
    log:
        REFERENCE / "annotation.log",
    conda:
        "../envs/empty.yml"
    shell:
        "pigz -dc {input.gtf} > {output.gtf}"
