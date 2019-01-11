require(rmarkdown)
# require(pander)
require(rstudioapi)
#
# rmarkdown::render(input = "SchedulePubMedAnalysis.Rmd", output_format = "html_notebook", output_file = "docs/SchedulePubMedAnalysis.html"
#                    , quiet = TRUE
#                   )

# Sys.sleep(time = 2)
# 
# 
Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/MacOS/pandoc"); rmarkdown::render(input = "/Users/serdarbalciold/RepTemplates/pubmed/SchedulePubMedAnalysis2.Rmd", output_format = "html_notebook", output_file = "/Users/serdarbalciold/RepTemplates/pubmed/docs/SchedulePubMedAnalysis.html", quiet = TRUE)
#
Sys.sleep(time = 2)
#
CommitMessage <- paste("updated on ", Sys.time(), sep = "")
gitCommand <- paste("cd ~/RepTemplates/pubmed/ \n git add . \n git commit --message '", CommitMessage, "' \n git push origin master \n", sep = "")
#
system(command = gitCommand, intern = TRUE)
# Sys.sleep(time = 2)
#
# gitTerm <- rstudioapi::terminalCreate(show = FALSE)
#
# Sys.sleep(time = 2)
#
# rstudioapi::terminalSend(gitTerm, gitCommand)
#