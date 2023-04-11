############################################################################
#### Transcriptomics snakefile
#### Authors: Antton Alberdi/Raphael Eisenhofer
############################################################################

configfile: "0_Bin/pipeline.yml"

### Setup sample inputs
import os
from glob import glob

SAMPLE = [os.path.basename(fn).replace("_1.fq.gz", "")
            for fn in glob(f"1_Data/1_Untrimmed/*_1.fq.gz")]

print("Detected the following samples:")
print(SAMPLE)

rule all:
    input:
        expand("2_Output/1_Mapping/{sample}_host.bam", sample=SAMPLE)

rule qualityfiltering:
    input:
        read1="1_Data/1_Untrimmed/{sample}_1.fq.gz",
        read2="1_Data/1_Untrimmed/{sample}_2.fq.gz"
    threads: 8
    resources:
        mem_gb=24,
        time='01:00:00'
    conda:
        "conda_env.yml"
    output:
        read1=temp("1_Data/2-Qualfilt/{sample}_1.fastq.gz"),
        read2=temp("1_Data/2-Qualfilt/{sample}_2.fastq.gz"),
        fastp_html="1_Data/2-Qualfilt/{sample}.html",
        fastp_json="1_Data/2-Qualfilt/{sample}.json"
    message:
        "Quality filtering {wildcards.sample} with fastp"
    shell:
        """
	    fastp \
            --in1 {input.read1} --in2 {input.read2} \
            --out1 {output.read1} --out2 {output.read2} \
            --trim_poly_g \
            --trim_poly_x \
            --low_complexity_filter \
            --n_base_limit 5 \
            --qualified_quality_phred 20 \
            --length_required 60 \
            --thread {threads} \
            --html {output.fastp_html} \
            --json {output.fastp_json} \
            --adapter_sequence AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
            --adapter_sequence_r2  AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
        """
# ################################################################################
# ## Index RNA database:
# rule index_RNA:
#     input:
#         "expand("{genome}", genome=config['genome'])/"
#     output:
#         "expand("{genome}", genome=config['genome'])/"
#     conda:
#         "Transcriptomics_conda.yaml"
#     threads:
#         48
#     log:
#         "2_Output/0_Logs/RNA_bowtie2_indexing.log"
#     message:
#         "Indexing RNA genes with Bowtie2"
#     shell:
#         """
#         # Index MAG gene catalogue
#         bowtie2-build \
#             --threads {threads} \
#             {input} {input} \
#         &> {log}
#         """
################################################################################
### Remove RNA reads
rule ribodetector:
    input:
        r1 = "1_Data/2-Qualfilt/{sample}_1.fastq.gz",
        r2 = "1_Data/2-Qualfilt/{sample}_2.fastq.gz",
    output:
        non_rna_r1 = "1_Data/2-Qualfilt/{sample}_non_ribo_1.fastq.gz",
        non_rna_r2 = "1_Data/2-Qualfilt/{sample}_non_ribo_2.fastq.gz",
    conda:
        "conda_env.yml"
    threads:
        24
    resources:
        mem_gb=64,
        time='08:00:00'
    benchmark:
        "2_Output/0_Logs/{sample}_RNAremoval.benchmark.tsv"
    log:
        "2_Output/0_Logs/{sample}_RNAremoval.log"
    message:
        "Removing rRNAs from {wildcards.sample} using ribodetector"
    shell:
        """
        # Run ribodetector
        ribodetector_cpu \
            -t 24 \
            -l 150 \
            -i {input.r1} {input.r2} \
            -e rrna \
            -o {output.non_rna_r1} {output.non_rna_r2}
        """
################################################################################
### Calculate the number of reads that mapped to RNA db with CoverM
# rule coverM_RNA_genes:
#     input:
#         expand("2_Output/2_rRNA_Mapping/{sample}.bam", sample=SAMPLE),
#     output:
#         total_cov = "2_Output/2_rRNA_Mapping/coverM_RNA_mapping.txt"
#     params:
#         rna_ref = "expand("{genome}", genome=config['genome'])/.fna"
#     conda:
#         "Transcriptomics_conda.yaml"
#     threads:
#         40
#     message:
#         "Calculating RNA mapping rate using CoverM"
#     shell:
#         """
#         # Get overall mapping rate
#         coverm genome \
#             -b {input} \
#             --genome-fasta-files {params.rna_ref} \
#             -m relative_abundance \
#             -t {threads} \
#             --min-covered-fraction 0 \
#             > {output.total_cov}

