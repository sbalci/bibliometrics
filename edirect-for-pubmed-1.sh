# ----------------------------------------------------------------------
# The Insider's Guide to Accessing NLM Data: EDirect for PubMed
# Part One: Getting PubMed Data
# Course Materials
# https://dataguide.nlm.nih.gov/edirect-for-pubmed-1.txt
# ----------------------------------------------------------------------
# NOTE: Solutions to all exercises are at the bottom of this document.
# ----------------------------------------------------------------------
# 
# Commands are instructions given by a user telling a computer to do something
# 
# Arguments provide input data or modify the behavior of a command
# 
# ----------------------------------------------------------------------
# 
# TIPS FOR CYGWIN USERS:
# 
# Copy: Ctrl + Insert
# (NOT Ctrl + C!)
# 
# Paste: Shift + Insert
# (NOT Ctrl + V!)
# 
# 
# ----------------------------------------------------------------------
# 
# TIPS FOR ALL USERS:
# 
# Ctrl + C "cancels" and gets you back to a prompt
# 
# Up and Down arrow keys allow you to cycle through your recent commands
# 
# clear: clears your screen

clear
esearch -version
# ----------------------------------------------------------------------
# 
# esearch 
# 
# esearch searches a database and returns the unique identifier of every record that meets the search criteria - in this case, PMIDs.
# 
# -db to specify database: -db pubmed
# -query to enter your query in quotes: -query "seasonal affective disorder"
# 
# 
# COMMAND STRING:

esearch -db pubmed -query "seasonal affective disorder"

# PUBMED SEARCH:

# seasonal affective disorder

# ----------------------------------------------------------------------

# Show PubMed's translation of your search terms like you receive in the Search Details in PubMed
# 
# COMMAND STRING:
#     
     esearch -db pubmed -query "seasonal affective disorder" -log
# 
# Details display at end of XML snippit 
# 
# "seasonal affective disorder"[MeSH Terms] OR ("seasonal"[All Fields] AND "affective"[All Fields] AND "disorder"[All Fields]) OR "seasonal affective disorder"[All Fields]
# 
# ----------------------------------------------------------------------
#     
#     Search like you do in PubMed with uppercase Boolean AND/OR/NOT and field tags as needed.
# 
# PUBMED SEARCH:
#     
#     malaria AND jama[journal]
# 
# COMMAND STRING:
#     
     esearch -db pubmed -query "malaria AND jama[journal]"
     
     
     esearch -db pubmed -query "malaria AND jama[journal]" -log
     
     
# 
# ----------------------------------------------------------------------
#     
#     Restricting by Date
# 
# -datetype specifies date field: -datetype PDAT
# -mindate -maxdate specifies range: -mindate 2015 -maxdate 2017 
# 
# COMMAND STRING:
#     
    esearch -db pubmed -query "malaria AND jama[journal]" -datetype PDAT -mindate 2015 -maxdate 2017
# 
# 
# Use backslash "\" to indicate that you have not finished writing the command - it is continued on the next line.
# 
# COMMAND STRING:
# 
# esearch -db pubmed -query "malaria AND jama[journal]" \
# -datetype PDAT -mindate 2015 -maxdate 2017
# 
# ----------------------------------------------------------------------
# 
# Be Careful with Quotes
# 
# PUBMED SEARCH:
# 
# cancer AND science[journal]
# 
# cancer AND "science"[journal]
# 
# 
# COMMAND STRING:
# 
 esearch -db pubmed -query "cancer AND \"science\"[journal]"
# 
# 
# ----------------------------------------------------------------------
#     
#     EXERCISE 1: esearch
# How many Spanish-language articles about diabetes are in PubMed?
#     Hint: use the [lang] field tag
# 
# (ANSWERS TO ALL EXERCISES ARE AT THE BOTTOM OF THIS HANDOUT.)

esearch -db pubmed -query "diabetes AND Spanish[lang]"

esearch -db pubmed -query "diabetes AND Spanish[lang]" -log

esearch -db pubmed -query "diabetes AND Turkish[lang]"

 
# ----------------------------------------------------------------------
#     
#     EXERCISE 2: esearch
# How many articles were written by BH Smith between 2012 and 2017, inclusive?

esearch -db pubmed -query "BH Smith[Author]" -datetype PDAT -mindate 2012 -maxdate 2017

esearch -db pubmed -query "bh smith[Author]" -datetype PDAT -mindate 2012 -maxdate 2017

esearch -db pubmed -query "Balci Serdar[Author]"

esearch -db pubmed -query "Balci Serdar[Author]" -log
     
#     (ANSWERS TO ALL EXERCISES ARE AT THE BOTTOM OF THIS HANDOUT.)
# 
# ----------------------------------------------------------------------
#     
#     efetch 
# 
# efetch retrieves the complete record in the format that you specify.
# 
# -db to specify database: -db pubmed
# -id to specify PMID: -id 25359968
# -format to specify format: -format abstract
# 
# COMMAND STRING:
#     
     efetch -db pubmed -id 25359968 -format abstract

     efetch -db pubmed -id 25359968 -format medline

     efetch -db pubmed -id 25359968 -format xml

     efetch -db pubmed -id 25359968 -format uid

