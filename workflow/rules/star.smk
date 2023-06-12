rule star_index:
    """Build STAR index of the reference genome"""
    input:
        dna=REFERENCE / "genome.fa",
        gtf=REFERENCE / "annotation.gtf",
    output:
        folder=directory("results/star/index"),
    params:
        sjdbOverhang=params["star"]["index"]["sjdbOverhang"],
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
            --sjdbOverhang {params.sjdbOverhang} \
        2> {log} 1>&2
        """


rule star_align_one:
    """Align one library with STAR"""
    input:
        r1=FASTP / "{sample}.{library}_1.fq.gz",
        r2=FASTP / "{sample}.{library}_2.fq.gz",
        index=STAR / "index",
    output:
        bam=temp(STAR / "{sample}.{library}.Aligned.sortedByCoord.out.bam"),
        u1=temp(STAR / "{sample}.{library}.Unmapped.out.mate1"),
        u2=temp(STAR / "{sample}.{library}.Unmapped.out.mate2"),
        report=STAR / "{sample}.{library}.Log.final.out",
    log:
        STAR / "{sample}.{library}.log",
    params:
        out_prefix=get_star_out_prefix,
    conda:
        "../envs/star.yml"
    threads: 24
    resources:
        mem_mb=4 * 1024,
        runtime=24 * 60,
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
            --quantMode TranscriptomeSAM \
        2>> {log} 1>&2
        """


rule star_align_all:
    """Align all libraries with STAR"""
    input:
        [STAR / f"{sample}.{library}.Log.final.out" for sample, library in SAMPLE_LIB],


rule star_compress_unpaired_one:
    """Compress unpaired reads from one library"""
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
    """Compress unpaired reads from all the libraries"""
    input:
        [
            STAR / f"{sample}.{library}.Unmapped.out.{mate}.fq.gz"
            for sample, library in SAMPLE_LIB
            for mate in "mate1 mate2".split()
        ],


rule star_cram_one:
    """Convert to cram one library"""
    input:
        bam=STAR / "{sample}.{library}.Aligned.sortedByCoord.out.bam",
        reference=REFERENCE / "genome.fa",
    output:
        cram=protected(STAR / "{sample}.{library}.Aligned.sortedByCoord.out.cram"),
        crai=STAR / "{sample}.{library}.Aligned.sortedByCoord.out.cram.crai",
    log:
        STAR / "{sample}.{library}.Aligned.sortedByCoord.out.cram.log",
    conda:
        "../envs/star.yml"
    threads: 24
    resources:
        mem_mb=24 * 2048,
        runtime=24 * 60,
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
    """Convert to cram all the libraries"""
    input:
        [
            STAR / f"{sample}.{library}.Aligned.sortedByCoord.out.cram"
            for sample, library in SAMPLE_LIB
        ],


rule star_report_all:
    """Collect star reports"""
    input:
        [STAR / f"{sample}.{library}.Log.final.out" for sample, library in SAMPLE_LIB],


rule star_all:
    """Run all the star rules for all the libraries"""
    input:
        rules.star_compress_all.input,
        rules.star_cram_all.input,
        rules.star_report_all.input,


rule star:
    """Run all the star rules"""
    input:
        rules.star_all.input,
