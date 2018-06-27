#  setwd("/Users/serdarbalciold/preperationFiles/ScheduleRScript/")

# library(knitr)
# library(markdown)
# 
# knit("SchedulePubMedAnalysis.Rmd")
# markdownToHTML("SchedulePubMedAnalysis.md", "docs/SchedulePubMedAnalysis.html")

# setwd("~")

# file.choose()

# library(rmarkdown)
# 
# rmarkdown::render(input = "SchedulePubMedAnalysis.Rmd", output_format = "html_notebook", output_file = "docs/SchedulePubMedAnalysis.html"
#                    , quiet = TRUE
#                   )
# 
# rmarkdown::render(input = "SchedulePubMedAnalysis2.Rmd", output_format = "html_notebook", output_file = "docs/SchedulePubMedAnalysis2.html"
#                    , quiet = TRUE
# )
# 
# CommitMessage <- paste("updated on ", Sys.time(), sep = "")
# gitCommand <- paste("git add . \n git commit --message '", CommitMessage, "' \n git push origin master \n", sep = "")
# 
# gitTerm <- rstudioapi::terminalCreate()
# rstudioapi::terminalSend(
#     gitTerm, gitCommand
# )
# Sys.sleep(1)
# repeat {
#     Sys.sleep(0.1)
#     if (rstudioapi::terminalBusy(gitTerm) == FALSE) {
#         print("Code Executed")
#         break
#     }
# }
# 
# 





# install.packages("git2r")
# 
# CommitMessage <- paste("updated on ", Sys.time(), sep = "")
# 
# path <- "/Users/serdarbalciold/RepTemplates/pubmed/docs"
# 
# init(path = path)
# 
# commit(repo = repo, message = CommitMessage, all = TRUE)
# 
# 
# 
# 
# 
# repo <- repository()
# 
# workdir(repo)
# 
# commits(repo)[[1]]
# head(repo)
# is_head(head(repo))
# is_local(head(repo))
# tags(repo)
# config(repo)
