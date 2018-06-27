library(rmarkdown)

rmarkdown::render(input = "SchedulePubMedAnalysis.Rmd", output_format = "html_notebook", output_file = "docs/SchedulePubMedAnalysis.html"
                   , quiet = TRUE
                  )

rmarkdown::render(input = "SchedulePubMedAnalysis2.Rmd", output_format = "html_notebook", output_file = "docs/SchedulePubMedAnalysis2.html"
                   , quiet = TRUE
)

library(rstudioapi)

CommitMessage <- paste("updated on ", Sys.time(), sep = "")
gitCommand <- paste("git add . \n git commit --message '", CommitMessage, "' \n git push origin master \n", sep = "")

gitTerm <- rstudioapi::terminalCreate()
rstudioapi::terminalSend(
    gitTerm, gitCommand
)
Sys.sleep(1)
repeat {
    Sys.sleep(0.1)
    if (rstudioapi::terminalBusy(gitTerm) == FALSE) {
        print("Code Executed")
        break
    }
}


