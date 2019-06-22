# https://github.com/SurgicalInformatics/pubmed_xml_to_csv

library(easyPubMed)
library(dplyr)
library(stringr)
library(xml2)

# these 3 lines from the easyPubMed vignette
myid = get_pubmed_ids("27145169")
fetch_pubmed_data(myid, format = "xml") %>% 
write_xml("data/gs1_pubmed.xml")
investigators = unlist(xpathApply(gs1_pubmed, "//Investigator", saveXML))

mydata = data_frame(pubmed = investigators)

# and now some library(stringr) magic
# str_match returns 2 columns - the complete match and the capture group
# we only want the capturing group, hence the [, 2]

authors = mydata %>% 
  mutate(
    lastname = str_match(pubmed, "<LastName>(.*?)</LastName>")[,2],
    initials = str_match(pubmed, "<Initials>(.*?)</Initials>")[,2]
    ) %>% 
  select(-pubmed)

# Excel has a bug when displaying utf8 coded CSVs so need to use openxlsx instead
# reader::write_csv(authors, "gs1_pubmed_authors.csv")

openxlsx::write.xlsx(authors, file = "gs1_pubmed_authors.xlsx")

# dups = authors %>% 
#   filter(duplicated(authors))
# 
# openxlsx::write.xlsx(dups, file = "gs1_pubmed_duplicated.xlsx")


