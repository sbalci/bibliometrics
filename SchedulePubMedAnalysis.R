#  setwd("/Users/serdarbalciold/preperationFiles/ScheduleRScript/")

library(knitr)
library(markdown)

knit("SchedulePubMedAnalysis.Rmd")
markdownToHTML("SchedulePubMedAnalysis.md", "docs/SchedulePubMedAnalysis.html")



# setwd("~")

# file.choose()
