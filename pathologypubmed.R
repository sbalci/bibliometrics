# Pathology Journal Articles in PubMed (https://www.ncbi.nlm.nih.gov/pubmed/)

# load required packages
library(tidyverse)
library(RISmed)
library(ggplot2)

# PubMed Query For Pathology Journals AND Countries

# Load Pathology Journal ISSNs, data retrieved from "incites clarivate:
# Journal Data Filtered By:  Selected JCR Year: 2016
# Selected Editions: SCIE,SSCI Selected Categories: 'PATHOLOGY'
# Selected Category Scheme: WoS"
ISSNList <- JournalHomeGrid <- read_csv("JournalHomeGrid.csv", 
                                        skip = 1) %>% 
    select(ISSN) %>% 
    filter(!is.na(ISSN)) %>% 
    t() %>% 
    paste("OR ", collapse = "")

ISSNList <- gsub(" OR $","" ,ISSNList)
    

# Generate Search Formula For Pathology Journals AND Countries
searchformulaTR <- paste("'",ISSNList,"'", " AND ", "Turkey[Affiliation]")
searchformulaDE <- paste("'",ISSNList,"'", " AND ", "Germany[Affiliation]")
searchformulaJP <- paste("'",ISSNList,"'", " AND ", "Japan[Affiliation]")

# Search PubMed
TurkeyArticles <- EUtilsSummary(searchformulaTR, type = 'esearch', db = 'pubmed', mindate = 2007, maxdate = 2017, retmax=10000)
fetchTurkey <- EUtilsGet(TurkeyArticles)

GermanyArticles <- EUtilsSummary(searchformulaDE, type = 'esearch', db = 'pubmed', mindate = 2007, maxdate = 2017, retmax=10000)
fetchGermany <- EUtilsGet(GermanyArticles)

JapanArticles <- EUtilsSummary(searchformulaJP, type = 'esearch', db = 'pubmed', mindate = 2007, maxdate = 2017, retmax=10000)
fetchJapan <- EUtilsGet(JapanArticles)

# Articles per countries per year
tableTR <- table(YearReceived(fetchTurkey))
tableDE <- table(YearReceived(fetchGermany))
tableJP <- table(YearReceived(fetchJapan))

articles_per_year <- bind_rows(tableTR, tableDE, tableJP)




class(articles_per_year)

rownames_to_column(articles_per_year, var = "rowname")

%>% 
    as_tibble()

colnames(articles_per_year) <- c("TR","DE","JP")



