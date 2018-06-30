library(rmarkdown)
library(pander)
library(rstudioapi)


# rmarkdown::render(input = "SchedulePubMedAnalysis.Rmd", output_format = "html_notebook", output_file = "docs/SchedulePubMedAnalysis.html"
#                    , quiet = TRUE
#                   )

# Sys.sleep(time = 2)

rmarkdown::render(input = "SchedulePubMedAnalysis2.Rmd", output_format = "html_notebook", output_file = "docs/SchedulePubMedAnalysis.html"
                   , quiet = TRUE
)

Sys.sleep(time = 2)

CommitMessage <- paste("updated on ", Sys.time(), sep = "")
gitCommand <- paste("git add . \n git commit --message '", CommitMessage, "' \n git push origin master \n", sep = "")

Sys.sleep(time = 2)

gitTerm <- rstudioapi::terminalCreate(show = FALSE)

Sys.sleep(time = 2)

rstudioapi::terminalSend(gitTerm, gitCommand)


