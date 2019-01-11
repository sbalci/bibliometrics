---
title: "Bibliographic Studies"
subtitle: "Country Based Comparison"
author: "Serdar Balcı, MD, Pathologist"
date: '2018-06-27'
output: 
  html_notebook: 
    code_folding: hide
    fig_caption: yes
    highlight: kate
    number_sections: yes
    theme: cerulean
    toc: yes
    toc_float: yes
  html_document: 
    code_folding: hide
    df_print: kable
    keep_md: yes
    number_sections: yes
    theme: cerulean
    toc: yes
    toc_float: yes
    highlight: kate
---


# Analysis




## PubMed Indexed Peer Reviewed Articles in Pathology Journals: A country based comparison

**Aim:**

Here, we are going to compare 3 countries (German, Japan and Turkey), in terms of number of articles in pathology journals during the last decade.

**Methods:**

If you want to see the code used in the analysis please click the code button on the right upper corner or throughout the page.


```r
# load required packages
library(tidyverse)
library(RISmed)
```

Pathology Journal ISSN List was retrieved from [In Cites Clarivate](https://jcr.incites.thomsonreuters.com/), and Journal Data Filtered as follows: `JCR Year: 2016 Selected Editions: SCIE,SSCI Selected Categories: 'PATHOLOGY' Selected Category Scheme: WoS`


```r
# Get ISSN List from data downloaded from WoS
ISSNList <- JournalHomeGrid <- read_csv("data/JournalHomeGrid.csv", skip = 1) %>% 
    select(ISSN) %>% filter(!is.na(ISSN)) %>% t() %>% paste("OR ", collapse = "")  # add OR between ISSN List

ISSNList <- gsub(" OR $", "", ISSNList)  # to remove last OR
```

Data is retrieved from PubMed via RISmed package.
PubMed collection from National Library of Medicine (https://www.ncbi.nlm.nih.gov/pubmed/), has the most comprehensive information about peer reviewed articles in medicine.
The API (https://dataguide.nlm.nih.gov/), and R packages are available for getting and fetching data from the server.

The search formula for PubMed is generated as "ISSN List AND Country[Affiliation]" like done in [advanced search of PubMed](https://www.ncbi.nlm.nih.gov/pubmed/advanced).


```r
# Generate Search Formula For Pathology Journals AND Countries
searchformulaTR <- paste("'", ISSNList, "'", " AND ", "Turkey[Affiliation]")
searchformulaDE <- paste("'", ISSNList, "'", " AND ", "Germany[Affiliation]")
searchformulaJP <- paste("'", ISSNList, "'", " AND ", "Japan[Affiliation]")
```


```r
# Search PubMed, Get and Fetch
TurkeyArticles <- EUtilsSummary(searchformulaTR, type = "esearch", db = "pubmed", 
    mindate = 2007, maxdate = 2017, retmax = 10000)
fetchTurkey <- EUtilsGet(TurkeyArticles)

GermanyArticles <- EUtilsSummary(searchformulaDE, type = "esearch", db = "pubmed", 
    mindate = 2007, maxdate = 2017, retmax = 10000)
fetchGermany <- EUtilsGet(GermanyArticles)

JapanArticles <- EUtilsSummary(searchformulaJP, type = "esearch", db = "pubmed", 
    mindate = 2007, maxdate = 2017, retmax = 10000)
fetchJapan <- EUtilsGet(JapanArticles)
```

From the fetched data the year of articles are grouped and counted by country.


```r
# Articles per countries per year
tableTR <- table(YearPubmed(fetchTurkey)) %>% as_tibble() %>% rename(Turkey = n, 
    Year = Var1)

tableDE <- table(YearPubmed(fetchGermany)) %>% as_tibble() %>% rename(Germany = n, 
    Year = Var1)

tableJP <- table(YearPubmed(fetchJapan)) %>% as_tibble() %>% rename(Japan = n, 
    Year = Var1)

# Join Tables
articles_per_year_table <- list(tableTR, tableDE, tableJP) %>% reduce(left_join, 
    by = "Year", .id = "id")
```



```r
# Prepare table for output
articles_per_year <- articles_per_year_table %>% gather(Country, n, 2:4)

articles_per_year$Country <- factor(articles_per_year$Country, levels = c("Japan", 
    "Germany", "Turkey"))
```


**Result:**

In the below table we see the number of articles per country in the last decade.


|Year | Turkey| Germany| Japan|
|:----|------:|-------:|-----:|
|2007 |     75|     402|   694|
|2008 |     89|     314|   620|
|2009 |     89|     364|   636|
|2010 |    100|     347|   661|
|2011 |    108|     386|   731|
|2012 |     79|     389|   666|
|2013 |     79|     415|   758|
|2014 |     93|     465|   733|
|2015 |    140|     466|   753|
|2016 |    140|     419|   683|
|2017 |    106|     422|   659|


And the figure below shows this data in a line graph. 

<img src="figure/Graph of Table of Articles per year per country-1.png" title="plot of chunk Graph of Table of Articles per year per country" alt="plot of chunk Graph of Table of Articles per year per country" style="display: block; margin: auto;" />


**Comment:**

We see that Japan has much more articles than German and Turkey.
Turkey has a small increase in number of articles.

**Future Work:**


* Indentify why Japan has too much articles.
* Compare Japan with other countries.
* Compare Turkey with neighbours, EU, OECD & Middle East countries.
* Analyse multinational studies.
* Analyse adding journal impact as a factor. 

---




# Feedback

[Serdar Balcı, MD, Pathologist](https://github.com/sbalci) would like to hear your feedback: https://goo.gl/forms/YjGZ5DHgtPlR1RnB3

This document will be continiously updated and the last update was on 2018-06-27.

---

# Back to Main Menu

[Main Page for Bibliographic Analysis](https://sbalci.github.io/pubmed/BibliographicStudies.html)
