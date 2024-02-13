#Download files 
Data was retrieved from https://ccb-microbe.cs.uni-saarland.de/plsdb/plasmids/
Fileted by choosing only Incf and circular plasmids

For the following steps you will need to change the paths, for out output paths I reccommend NOT changing it and just outputting whereveer 
you are, annoying but it gave me errors. I just moved all the files with mv *.fasta path/you/want later.

gzcat incf.fna.gz | awk '/^>/{if(x>0) close(x".fasta"); x++;}{print > ("prokka_dir/fastas/"x".fasta")}'
cat all.fna | awk '/^>/{if(x>0) close(x".fasta"); x++;}{print > (""x".fasta")}' 
Separate each sequence into its own fasta. Prokka seems to prepare one genome per command, check this. 

for sample in ./fastas/*.fasta; do mv $sample "$(head -1 $sample | awk '{print $1}' | sed 's/>//g').fasta"; done
Rename each fasta by its plasmid name: format is plasmid_id.fasta

# setup env and dir
With conda: simply recreate my env

If you download any new packages/software, create a new yaml file 
code 
And then update the GIT. 

# prokka 

prokka --listdb 

# Panaroo 
Check for contaminations? But we need a reference genome. Is there one? I guess incf backbone? we could  
try? Depends ont the qc of teh daatbase. Anyways, we can think about this later, as we can remove samples 
form the pieline at any poitn. 
panaroo-qc -i *.gff -o results -t 3 --graph_type all --ref_db 
refseq.genomes.k21s1000.msh

There are so many panaroo parameters, we need to dicuss. I guess try mnany and see what yields best 
phyogenetic tree?

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
 
I used the following setup, it did not work. Could be my computer. 

panaroo -i gff_dir/*.gff -o out_core_std --clean-mode strict -a core 

#trimAI 

# IQ-TREE
	 
You can also make your own gene model - no as it may introduce biases, esp due to the diversity of our 
plasmids 

# Comments
To what extent does species affect the type of genes? Or eoclogy of the strain
