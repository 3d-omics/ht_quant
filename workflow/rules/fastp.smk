rule fastp:
    input:
        read1=READS / "{sample}.{library}_1.fq.gz",
        read2=READS / "{sample}.{library}_2.fq.gz",
    output:
        read1=temp(FASTP / "{sample}.{library}_1.fq.gz"),
        read2=temp(FASTP / "{sample}.{library}_2.fq.gz"),
        fastp_html=FASTP / "{sample}.{library}.html",
        fastp_json=FASTP / "{sample}.{library}.json",
    conda:
        "../envs/fastp.yml"
    log:
        FASTP / "{sample}.{library}.log",
    threads: 32
    params:
        n_base_limit=5,
        qualified_quality_phred=20,
        length_required=60,
        adapter_sequence="AGATCGGAAGAGCACACGTCTGAACTCCAGTCA",
        adapter_sequence_r2="AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT",
    # resources:
    #     mem_gb=24,
    #     time='01:00:00'
    shell:
        """
        fastp \
            --in1 {input.read1} \
            --in2 {input.read2} \
            --out1 {output.read1} \
            --out2 {output.read2} \
            --trim_poly_g \
            --trim_poly_x \
            --low_complexity_filter \
            --n_base_limit {params.n_base_limit} \
            --qualified_quality_phred {params.qualified_quality_phred} \
            --length_required {params.length_required} \
            --thread {threads} \
            --html {output.fastp_html} \
            --json {output.fastp_json} \
            --adapter_sequence {params.adapter_sequence} \
            --adapter_sequence_r2 {params.adapter_sequence_r2} \
        2> {log} 1>&2
        """


rule fastp_all_samples:
    """Collect fastp files"""
    input:
        [
            FASTP / f"{sample}.{library}_{end}.fq.gz"
            for sample, library in SAMPLE_LIB
            for end in "1 2".split()
        ],


rule fastp_fastqc:
    """Collect fasqtc reports from the results of fastp"""
    input:
        [
            FASTP / f"{sample}.{library}_{end}_fastqc.html"
            for sample, library in SAMPLE_LIB
            for end in "1 2".split(" ")
        ],


rule fastp_all:
    input:
        rules.fastp_all_samples.input,
        rules.fastp_fastqc.input,
