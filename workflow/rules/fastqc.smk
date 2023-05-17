rule fastqc_one:
    input:
        "{prefix}.fq.gz",
    output:
        html="{prefix}_fastqc.html",
        zip="{prefix}_fastqc.zip",
    log:
        "{prefix}_fastqc.log",
    conda:
        "../envs/fastqc.yml"
    params:
        "--quiet",
    log:
        "{prefix}_fastqc.log",
    shell:
        """
        fastqc {params} {input} > {log} 2>&1
        """
