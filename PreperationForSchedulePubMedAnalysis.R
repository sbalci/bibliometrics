#  setwd("/Users/serdarbalciold/preperationFiles/ScheduleRScript/")

# library(knitr)
# library(markdown)
# 
# knit("SchedulePubMedAnalysis.Rmd")
# markdownToHTML("SchedulePubMedAnalysis.md", "docs/SchedulePubMedAnalysis.html")

# setwd("~")

# file.choose()

library(rmarkdown)

rmarkdown::render(input = "SchedulePubMedAnalysis.Rmd", output_format = "html_notebook", output_file = "docs/SchedulePubMedAnalysis.html"
                   , quiet = TRUE
                  )

rmarkdown::render(input = "SchedulePubMedAnalysis2.Rmd", output_format = "html_notebook", output_file = "docs/SchedulePubMedAnalysis2.html"
                   , quiet = TRUE
)

install.packages("git2r")

repo <- repository()

workdir(repo)

commits(repo)[[1]]
head(repo)
is_head(head(repo))
is_local(head(repo))
tags(repo)
config(repo)

CommitMessage <- paste("updated on ", Sys.time(), sep = "")



commit(repo, CommitMessage)

