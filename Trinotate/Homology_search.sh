#!/bin/bash

TransDecoder.LongOrfs -m 10 -t LncRAnalyzer-NPCTs-intersect.fa

mv LncRAnalyzer-NPCTs-intersect.fa.transdecoder_dir transdecoder_dir

rm -rf LncRAnalyzer-NPCTs-intersect.fa.transdecoder_dir.__checkpoints_longorfs/ pipeliner.*

blastx -query LncRAnalyzer-NPCTs-intersect.fa \
  -db ~/NPCTs/uniprot/uniprot_sprot_plants.fa \
  -num_threads 4 \
  -max_target_seqs 1 \
  -outfmt 6 > blastx.outfmt6
  
blastp -query transdecoder_dir/longest_orfs.pep \
  -db ~/NPCTs/uniprot/uniprot_sprot_plants.fa \
  -num_threads 4 \
  -max_target_seqs 1 \
  -outfmt 6 > blastp.outfmt6
  
hmmscan --cpu 6 \
  --domtblout TrinotatePFAM.out \
  ~/NPCTs/Pfam/Pfam-A.hmm  transdecoder_dir/longest_orfs.pep > pfam.log
