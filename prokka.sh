
for sample in fastas/*.fasta; do \
	prokka --outdir 'annot/'$(basename $sample .fasta)'/' \
	--prefix $(basename $sample .fasta)  \
	$sample \
    --plasmid IncF ; done


