# Pathology Journal Articles in PubMed (https://www.ncbi.nlm.nih.gov/pubmed/)

# load required packages
library(tidyverse)
library(RISmed)
library(ggplot2)
library(purrr)

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
TurkeyArticles <- EUtilsSummary(searchformulaTR, type = 'esearch', db = 'pubmed', mindate = 2007, maxdate = 2017, retmax = 10000)
fetchTurkey <- EUtilsGet(TurkeyArticles)

GermanyArticles <- EUtilsSummary(searchformulaDE, type = 'esearch', db = 'pubmed', mindate = 2007, maxdate = 2017, retmax = 10000)
fetchGermany <- EUtilsGet(GermanyArticles)

JapanArticles <- EUtilsSummary(searchformulaJP, type = 'esearch', db = 'pubmed', mindate = 2007, maxdate = 2017, retmax = 10000)
fetchJapan <- EUtilsGet(JapanArticles)

# Articles per countries per year
tableTR <- table(YearReceived(fetchTurkey)) %>% 
    as_tibble() %>% 
    rename(Turkey = n)

tableDE <- table(YearReceived(fetchGermany)) %>% 
    as_tibble() %>% 
    rename(Germany = n)

tableJP <- table(YearReceived(fetchJapan)) %>% 
    as_tibble() %>% 
    rename(Japan = n)

articles_per_year <- list(
    tableTR,
    tableDE,
    tableJP
    ) %>%
    reduce(left_join, by = "Var1", .id = "id") %>% 
    gather(Country, n, 2:4) %>% 
    rename(Year = Var1)

## Graph 1 

ggplot(data = articles_per_year, aes(x = Year, y = n, group = Country, colour = Country, shape = Country)) +
    geom_line() +
    geom_point() +
    labs(x = "Year", y = "Number of Articles") +
    ggtitle("Pathology Articles Per Year") +
    theme(plot.title = element_text(hjust = 0.5))

## 





