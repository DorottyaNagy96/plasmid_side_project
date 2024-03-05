install.packages('readr')
install.packages('dplyr')
install.packages('stringr')

library(readr)
library(dplyr)
library(stringr)

setwd('C:/Users/dnagy/OneDrive - Nexus365/Documents/DPhil Clin Medicine/DPhil/F-Plasmid Manuscript')

plsdb <- read_delim("./data/IncF_25kbp_plasmids.tsv", 
                    delim = "\t", escape_double = FALSE, 
                    trim_ws = TRUE, show_col_types = FALSE)
single.replicon <- str_count(plsdb$plasmidfinder,",") ==2
sum(single.replicon)
#3643/10,600 plasmids are single replicon. Also add size filter

plsdb.filtered.100 <- plsdb %>%
  filter(NUCCORE_Topology=="circular", 
         NUCCORE_Length >= 33000,
         str_count(plasmidfinder, ",") == 2) %>%
  group_by(plasmidfinder) %>%
  summarise(plasmidfinder.count = n(),
            mean.length = mean(NUCCORE_Length)) %>%
  arrange(desc(plasmidfinder.count)) %>%
  filter(plasmidfinder.count >= 100)
sum(plsdb.filtered.100$plasmidfinder.count)
#12 groups with >100, but includes a phage plasmid
#19 groups >50

plsdb.filtered.200 <- plsdb %>%
  filter(NUCCORE_Topology=="circular", 
         NUCCORE_Length >= 33000,
         str_count(plasmidfinder, ",") == 2) %>%
  group_by(plasmidfinder) %>%
  summarise(plasmidfinder.count = n(),
            mean.length = mean(NUCCORE_Length)) %>%
  arrange(desc(plasmidfinder.count)) %>%
  filter(plasmidfinder.count >= 200)
sum(plsdb.filtered.200$plasmidfinder.count)
#5 gorups >200
#only 1642/>10,000 plasmids included with specific PlasmidFinder families. See end of script for categoriation into broader categories.

replicons <- plsdb.filtered.200$plasmidfinder

for (p in replicons){
  p.clean <- result <- sub(",.*", "", p)  
   
plsdb.p <- plsdb %>%
    filter(NUCCORE_Topology=="circular", 
    NUCCORE_Length >= 33000,
    str_count(plasmidfinder, ",") == 2) %>%
    filter(plasmidfinder==p) %>%
    select(NUCCORE_ACC)
    
  dir.create("./output", showWarnings = FALSE)

  directory.path <- paste("./output/", p.clean, sep="")
  dir.create(directory.path, showWarnings = FALSE)
  
  plasmid.file.path <- paste("./output/", p.clean, "/", p.clean, "_plasmid_accessions.txt", sep="")
  plasmid.accessions <- file(plasmid.file.path, "w")
  writeLines(as.character(plsdb.p$NUCCORE_ACC), plasmid.accessions)
  close(plasmid.accessions)
 }


#Now categorise into broader groups eg IncFIA, IB, IC, II
#plsdb <- plsdb %>%
 # mutate(plasmidfinder_6 = substr(plasmidfinder, 1, 6))

#plsdb.filtered.broad <- plsdb %>%
 #filter(NUCCORE_Topology=="circular", 
        #NUCCORE_Length >= 33000,
         #str_count(plasmidfinder, ",") == 2) %>%
  #group_by(plasmidfinder_6) %>%
  #summarise(plasmidfinder.count = n(),
           #mean.length = mean(NUCCORE_Length)) %>%
  #arrange(desc(plasmidfinder.count)) #%>%
 #filter(plasmidfinder.count >= 200)
#sum(plsdb.filtered.broad$plasmidfinder.count)

#replicons.broad <- plsdb.filtered.broad$plasmidfinder_6

