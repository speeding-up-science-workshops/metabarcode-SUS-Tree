library(phyloseq)
library(tidyverse)
library(plotly)
library(data.table)

library(taxize)


library("reshape2")
library("tidyr")
library("plyr")
library("data.table")
library("zoo")
library("taxize")
library("ape")



#otu <- read_csv('Data_Files/otu.csv')

taxa <- read_csv('Data_Files/taxa.csv')


ncbi <- read_csv('Data_Files/OM.CompanionTables.csv')
names(ncbi)[1] <- 'NCBI_ID'



filter(ncbi,`NCBI taxonomy ID` == 64091)


d <- merge(ncbi, taxa)
d <- as_tibble(d)

d <- arrange(d, NCBI_ID)

ncbi_list <- d[!duplicated(d$NCBI_ID),]
ncbi_list <- ncbi_list[!duplicated(ncbi_list$X1),]

tax_class <- classification(ncbi_list$NCBI_ID, db = "ncbi")
tax_tree <- class2tree(tax_class, check = TRUE)
plot(tax_tree)




nl <- ncbi_list$NCBI_ID


nl1 <- nl[c(1:125,150:236)]
nl1 <- nl[150:236]

tc1 <- classification(nl1, db='ncbi')
tax_tree <- class2tree(tc1, check = TRUE)

tcn <- names(tc1)

length(tcn)



taxize::use_entrez()

b77eef804d3cfdf79c86943588dc52449508 


Sys.setenv(ENTREZ_KEY = "b77eef804d3cfdf79c86943588dc52449508")




head(ncbi_list)

filter(ncbi_list, Species == "Desulfospira joergensenii DSM 10085")
filter(ncbi_list, Genus == "Desulfospira") %>% select(Species)
filter(ncbi_list,X1=='Seq6721')

treeNames <- tax_tree$names
tn <- data.frame(NCBI_ID = treeNames)
tn$NCBI_ID <- as.character(tn$NCBI_ID)
tn$NCBI_ID <- as.numeric(tn$NCBI_ID)

head(ncbi_list)

seqList <- data.frame(NCBI_ID = ncbi_list$NCBI_ID, Seq=ncbi_list$X1)

head(seqList)

l2 <- left_join(tn, seqList)

l2
dim(tn)

tax_tree$names <- l2$Seq


phylo <- tax_tree$phylo

phylo$tip.label <- l2$Seq


write.tree(phylo, file="Data_Files/tree.tre")

