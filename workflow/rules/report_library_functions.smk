def get_star_for_library_report(wildcards):
    """Get all star reports for a single library"""
    sample = wildcards.sample
    library = wildcards.library
    files = [STAR / f"{sample}.{library}.Aligned.sortedByCoord.out.cram"]
    return files
