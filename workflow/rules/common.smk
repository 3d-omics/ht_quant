def get_reads(wildcards):
    forward_, reverse_ = samples[
        (samples["sample"] == wildcards.sample)
        & (samples["library"] == wildcards.library)
    ][["forward", "reverse"]].values[0]
    return forward_, reverse_


def get_forward(wildcards):
    return samples[
        (samples["sample"] == wildcards.sample)
        & (samples["library"] == wildcards.library)
    ]["forward"].tolist()[0]


def get_reverse(wildcards):
    return samples[
        (samples["sample"] == wildcards.sample)
        & (samples["library"] == wildcards.library)
    ]["reverse"].tolist()[0]


def get_star_out_prefix(wildcards):
    return STAR / f"{wildcards.sample}.{wildcards.library}."


def get_star_output_r1(wildcards):
    return STAR / f"{wildcards.sample}.{wildcards.library}.Unmapped.out.mate1"


def get_star_output_r2(wildcards):
    return STAR / f"{wildcards.sample}.{wildcards.library}.Unmapped.out.mate2"
