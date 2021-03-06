---
title: "Bibliographic Studies"
subtitle: "Reproducible Bibliometric Analysis of Pathology Articles Using PubMed, E-direct, WoS, Google Scholar"
author: "Serdar Balcı, MD, Pathologist"
date: '2018-03-28'
output: 
  html_document: 
    code_folding: hide
    df_print: kable
    highlight: kate
    keep_md: yes
    number_sections: yes
    theme: cerulean
    toc: yes
    toc_float: yes
  html_notebook: 
    code_folding: hide
    fig_caption: yes
    highlight: kate
    number_sections: yes
    theme: cerulean
    toc: yes
    toc_float: yes
---

# Introduction

It is a very common bibliometric study type to retrospectively analyse the number of peer reviewed articles written from a country to view the amount of contribution made in a specific scientific discipline.

These studies require too much effort, since the data is generally behind paywalls and restrictions.

I have previously contributed to a research to identify the Articles from Turkey Published in Pathology Journals Indexed in International Indexes; which is published here: [Turk Patoloji Derg. 2010, 26(2):107-113 doi: 10.5146/tjpath.2010.01006](http://www.turkjpath.org/summary_en.php3?id=1423) 

This study had required manual investigation of many excel files, which was time consuming; also redoing and updating the data and results require a similar amount of effort.

In order to automatize these type of analysis in a reproducable fashion, 
I will be using
<!-- list of analysis tools -->
[R Markdown](https://rmarkdown.rstudio.com/)
,
[R Notebook](https://rmarkdown.rstudio.com/r_notebooks.html)
,
[Shiny](https://shiny.rstudio.com/)
and
[Terminal](https://en.0wikipedia.org/wiki/Terminal_(macOS))
for coding. 
I also plan to use other bibliographic tools like
[VOSviewer](http://www.vosviewer.com/).

Data will be retrieved from 
[PubMed](https://www.ncbi.nlm.nih.gov/pubmed), 
[E-direct](https://dataguide.nlm.nih.gov/edirect/overview.html),
[WoS](www.webofknowledge.com/)
and
[Google Scholar](https://scholar.google.com).



---

If you want to see the code used in the analysis please click the code button on the right upper corner or throughout the page. 

I would like to hear your feedback: https://goo.gl/forms/YjGZ5DHgtPlR1RnB3

This document will be continiously updated and the last update was on 2018-03-28.

---







# Analysis

## Country Based Comparison

To see the analysis comparing number of pathology articles from Turkey, German and Japan see this analysis: [Country Based Comparison](https://sbalci.github.io/pubmed/CountryBasedComparison.html)






---


# Feedback

[Serdar Balcı, MD, Pathologist](https://github.com/sbalci) would like to hear your feedback: https://goo.gl/forms/YjGZ5DHgtPlR1RnB3

This document will be continiously updated and the last update was on 2018-03-28.

---
