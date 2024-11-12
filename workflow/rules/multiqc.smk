rule multiqc__config:
    """Generate the config file for multiqc"""
    output:
        RESULTS / "multiqc_config.yaml",
    log:
        RESULTS / "multiqc_config.log",
    conda:
        "../environments/multiqc.yml"
    params:
        chromosome_x=features["sex_chromosomes"][0],
        chromosome_y=features["sex_chromosomes"][1],
    shell:
        """
        echo "samtools_idxstats_xchr: {params.chromosome_x}" >  {output} 2>  {log}
        echo "samtools_idxstats_ychr: {params.chromosome_y}" >> {output} 2>> {log}
        """


rule multiqc:
    """Collect all reports for the reads step"""
    input:
        reads=[
            READS / f"{sample_id}.{library_id}_{end}_fastqc.zip"
            for sample_id, library_id in SAMPLE_LIBRARY
            for end in [1, 2]
        ],
        fastp=[
            FASTP / f"{sample_id}.{library_id}_fastp.json"
            for sample_id, library_id in SAMPLE_LIBRARY
        ],
        star=[
            STAR / f"{sample_id}.{library_id}.Log.final.out"
            for sample_id, library_id in SAMPLE_LIBRARY
        ],
        samtools=[
            STAR / f"{sample_id}.{library_id}.Aligned.sortedByCoord.out.{report}"
            for report in BAM_REPORTS
            for sample_id, library_id in SAMPLE_LIBRARY
        ],
        config=RESULTS / "multiqc_config.yaml",
    output:
        html=RESULTS / "ht_quant.html",
    log:
        RESULTS / "ht_quant.log",
    conda:
        "../environments/multiqc.yml"
    params:
        dir=RESULTS,
    shell:
        """
        multiqc \
            --filename ht_quant \
            --title ht_quant \
            --force \
            --outdir {params.dir} \
            --config {input.config} \
            {input.reads} \
            {input.fastp} \
            {input.star} \
            {input.samtools} \
        2> {log} 1>&2
        """


rule multiqc__all:
    input:
        RESULTS / "ht_quant.html",
