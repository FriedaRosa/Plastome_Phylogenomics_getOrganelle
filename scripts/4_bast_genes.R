# extract plastome genes from assemblies

library(ape)
library(dplyr)
library(purrr)
library(readr)
library(stringr)


# new assemblies
assemblies <-
    system("find data/getorganelle_output/archive_plastomes -type f | grep .fasta", intern = TRUE)



# reformat sequences with sample as header & write into temporary files
for (f in c(assemblies)) {
  s <-
      read.FASTA(f)
  samp <-
      strsplit(
          gsub(
            "data/getorganelle_output/archive_plastomes/", 
"", f), "/")[[1]][1]
  names(s) <-
      rep(samp, length(s))
  # write to temp file
  fn <-
      paste0("data/TEMP/ASM__", samp, ".fasta")
  write.FASTA(s, file = fn)
}

# combine all plastome sequences into one temporary file
cmd <- paste0("cat ",
              " data/TEMP/ASM__*.fasta ",
              "> data/TEMP/plastomes_combined.fasta")
system(cmd)

# run BLAST on each sample file with reference sequences

seqf <- list.files(
  "data/TEMP",
  pattern = "^(NCBI__|ASM__).+\\.fasta$",
  full.names = TRUE
)

ref <- "data/genes.fasta"

for (f in seqf) {
#   cmd = paste0("blastn -evalue 1e-6 -subject ", f," -query ", ref, " -max_target_seqs 1 -outfmt '6 sseqid qseqid sseq' > ", gsub(".fasta", ".BLAST", f))
cmd <- paste0(
  "conda run -n plastomes blastn ",
  "-evalue 1e-6 ",
  "-subject ", f, " ",
  "-query ", ref, " ",
  "-max_target_seqs 1 ",
  "-outfmt '6 sseqid qseqid sseq' ",
  "> ", sub("\\.fasta$", ".BLAST", f)
)
  system(cmd)
}

# read BLAST results into one table
blast_res <- gsub(".fasta", ".BLAST", seqf) %>%
  keep(~ file.size(.x) > 0) %>% # drop empty files
  map(read_tsv, col_names = FALSE) %>% # read each into a tibble
  list_rbind() %>%
  # add column names
  set_names(c("sample", "gene", "sequence")) %>%
  # remove gaps in sequences/BLAST matches
  mutate(sequence = str_remove_all(sequence, "-")) %>%
  # remove duplicates
  distinct() %>%
  summarise(
    sequence = paste0(sequence, collapse = ""),
    .by = c(sample, gene),
  )

# read ref sequences and get length per gene
refseq <- read.FASTA(ref)
reflen <- sapply(refseq, length)

# get recovered length relative to reference
blast_res <- blast_res %>%
  mutate(length = nchar(sequence)) %>%
  mutate(coverage = length / reflen[gene])

# per sample, get # of genes and average coverage
# (before filtering)
plastome_tab <- blast_res %>%
  summarise(
    n_genes = n(),
    coverage_mean = mean(coverage, na.rm = TRUE),
    .by = sample
  )

# filter out samples based on number of genes
blast_res <- blast_res %>%
  add_count(sample) %>%
  filter(n >= 10)

# filter out selected samples manually (long branches, dubious ID etc.)
to_exclude <- readLines("data/input/sequences/exclude_plastomes.txt")
blast_res <- blast_res %>%
  filter(! sample %in% to_exclude)

# per gene, write fasta files
outdir <- "data/plastome_seq/"
genes <- unique(blast_res$gene)
for (g in genes) {
  sel_data <- filter(blast_res, gene == g)
  writeLines(
    text = paste0(">", sel_data$sample, "\n", sel_data$sequence),
    con = paste0(outdir, g, ".fasta")
  )
}

# write summary table to file
write.table(plastome_tab, file = paste0(outdir, "plastome_seq_summary.tsv"),
            row.names = FALSE, sep = "\t")