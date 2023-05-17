rule report_library_one:
    """Make a MultiQC report for a single library"""
    input:
        get_star_for_library_report,
    output:
        REPORT_LIBRARY / "{sample}.{library}.html",
    log:
        REPORT_LIBRARY / "{sample}.{library}.log",
    conda:
        "../envs/report.yml"
    params:
        library="{sample}.{library}",
        out_dir=REPORT_LIBRARY,
    shell:
        """
        multiqc \
            --title {params.library} \
            --force \
            --filename {params.library} \
            --outdir {params.out_dir} \
            {input} \
        2> {log} 1>&2
        """


rule report_library_all:
    """Make a MultiQC report for every library"""
    input:
        [REPORT_LIBRARY / f"{sample}.{library}.html" for sample, library in SAMPLE_LIB],


rule report_library:
    """Make all MultiQC reports per library"""
    input:
        rules.report_library_all.input,
