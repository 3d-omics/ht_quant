rule star_index:
    input:
        dna=REFERENCE / "genome.fa",
        gtf=REFERENCE / "annotation.gtf",
    output:
        folder=directory("results/star/index"),
    params:
        readlength=config["readlength"],
    conda:
        "../envs/star.yml"
    log:
        REFERENCE / "index.log",
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


rule star_align:
    input:
        r1=FASTP / "{sample}.{library}_1.fq.gz",
        r2=FASTP / "{sample}.{library}_2.fq.gz",
        index=STAR / "index",
    output:
        bam=temp(STAR / "{sample}.{library}.Aligned.sortedByCoord.out.bam"),
        u1=temp(STAR / "{sample}.{library}.Unmapped.out.mate1"),
        u2=temp(STAR / "{sample}.{library}.Unmapped.out.mate2"),
    log:
        STAR / "{sample}.{library}.log",
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
            --readFilesIn {input.r1} {input.r2} \
            --outFileNamePrefix {params.out_prefix} \
            --outSAMtype BAM SortedByCoordinate \
            --outReadsUnmapped Fastx \
            --readFilesCommand "gzip -cd" \
            --quantMode GeneCounts \
        2>> {log} 1>&2
        """


rule star_compress_unpaired:
    input:
        u1=STAR / "{sample}.{library}.Unmapped.out.mate1",
        u2=STAR / "{sample}.{library}.Unmapped.out.mate2",
    output:
        u1=STAR / "{sample}.{library}.Unmapped.out.mate1.fq.gz",
        u2=STAR / "{sample}.{library}.Unmapped.out.mate2.fq.gz",
    log:
        STAR / "{sample}.{library}.compression.log",
    conda:
        "../envs/star.yml"
    threads: 24
    shell:
        """
        pigz --best --stdout {input.u1} > {output.u1} 2>  {log}
        pigz --best --stdout {input.u2} > {output.u2} 2>> {log}
        """


rule star_compress_all:
    input:
        [
            STAR / f"{sample}.{library}.Unmapped.out.{mate}.fq.gz"
            for sample, library in SAMPLE_LIB
            for mate in "mate1 mate2".split()
        ],


rule star_cram:
    input:
        bam=STAR / "{sample}.{library}.Aligned.sortedByCoord.out.bam",
        reference=REFERENCE / "genome.fa",
    output:
        cram=STAR / "{sample}.{library}.Aligned.sortedByCoord.out.cram",
        crai=STAR / "{sample}.{library}.Aligned.sortedByCoord.out.cram.crai",
    log:
        STAR / "{sample}.{library}.cram.log",
    conda:
        "../envs/star.yml"
    threads: 24
    shell:
        """
        samtools sort \
            -l 9 \
            -m 1G \
            -o {output.cram} \
            --output-fmt CRAM \
            --reference {input.reference} \
            -@ {threads} \
            --write-index \
            {input.bam} \
        2> {log} 1>&2
        """


rule star_cram_all:
    input:
        [
            STAR / f"{sample}.{library}.Aligned.sortedByCoord.out.cram"
            for sample, library in SAMPLE_LIB
        ],


rule star_all:
    input:
        rules.star_compress_all.input,
        rules.star_cram_all.input,
