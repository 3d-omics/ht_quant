rule fastqc:
    """Run FastQC on a fastq.gz file"""
    input:
        fastq="{prefix}.fq.gz",
    output:
        html="{prefix}_fastqc.html",
        zip="{prefix}_fastqc.zip",
    params:
        "--quiet",
    log:
        "{prefix}_fastqc.log",
    conda:
        "../envs/fastqc.yml"
    shell:
        """fastqc {params} {input.fastq} 2> {log} 1>&2"""
