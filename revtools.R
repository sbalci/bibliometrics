library(revtools)
data1 <- read_bibliography("data/SerdarBalci-lens-export-ris.ris")

revtools::start_review_window(data1)
screen_abstracts(x = data1)