#         # Compress reference
#         pigz -t 40 {params.rna_ref_dc}
#         """
################################################################################
### Index reference genome using STAR
rule STAR_host_index:
    input:
        expand("{genome}", genome=config['genome'])
    output:
        expand("{genomedone}", genomedone=config['genomedone'])
    params:
        readlength = expand("{readlength}", readlength=config['readlength'])
    conda:
        "conda_env.yml"
    threads:
        48
    resources:
        mem_gb=150,
        time='08:00:00'
    message:
        "Indexing the host genome using STAR"
    shell:
        """
        #Gunzip genome files if necessary
        if test -f {input}/*.fna.gz; then
            gunzip {input}/*.fna.gz
        fi
        if test -f {input}/*.gff.gz; then
            gunzip {input}/*.gff.gz
        fi

        #Convert GFF to GTF
        gtffile=$(ls {input}/*.gff | sed s/gff/gtf/)
        gffread {input}/*.gff -T -o ${{gtffile}}

        #Index genome
        STAR \
            --runMode genomeGenerate \
            --runThreadN {threads} \
            --genomeDir {input} \
            --genomeFastaFiles {input}/*.fna \
            --sjdbGTFfile {input}/*.gtf \
            --sjdbOverhang {params.readlength}
        """
################################################################################
### Map to host reference genome using STAR
rule STAR_host_mapping:
    input:
        read1="1_Data/2-Qualfilt/{sample}_non_ribo_1.fastq.gz",
        read2="1_Data/2-Qualfilt/{sample}_non_ribo_2.fastq.gz",
        genome = expand("{genomedone}", genomedone=config['genomedone'])
    output:
        non_host_r1 = "2_Output/1_Mapping/{sample}_non_host_1.fastq.gz",
        non_host_r2 = "2_Output/1_Mapping/{sample}_non_host_2.fastq.gz",
        host_bam = "2_Output/1_Mapping/{sample}_host.bam"
    params:
        r1rn = "2_Output/1_Mapping/{sample}_non_host_1.fastq",
        r2rn = "2_Output/1_Mapping/{sample}_non_host_2.fastq",
        gene_counts = "2_Output/1_Mapping/{sample}_read_counts.tsv",
        sj = "2_Output/1_Mapping/{sample}_SJ.tsv",
        log = "2_Output/1_Mapping/{sample}_log.tsv",
        genome = expand("{genome}", genome=config['genome'])
    conda:
        "conda_env.yml"
    threads:
        24
    resources:
        mem_gb=150,
        time='08:00:00'
    message:
        "Mapping {wildcards.sample} to the host genome using STAR"
    shell:
        """
        # Set max file open limit (STAR opens a lot of temp files!)
        ulimit -n 90000

        # Map reads to host genome using STAR
        STAR \
            --runMode alignReads \
            --runThreadN {threads} \
            --genomeDir {params.genome} \
            --readFilesIn {input.read1} {input.read2} \
            --outFileNamePrefix {wildcards.sample} \
            --outSAMtype BAM SortedByCoordinate \
            --outReadsUnmapped Fastx \
            --readFilesCommand zcat \
            --quantMode GeneCounts

        # Rename files
        mv {wildcards.sample}Aligned.sortedByCoord.out.bam {output.host_bam}
        mv {wildcards.sample}ReadsPerGene.out.tab {params.gene_counts}
        mv {wildcards.sample}SJ.out.tab {params.sj}
        mv {wildcards.sample}Unmapped.out.mate1 {params.r1rn}
        mv {wildcards.sample}Unmapped.out.mate2 {params.r2rn}
        mv {wildcards.sample}*.final.out {params.log}

        # Compress non-host reads
        pigz \
            -p {threads} \
            {params.r1rn}

        pigz \
            -p {threads} \
            {params.r2rn}

        # Clean up unwanted outputs
        rm -r {wildcards.sample}_STARtmp
        rm {wildcards.sample}*out*
        """
