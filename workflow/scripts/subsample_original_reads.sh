#!/usr/bin/env bash

set -euo pipefail

mkdir subsampled/

for sample in GBR{M,F}{1..3}.1 ; do

    samtools view \
        -h \
        results/star/${sample}.Aligned.sortedByCoord.out.cram \
        chrX:1-500000 \
    | samtools fastq \
        -c 9 \
        -1 subsampled/${sample}_sub_1.fq.gz \
        -2 subsampled/${sample}_sub_2.fq.gz

done

# slice reference
samtools faidx results/reference/genome.fa chrX:1-500000 > subsampled/chrX_sub.fa
sed -i 's/:1-500000//g' subsampled/reference.fa
bgzip -@ 8 subsampled/chrX_sub.fa


# slice annotation
gzip -dc resources/reference/chrX_sub.gtf.gz \
| grep ^# > subsampled/chrX_sub.gtf

gzip -dc resources/reference/chrX_sub.gtf.gz \
| grep -v ^# \
| awk '$5 < 500000' \
>> subsampled/chrX_sub.gtf
bgzip -@ 8 subsampled/chrX_sub.gtf
