#!/usr/bin/env bash
set -euo pipefail


cd data/getorganelle_output

archivedir=archive_plastomes/

# keep only one fasta file + log file per sample

# for each sample output directory...
for s in *; do
  if [ -d $s ]; then
    # make archive sample directory
    mkdir -p $archivedir/$s
    # copy files:
    # getOrganelle log
    if [ -f $s/get_org.log.txt ]; then
      cp $s/get_org.log.txt $archivedir/$s
    fi
    # complete plastome fasta file, if there is one
    if [ -f $s/*complete.graph1.1.path_sequence.fasta ]; then
      cp $s/*complete.graph1.1.path_sequence.fasta $archivedir/$s
    # else first configuration scaffold file, if no complete plastome
    elif [ -f $s/*scaffolds.graph1.1.path_sequence.fasta ]; then
      cp $s/*scaffolds.graph1.1.path_sequence.fasta $archivedir/$s
    fi
  fi
done

# finally, list samples without any sequences
cd $archivedir
noseq=()
for s in *; do
  if [ -d $s ]; then
    if [ ! -f $s/*.fasta ]; then
    noseq+=($s)
    fi
  fi
done
printf "%s\n" "${noseq[@]}" > samples_without_seq.txt


# within data/getorganelle_output, delete all folders and internal files except archive_plastomes
cd ..
rm -rf $(ls | grep -v archive_plastomes)