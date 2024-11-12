include: "fastp_functions.smk"


rule fastp:
    """Run fastp on one PE library"""
    input:
        sample=[
            READS / "{sample_id}.{library_id}_1.fq.gz",
            READS / "{sample_id}.{library_id}_2.fq.gz",
        ],
    output:
        trimmed=[
            FASTP / "{sample_id}.{library_id}_1.fq.gz",
            FASTP / "{sample_id}.{library_id}_2.fq.gz",
        ],
        html=FASTP / "{sample_id}.{library_id}_fastp.html",
        json=FASTP / "{sample_id}.{library_id}_fastp.json",
    log:
        FASTP / "{sample_id}.{library_id}.log",
    params:
        extra=params["fastp"]["extra"],
        adapters=compose_adapters,
    group:
        "{sample_id}.{library_id}"
    wrapper:
        "v5.0.2/bio/fastp"


rule fastp__all:
    """Run fastp over all libraries"""
    input:
        [
            FASTP / f"{sample_id}.{library_id}_{end}.fq.gz"
            for sample_id, library_id in SAMPLE_LIBRARY
            for end in [1, 2]
        ],
