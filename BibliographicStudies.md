---
title: "Bibliographic Studies"
subtitle: "Reproducible Bibliometric Analysis of Pathology Articles Using PubMed, E-direct, WoS, Google Scholar"
author: "Serdar Balcı, MD, Pathologist"
date: '2018-02-20'
output: 
  html_document: 
    code_folding: hide
    df_print: kable
    keep_md: yes
    number_sections: yes
    theme: cerulean
    toc: yes
    toc_float: yes
    highlight: "kate"
---

# Introduction

It is a very common bibliometric study type to retrospectively analyse the number of peer reviewed articles written from a country to view the amount of contribution made in a specific scientific discipline.

These studies require too much effort, since the data is generally behind paywalls and restrictions.

I have previously contributed to a research to identify the Articles from Turkey Published in Pathology Journals Indexed in International Indexes; which is published here: http://www.turkjpath.org/summary_en.php3?id=1423 DOI: 10.5146/tjpath.2010.01006

This study required manually investigating many excel files, which was time consuming and redoing and updating the data and results also require a similar amount of effort.

In order to automatize these type of analysis in a reproducable fashion, 
I will be using
<!-- list of analysis tools -->
R Markdown
,
R Notebook
,
Shiny
and
Terminal
for coding. 
I also plan to use other bibliographic tools like
VOSviewer.

Data will be retrieved from 
PubMed, 
E-direct,
WoS
and
Google Scholar.



---

If you want to see the code used in the analysis please click the code button on the right upper corner or throughout the page. 

I would like to hear your feedback: https://goo.gl/forms/YjGZ5DHgtPlR1RnB3

This document will be continiously updated and the last update was on 2018-02-20.


---

# Analysis




## PubMed Indexed Peer Reviewed Articles in Pathology Journals: A country based comparison

**Aim:**

Here, we are going to compare 3 countries (German, Japan and Turkey), in terms of number of articles in pathology journals during the last decade.

**Methods:**

Pathology Journal ISSN List was retrieved from "InCites Clarivate", and Journal Data Filtered as follows: JCR Year: 2016 Selected Editions: SCIE,SSCI Selected Categories: 'PATHOLOGY' Selected Category Scheme: WoS

Data will be retrieved from PubMed via RISmed package.
PubMed collection from National Library of Medicine (https://www.ncbi.nlm.nih.gov/pubmed/), has the most comprehensive information about peer reviewed articles in medicine.
The API (https://dataguide.nlm.nih.gov/), and R packages are available for getting and fetching data from the server.



```r
# load required packages
library(tidyverse)
library(RISmed)
```



```r
# Get ISSN List from data downloaded from WoS
ISSNList <- JournalHomeGrid <- read_csv("data/JournalHomeGrid.csv", 
                                        skip = 1) %>% 
    select(ISSN) %>% 
    filter(!is.na(ISSN)) %>% 
    t() %>% 
    paste("OR ", collapse = "") # add OR between ISSN List

ISSNList <- gsub(" OR $","" ,ISSNList) # to remove last OR
```



**Result:**





**Comment:**







    

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








# Feedback

[Serdar Balcı, MD, Pathologist](https://github.com/sbalci) would like to hear your feedback: https://goo.gl/forms/YjGZ5DHgtPlR1RnB3

This document will be continiously updated and the last update was on 2018-02-20.

---
