# Plasmid project

## Download files 
Data was retrieved from https://ccb-microbe.cs.uni-saarland.de/plsdb/plasmids/
Fileted by choosing only Incf and circular plasmids. 

For the following steps you will need to change the paths, for output paths, I recommend NOT changing it and just outputting wherever 
you are, annoying but it gave me errors. I just moved all the files with mv *.fasta path/you/want later.

Separate each sequence into its own fasta. Prokka seems to prepare one genome per command, check this. 
```bash 
gzcat incf.fna.gz | awk '/^>/{if(x>0) close(x".fasta"); x++;}{print > ("prokka_dir/fastas/"x".fasta")}'
cat all.fna | awk '/^>/{if(x>0) close(x".fasta"); x++;}{print > (""x".fasta")}' 
```
Rename each fasta by its plasmid name: format is plasmid_id.fasta
```bash 
for sample in ./fastas/*.fasta; do mv $sample "$(head -1 $sample | awk '{print $1}' | sed 's/>//g').fasta"; done
```

## setup env and dir
With conda: simply recreate my env
```bash
conda env create -f environment.yml
```

If you download any new packages/software, create a new yaml file 
code 
And then update the GIT. 
```bash
conda env export > environment.yml
```

## prokka 
List databases used by prokka, maybe change to get just AMR and virulence genes?
```bash 
prokka --listdb 
```

Prokka was run with the following code, see prokka.sh. 
```bash
or sample in fastas/*.fasta; do \
	prokka --outdir 'annot/'$(basename $sample .fasta)'/' \
	--prefix $(basename $sample .fasta)  \
	$sample \
    --plasmid IncF ; done
```

check.sh simply checks that every single output folder does not contain an error, as the output is overwhelming. 
```bash
for sample in fastas/*.fasta; do \
	if grep -q "Annotation finished successfully."  \
'annot/'$(basename $sample .fasta)'/'$(basename $sample .fasta)'.log'; then
	: 
	else
    		echo "Alignment failed for " $sample  
	fi; done

```
The .ggfs are too big to fit in the GitHub. 

## Discovery 
See discovery.pdf for discovery analysis, I wanted to take a look at the plasmids and genes. Summary: 
1. Most common genes are present only in 50-70% of plasmids. Hence, panaroo coore at 50%. 
2. Plasmids have on average 40-60 genes, some have very little/many -- remove?
3. Simple T-SNE analysis is not able to differentiate groups, though small clusters do appear.
4. I do not know enough about IncF plasmids and how we can compare them.

## Phylogenetics methodology
### How accurate is panaroo for plasmids? 
- core threshold FAR too high, maybe pan?
### Phylogenetic analysis of plasmids I have taken a look at have been less than 100 plasmids:
- we will need to try various methods and combine/choose the best?
- Comparison of similar genes, the same principle of panarooo but different software: https://www.frontiersin.org/journals/microbiology/articles/10.3389/fmicb.2018.02167/full#h3 . 
- PopPUNK using k-mer differences? https://doi.org/10.1089/mdr.2021.0164 . 
- OSNAp an ORF-based method, where presence and absence of genes is used regardless of actual seq: https://doi.org/10.1016/j.plasmid.2019.102477 . 
- More gene-gene comparison https://doi.org/10.1093/molbev/mss210 . 

## panaroo 
Check for contaminations? But we need a reference genome. Is there one? I guess incf backbone? we could  
try? Depends ont the qc of teh daatbase. Anyway, we can think about this later, as we can remove samples 
from the pipeline at any point. This was NOT run. 
```bash
panaroo-qc -i *.gff -o results -t 3 --graph_type all --ref_db 
refseq.genomes.k21s1000.msh
```

There are so many panaroo parameters, we need to discuss. I guess try mnany and see what yields the best 
phylogenetic tree?
```bash 
panaroo -i *.gff -o panaroo/matrices \
	 --clean-mode strict \  # removes most sources of contaminations, neecessary if we dont QC
	--remove-invalid-genes \ #  ignore invalid annotation 
	-a core / -a pan \ # gene alignment for core/all genes, for plhylo maybe core, for AMR all?
	# paper did -a core
	-- core_threshold 0.98 \ # proportion of samples to classiy gene as core, might change?
	# might want to relax --len_dif_percent and family sequence identify as we are comparing plasmids 
	# from different species?
	--refind_prop_match 0.5 --search_radius 1000 \ # identify missed genes, arises due to inproper 
	# genome assembly, Suppose two clusters geneA and geneB are adjacent in the Panaroo pangenome 
	# graph. If geneA is present in a genome but its neighbour (geneB) is not then Panaroo searches 
	# the sequence surrounding geneA for the presence of geneB, radius = --search_radius. Only a 
	# proportion of the gene is required: --refind_prop_match. 
```

I used the following setup, it did not work. Could be my computer. 
```bash
panaroo -i gff_dir/*.gff -o out_core_std --clean-mode strict -a core 
```

You can also make your own gene model - no as it may introduce biases, esp due to the diversity of our 
plasmids 

## trimAI 

## IQ-TREE
	 

## Comments
To what extent does species affect the type of genes? Or eoclogy of the strain