# 
# ----------------------------------------------------------------------
#     
#     efetch Formats
# 
# -format options:
#     
#     MEDLINE
# -format medline
# 
# XML
# -format xml
# 
# PMID list
# -format uid
# 
# Summary
# -format docsum
# ----------------------------------------------------------------------
#     
#     efetch Multiple Records
# 
# Separate multiple PMIDs in the -id argument with commas.
# 
# COMMAND STRING:
#     
     efetch -db pubmed -id 24102982,21171099,17150207 -format abstract

     efetch -db pubmed -id 26024162 -format abstract

# 
# efetch -db pubmed -id 26024162 -format abstract
# 
# ----------------------------------------------------------------------
#     
#     EXERCISE 3: efetch
# Who is the first author listed on the PubMed record 26287646?
#     
#     (ANSWERS TO ALL EXERCISES ARE AT THE BOTTOM OF THIS HANDOUT.)


efetch -db pubmed -id 26287646 -format abstract



 
# ----------------------------------------------------------------------
#     
#     Creating a data pipeline
# 
# Use pipe "|" [Shift + \] to "pipe" the results of one command into the next
# 
# COMMAND STRING:
#     
     esearch -db pubmed -query "asthenopia[mh] AND nursing[sh]" | efetch -format uid

# 
# ----------------------------------------------------------------------
#     
#     EXERCISE 4: Combining Commands
# How do we get a list of PMIDs for all of the articles written by BH Smith between 2012 and 2017?
#     Hint: Use the up arrow to access your previous commands
# Hint: Remember -format uid
# 
# (ANSWERS TO ALL EXERCISES ARE AT THE BOTTOM OF THIS HANDOUT.)

esearch -db pubmed -query "BH Smith[Author]" -datetype PDAT \
-mindate 2012 -maxdate 2017 | efetch -format uid

esearch -db pubmed -query "BH Smith[Author]" -datetype PDAT -mindate 2012 -maxdate 2017 | efetch -format uid

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     HOMEWORK FOR PART ONE
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     (Answers are available at: https://dataguide.nlm.nih.gov/classes/edirect-for-pubmed/samplecode1.html)
# -----------------------------------------------------------------------
#     Question 1:
#     
#     Using EDirect, write a command to find out how many citations are in PubMed for articles about using melatonin to treat sleep disorders.
# 
# -----------------------------------------------------------------------
#     Question 2:
#     
#     How many of the PubMed citations identified in question 2 were added to PubMed (i.e. created) between January 1, 2015 and July 1, 2017?
#     
#     -----------------------------------------------------------------------
#     Question 3:
#     
#     Write a command to retrieve the abstracts of the following PubMed records:
#     
#     27240713
# 27027883
# 22468771
# 20121990
# 
# -----------------------------------------------------------------------
#     Question 4:
#     
#     Modify your answer to Question 3 to retrieve the full XML of all four records.	
# 
# -----------------------------------------------------------------------
#     Question 5:
#     
#     Write a series of commands that retrieves a list of PMIDs for all citations for papers written by the author with the ORCID 0000-0002-1141-6306.
# 
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     EXERCISE SOLUTIONS:
#     -----------------------------------------------------------------------
#     EXERCISE 1: esearch
# How many Spanish-language articles about diabetes are in PubMed?
#     Hint: use the [lang] field tag
# 
# SOLUTION:
#     
#     esearch -db pubmed -query "diabetes AND spanish[lang]"
# 
# -=-=-=-=-=-=-=-=-=-=-=-=-
#     EXERCISE 2: esearch
# How many articles were written by BH Smith between 2012 and 2017, inclusive?
#     Hint: use the [author] field tag
# 
# SOLUTIONS:
#     
#     esearch -db pubmed -query "smith bh[author]" \
# -datetype PDAT -mindate 2012 -maxdate 2017
# 
# esearch -db pubmed -query "smith bh[author] \
# AND (2012/01/01[pdat] : 2017/12/31[pdat])"
# 
# -=-=-=-=-=-=-=-=-=-=-=-=-
#     EXERCISE 3: efetch
# Who is the first author listed on the PubMed record 26287646?
#     
#     SOLUTION:
#     
#     efetch -db pubmed -id 26287646 -format abstract
# 
# The first author is Brennan PF
# 
# -=-=-=-=-=-=-=-=-=-=-=-=-
#     EXERCISE 4: Combining Commands
# How do we get a list of PMIDs for all of the articles written by BH Smith between 2012 and 2017?
#     Hint: Use the up arrow to access your previous commands
# Hint: Remember -format uid
# 
# SOLUTIONS:
#     
#     esearch -db pubmed -query "smith bh[author] AND \
# (2012/01/01[pdat] : 2017/12/31[pdat]" | \
# efetch -format uid
# 
# esearch -db pubmed -query "smith bh[author]" \
# -datetype PDAT -mindate 2012 -maxdate 2017 | \
# efetch -format uid
# 
