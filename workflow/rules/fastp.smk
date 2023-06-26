rule fastp_trim_one:
    """Run fastp on one library"""
    input:
        forward_=READS / "{sample}.{library}_1.fq.gz",
        reverse_=READS / "{sample}.{library}_2.fq.gz",
    output:
        forward_=temp(FASTP / "{sample}.{library}_1.fq.gz"),
        reverse_=temp(FASTP / "{sample}.{library}_2.fq.gz"),
        unpaired1=temp(FASTP / "{sample}.{library}_u1.fq.gz"),
        unpaired2=temp(FASTP / "{sample}.{library}_u2.fq.gz"),
        html=FASTP / "{sample}.{library}.html",
        json=FASTP / "{sample}.{library}_fastp.json",
    log:
        FASTP / "{sample}.{library}.log",
    benchmark:
        FASTP / "{sample}.{library}.bmk"
    params:
        adapter_forward=get_forward_adapter,
        adapter_reverse=get_reverse_adapter,
        extra=params["fastp"]["extra"],
    threads: 24
    resources:
        mem_mb=4 * 1024,
        runtime=24 * 60,
    conda:
        "../envs/fastp.yml"
    shell:
        """
        fastp \
            --in1 {input.forward_} \
            --in2 {input.reverse_} \
            --out1 {output.forward_} \
            --out2 {output.reverse_} \
            --unpaired1 {output.unpaired1} \
            --unpaired2 {output.unpaired2} \
            --html {output.html} \
            --json {output.json} \
            --compression 1 \
            --verbose \
            --trim_poly_g \
            --trim_poly_x \q
            --adapter_sequence {params.adapter_forward} \
            --adapter_sequence_r2 {params.adapter_reverse} \
            --thread {threads} \
            {params.extra} \
        2> {log} 1>&2
        """


rule fastp_trim_all:
    """Run fastp over all libraries"""
    input:
        [
            FASTP / f"{sample}.{library}_{end}.fq.gz"
            for sample, library in SAMPLE_LIB
            for end in "1 2 u1 u2".split(" ")
        ],


rule fastp_fastqc_one:
    """Run fastqc on one library"""
    input:
        fastq=FASTP / "{sample}.{library}_{end}.fq.gz",
    output:
        html=FASTP / "{sample}.{library}_{end}_fastqc.html",
        zip_=FASTP / "{sample}.{library}_{end}_fastqc.zip",
    log:
        FASTP / "{sample}.{library}_{end}_fastqc.log",
    conda:
        "../envs/fastp.yml"
    shell:
        "fastqc --quiet {input} 2> {log} 1>&2"


rule fastp_report_all:
    """Collect fastp reports"""
    input:
        [FASTP / f"{sample}.{library}_fastp.json" for sample, library in SAMPLE_LIB],
        [
            FASTP / f"{sample}.{library}_{end}_fastqc.zip"
            for sample, library in SAMPLE_LIB
            for end in "1 2".split(" ")
        ],


rule fastp:
    """Run fastp and collect reports"""
    input:
        rules.fastp_trim_all.input,
        rules.fastp_report_all.input,
