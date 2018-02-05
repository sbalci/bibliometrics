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
# Selected Category Scheme: WoS
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
tableTR <- table(YearPubmed(fetchTurkey)) %>% 
    as_tibble() %>% 
    rename(Turkey = n, Year = Var1)

tableDE <- table(YearPubmed(fetchGermany)) %>% 
    as_tibble() %>% 
    rename(Germany = n, Year = Var1)

tableJP <- table(YearPubmed(fetchJapan)) %>% 
    as_tibble() %>% 
    rename(Japan = n, Year = Var1)

articles_per_year <- list(
    tableTR,
    tableDE,
    tableJP
    ) %>%
    reduce(left_join, by = "Year", .id = "id") %>% 
    gather(Country, n, 2:4)

articles_per_year$Country <- factor(articles_per_year$Country,
                                       levels =c("Japan", "Germany", "Turkey"))

## Graph 1 

ggplot(data = articles_per_year, aes(x = Year, y = n, group = Country,
                                     colour = Country, shape = Country,
                                     levels = Country
                                     )) +
    geom_line() +
    geom_point() +
    labs(x = "Year", y = "Number of Articles") +
    ggtitle("Pathology Articles Per Year") +
    theme(plot.title = element_text(hjust = 0.5), 
          text = element_text(size = 10))


# Articles per journals per country

JournalsTR <- cbind.data.frame(YearPubmed(fetchTurkey), ISSN(fetchTurkey)) %>% 
    rename( Year = "YearPubmed(fetchTurkey)", ISSN = "ISSN(fetchTurkey)")

JournalsDE <- cbind.data.frame(YearPubmed(fetchGermany), ISSN(fetchGermany)) %>% 
    rename( Year = "YearPubmed(fetchGermany)", ISSN = "ISSN(fetchGermany)")

JournalsJP <- cbind.data.frame(YearPubmed(fetchJapan), ISSN(fetchJapan)) %>% 
    rename( Year = "YearPubmed(fetchJapan)", ISSN = "ISSN(fetchJapan)")


# articles_per_journal <- list(
#     JournalsTR,
#     JournalsDE,
#     JournalsJP
# ) %>%
#     reduce(left_join, by = "ISSN", .id = "id") %>% 
#     gather(Country, n, 2:4)
# 
# # Graph 2
# articles_per_journal %>% 
#     filter(n>10 & n<100) %>% 
# ggplot(aes(x = ISSN, y = n, group = Country, colour = Country, shape = Country)) +
#     geom_point() +
#     labs(x = "ISSN", y = "Number of Articles") +
#     ggtitle("Pathology Articles Per Journal") +
#     theme(plot.title = element_text(hjust = 0.5))




