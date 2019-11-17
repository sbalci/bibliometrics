# MeSH Terms can be retrieved in one column separated by a ;
# This script is to prepare MeSH data for analysis 


library(stringr) # [CRAN] # Simple, Consistent Wrappers for Common String Operations

str_count(string = articles$MeSH, pattern = ";") %>% 
    max()

articles <- articles %>% 
    select(PMID, affiliation, MeSH) %>% 
    separate(col = "MeSH", sep = ";", into = paste0("MeSHTerm", 1:26))


#  reshape MeSH columns
library(reshape2) # [CRAN] # Flexibly Reshape Data: A Reboot of the Reshape Package

DT.m1 <- melt(articles, id.vars = c("PMID", "MeSH")
)

DT.m2 <- DT.m1 %>%
    filter(!is.na(value))

DT.m2$count <- TRUE

DT.m3 <-dcast(DT.m2, PMID + MeSH ~ value, value.var = "count")

DT.m3[is.na(DT.m3)] <- FALSE

articles <- DT.m3




