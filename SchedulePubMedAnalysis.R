library(rmarkdown)

rmarkdown::render(input = "SchedulePubMedAnalysis.Rmd", output_format = "html_notebook", output_file = "docs/SchedulePubMedAnalysis.html"
                   , quiet = TRUE
                  )

rmarkdown::render(input = "SchedulePubMedAnalysis2.Rmd", output_format = "html_notebook", output_file = "docs/SchedulePubMedAnalysis2.html"
                   , quiet = TRUE
)

