pkgs = c("BiocManager", "tidyverse", "plotly","knitr", "rprojroot", "rmarkdown","scales","taxize", "data.table")
ncores = parallel::detectCores()
install.packages(pkgs, Ncpus = ncores)

BiocManager::install("phyloseq")

