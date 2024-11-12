#!/usr/bin/env Rscript

library(argparse)

read_star_counts <- function(filename) {
  # Read only the first two columns. The other two are for strand-specific data
  # Extract the file name, since we have to match the Illumina name with the
  # sample name

  star_column_names <- c(
    "gene_id", "unstranded", "stranded_forward", "stranded_reverse"
  )

  filename |>
    readr::read_tsv(
      col_names = star_column_names,
      col_select = 1:2,
      skip = 4,
      show_col_types = FALSE
    ) |>
    dplyr::mutate(
      sample_id = filename |>
        basename() |>
        stringr::str_remove(".ReadsPerGene.out.tab")
    ) |>
    dplyr::select(sample_id, gene_id, counts = unstranded)
}

parser <- ArgumentParser()

parser$add_argument(
  "-i", "--input-folder",
  type = "character",
  dest = "input_folder",
  help = paste(
    "Folder that contains the STAR counts. Will search recursively for ",
    "files ended in \".ReadsPerGene.out.tab\"."
  )
)

parser$add_argument(
  "-o", "--output-file",
  type = "character",
  dest = "output_file",
  help = paste(
    "Output file with all the table containing all the counts together"
  )
)

args <- parser$parse_args()

files <-
  list.files(
    path = args$input_folder,
    pattern = "*.ReadsPerGene.out.tab",
    recursive = TRUE,
    full.names = TRUE
  )

counts_raw <-
  files |>
  purrr::map_dfr(read_star_counts) |>
  tidyr::pivot_wider(names_from = sample_id, values_from = counts)

dir.create(dirname(args$output_file))
readr::write_tsv(counts_raw, args$output_file)
