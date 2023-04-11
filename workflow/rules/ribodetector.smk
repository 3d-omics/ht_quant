rule ribodetector:
    input:
        r1=FASTP / "{sample}_1.fq.gz",
        r2=FASTP / "{sample}_2.fq.gz",
    output:
        non_rna_r1=RIBO / "{sample}_1.fq.gz",
        non_rna_r2=RIBO / "{sample}_2.fq.gz",
    conda:
        "../envs/ribodetector.yml"
    benchmark:
        RIBO / "{sample}.tsv"
    log:
        RIBO / "{sample}.log",
    threads: 24
    resources:
        mem_gb=64,
        time="08:00:00",
    shell:
        """
        ribodetector_cpu \
            -t {threads} \
            -l 150 \
            -i {input.r1} {input.r2} \
            -e rrna \
            -o {output.non_rna_r1} {output.non_rna_r2} \
        2> {log} 1>&2
        """


rule ribodetector_all_samples:
    """Collect fastp files"""
    input:
        [RIBO / f"{sample}_{end}.fq.gz" for sample in SAMPLE for end in "1 2".split()],
