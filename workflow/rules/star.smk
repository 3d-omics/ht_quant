
rule star_index:
    input:
        dna="resources/reference/chrX_sub.fa",
        gtf="resources/reference/chrX_sub.gtf",
    output:
        folder=directory("results/star/index"),
    params:
        readlength=config["readlength"],
    conda:
        "../envs/star.yml"
    log:
        "resources/star/index.log",
    threads: 24
    resources:
        mem_gb=150,
        time="08:00:00",
    shell:
        """
        STAR \
            --runMode genomeGenerate \
            --runThreadN {threads} \
            --genomeDir {output.folder} \
            --genomeFastaFiles {input.dna} \
            --sjdbGTFfile {input.gtf} \
            --sjdbOverhang {params.readlength} \
        2> {log} 1>&2
        """


def get_star_out_prefix(wildcards):
    return STAR / f"{wildcards.sample}."


def get_star_output_r1(wildcards):
    return STAR / f"{wildcards.sample}.Unmapped.out.mate1"


def get_star_output_r2(wildcards):
    return STAR / f"{wildcards.sample}.Unmapped.out.mate2"


rule star_align:
    input:
        read1=RIBO / "{sample}_1.fq.gz",
        read2=RIBO / "{sample}_2.fq.gz",
        index=STAR / "index",
    output:
        bam=STAR / "{sample}.Aligned.sortedByCoord.out.bam",
        u1=STAR / "{sample}.Unmapped.out.mate1",
        u2=STAR / "{sample}.Unmapped.out.mate2",
    log:
        STAR / "{sample}.log",
    params:
        out_prefix=get_star_out_prefix,
    conda:
        "../envs/star.yml"
    threads: 24
    resources:
        mem_gb=150,
        time="08:00:00",
    shell:
        """
        ulimit -n 90000 2> {log} 1>&2

        STAR \
            --runMode alignReads \
            --runThreadN {threads} \
            --genomeDir {input.index} \
            --readFilesIn {input.read1} {input.read2} \
            --outFileNamePrefix {params.out_prefix} \
            --outSAMtype BAM SortedByCoordinate \
            --outReadsUnmapped Fastx \
            --readFilesCommand zcat \
            --quantMode GeneCounts \
        2>> {log} 1>&2
        """


rule star_compress_unpaired:
    input:
        u1=STAR / "{sample}.Unmapped.out.mate1",
        u2=STAR / "{sample}.Unmapped.out.mate2",
    output:
        u1=STAR / "{sample}.Unmapped.out.mate1.fq.gz",
        u2=STAR / "{sample}.Unmapped.out.mate2.fq.gz",
    log:
        STAR / "{sample}.compression.log",
    threads: 24
    shell:
        """
        pigz --best --stdout {input.u1} > {output.u1} 2>  {log}
        pigz --best --stdout {input.u2} > {output.u2} 2>> {log}
        """
