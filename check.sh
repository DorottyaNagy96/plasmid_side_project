
for sample in fastas/*.fasta; do \
	if grep -q "Annotation finished successfully."  \
'annot/'$(basename $sample .fasta)'/'$(basename $sample .fasta)'.log'; then
	: 
	else
    		echo "Alignment failed for " $sample  
	fi; done

