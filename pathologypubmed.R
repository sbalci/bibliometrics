# Pathology Journal Articles in PubMed

# load required packages
library(tidyverse)
library(RISmed)
library(ggplot2)

# PubMed Query For Pathology Journals AND Turkey
# Load Pathology Journal ISSNs

# Generate Search Formula
searchformula <- paste("(", J, ")", " AND ", A1)

