PMID_26832882 <- RefManageR::ReadPubMed('26832882', database = 'PubMed')

PMID_26362048 <- RefManageR::ReadPubMed('26362048', database = 'PubMed')


PMID_26832882$abstract
PMID_26832882$title
PMID_26832882$author

PMID_26362048$abstract
PMID_26362048$title
PMID_26362048$author


stringdist::stringsim(PMID_26832882$abstract, PMID_26362048$abstract)

stringdist::stringsim(PMID_26832882$title, PMID_26362048$title)


a <- as.vector(unlist(PMID_26832882$author))

a <- paste0(
    gsub(pattern = "\\W*\\b\\w\\b\\W*", replacement = "", x = a), collapse = " "
)


b <- as.vector(unlist(PMID_26362048$author))

b <- paste0(
    gsub(pattern = "\\W*\\b\\w\\b\\W*", replacement = "", x = b), collapse = " "
)

stringdist::stringsim(a, b)

c <- "Calculation of the Ki67 index in pancreatic neuroendocrine tumors: a comparative analysis of four counting methodologies"

d <- "a comparative analysis of four counting Calculation of the in pancreatic neuroendocrine tumors"


stringmethods <- c("osa", "lv", "dl", "hamming", "lcs", "qgram", "cosine", "jaccard", "jw", "soundex")

for (i in stringmethods) {
    z <- stringdist::stringsim(c, d, method = i)    
    print(z)
    }





