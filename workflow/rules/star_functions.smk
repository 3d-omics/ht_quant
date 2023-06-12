def get_star_out_prefix(wildcards):
    """Get the prefix for STAR output files."""
    return STAR / f"{wildcards.sample}.{wildcards.library}."


def get_star_output_r1(wildcards):
    """Get the STAR output file for the first unmapped read mate."""
    return STAR / f"{wildcards.sample}.{wildcards.library}.Unmapped.out.mate1"


def get_star_output_r2(wildcards):
    """Get the STAR output file for the second unmapped read mate."""
    return STAR / f"{wildcards.sample}.{wildcards.library}.Unmapped.out.mate2"
