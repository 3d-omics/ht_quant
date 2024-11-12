def get_reads(wildcards):
    """Get reads for a sample and library."""
    forward_, reverse_ = samples[
        (samples["sample_id"] == wildcards.sample_id)
        & (samples["library_id"] == wildcards.library_id)
    ][["forward_filename", "reverse_filename"]].values[0]
    return forward_, reverse_


def get_forward(wildcards):
    """Get forward reads for a sample and library."""
    return samples[
        (samples["sample_id"] == wildcards.sample_id)
        & (samples["library_id"] == wildcards.library_id)
    ]["forward_filename"].tolist()[0]


def get_reverse(wildcards):
    """Get reverse reads for a sample and library."""
    return samples[
        (samples["sample_id"] == wildcards.sample_id)
        & (samples["library_id"] == wildcards.library_id)
    ]["reverse_filename"].tolist()[0]
