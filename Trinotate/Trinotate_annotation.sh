#!/bin/bash
gene_to_trans="gene_to_tran.txt"
transcript="LncRAnalyzer-NPCTs-intersect.fa"
report="Trinotate.xls"
GO_assignments="Trinotate-GO.txt"

~/Softwares/Trinotate/Trinotate Trinotate.sqlite init --gene_trans_map ${gene_to_trans} --transcript_fasta ${transcript} --transdecoder_pep transdecoder_dir/longest_orfs.pep

~/Softwares/Trinotate/Trinotate Trinotate.sqlite LOAD_swissprot_blastp blastp.outfmt6
~/Softwares/Trinotate/Trinotate Trinotate.sqlite LOAD_swissprot_blastx blastx.outfmt6
~/Softwares/Trinotate/Trinotate Trinotate.sqlite LOAD_pfam TrinotatePFAM.out

~/Softwares/Trinotate/Trinotate Trinotate.sqlite report >  ${report}

extract_GO_assignments_from_Trinotate_xls.pl --Trinotate_xls ${report} --gene --include_ancestral_terms  > ${GO_assignments}
