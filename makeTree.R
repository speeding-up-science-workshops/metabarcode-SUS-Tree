library(phyloseq)
library(tidyverse)
library(plotly)
library(data.table)

library(taxize)
library(ape)

# For the data we picked, no phylogenetic tree was provided, so I constructed one based on the classifications
# Normally, its better to do this from the sequence itself, but no sequence was provided either.
# In order ro get branch lengths, we need to query an outside database. I choose NCBI, because they did provide
# NCBI IDs for most of the taxa. 
# There are repeats and missing data, so the number of taxa is reduced greatly in this process. Since I was 
# mostly interested in creating a tree for a test visualization, I wasn't too concerned. If you are interested in 
# learning Biology from the resulting tree, you'll have to be a lot more careful.



# Get Taxa
taxa <- read_csv('Data_Files/taxa.csv')

# Get list of NCBI IDs
ncbi <- read_csv('Data_Files/OM.CompanionTables.csv')
names(ncbi)[1] <- 'NCBI_ID'


ncbi$pasted <- do.call(paste, c(as.data.frame(ncbi[2:8], sep=";")))

ncbi <- ncbi[!duplicated(ncbi$pasted),]
ncbi$pasted <- NULL



head(ncbi)
# 



# Merge tables together

d <- merge(ncbi, taxa)
d <- as_tibble(d)

d <- arrange(d, NCBI_ID)

# Get rid of duplicates
ncbi_list <- d[!duplicated(d$NCBI_ID),]
ncbi_list <- ncbi_list[!duplicated(ncbi_list$X1),]

Sys.setenv(ENTREZ_KEY = "Your NCBI API Key")

# Query NCBI to get needed info
tax_class <- classification(ncbi_list$NCBI_ID, db = "ncbi")

# Make the tree
tax_tree <- class2tree(tax_class, check = TRUE)

# Test that that all worked
plot(tax_tree)


# I just want the tree part
phylo <- tax_tree$phylo


# Give the tips names that I want. This is a little convoluted, and can probably be cleaned up
# The tip labels have to be the same as in th taxa table, and the OTU table
treeNames <- tax_tree$names
tn <- data.frame(NCBI_ID = treeNames)
tn$NCBI_ID <- as.character(tn$NCBI_ID)
tn$NCBI_ID <- as.numeric(tn$NCBI_ID)

seqList <- data.frame(NCBI_ID = ncbi_list$NCBI_ID, Seq=ncbi_list$X1)

l2 <- left_join(tn, seqList)

phylo$tip.label <- l2$Seq


# Write the tree
ape::write.tree(phylo, file="Data_Files/tree.tre")

