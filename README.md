# Snakemake workflow: `Bioinfo_Macro_Host_Transcriptomics`

[![Snakemake](https://img.shields.io/badge/snakemake-≥6.3.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/3d-omics/Bioinfo_Macro_Host_Transcriptomics/workflows/Tests/badge.svg?branch=main)](https://github.com/3d-omics/Bioinfo_Macro_Host_Transcriptomics/actions?query=branch%3Amain+workflow%3ATests)


A Snakemake workflow for Transcriptome Quantification


## Usage

- Test that it works:
  - Make sure you have installed snakemake and run the pipeline with the test
    data: `snakemake --use-conda --jobs 8 all`. It will download all the
    necesary software through conda. It should take less than 5 minutes.

- Run it with your own data:
  - Edit `config/samples.tsv` and add your samples and where are they located.
  - Edit `config/features.yml` with information regarding the reference you are
    using.
  - Edit `config/params.yml` to change the execution of the steps.
  - Run the pipeline: `snakemake --use-conda --jobs 8 all`.
  - (slurm users): `./run_slurm`

## Features

- FASTQ processing with [`fastp`](https://github.com/OpenGene/fastp)
- Mapping with [`STAR`](https://github.com/alexdobin/STAR)
- SAM/BAM/CRAM processing with [`samtools`](https://github.com/samtools/samtools) and [`picard`](https://github.com/broadinstitute/picard)
- Reports with [`multiqc`](https://github.com/ewels/MultiQC) and
    [`FastQC`](https://github.com/s-andrews/FastQC)

## DAG

![host_transcriptomics_pipeline](./rulegraph.svg?raw=true)

## References

TBA
