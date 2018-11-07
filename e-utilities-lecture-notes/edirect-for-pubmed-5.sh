# ----------------------------------------------------------------------
# The Insider's Guide to Accessing NLM Data: EDirect for PubMed
# Part Five: Developing and Building Scripts
# Course Materials
# https://dataguide.nlm.nih.gov/edirect-for-pubmed-5.txt
# ----------------------------------------------------------------------
# NOTE: Solutions to all exercises are at the bottom of this document.
# ----------------------------------------------------------------------
# 
# REMINDERS FROM PART ONE
# 
# esearch: Searches a database and returns PMIDs
# 
# efetch: Retrieves PubMed records in a variety of formats
# 
# Use "|" (Shift + \, pronounced "pipe") to "pipe" the results of one command into the next
# 
# ----------------------------------------------------------------------
# 
# REMINDERS FROM PART TWO
# 
# xtract: Pulls data from XML and arranges it in a table
# 
# -pattern: Defines rows for xtract
# 
# -element: Defines columns for xtract
# 
# Identify XML elements by name (e.g. ArticleTitle)
# 
# Identify specific child elements with Parent/Child construction (e.g. MedlineCitation/PMID)
# 
# Identify attributes with "@" (e.g. MedlineCitation@Status)
# 
# ----------------------------------------------------------------------
# 
# REMINDERS FROM PART THREE
# 
# -block: Selects and groups child elements of the same parent
# 
# -tab: Defines the separator between columns (default is tab, "\t")
# 
# -sep: Defines the separator between values in the same column (default is tab, "\t")
# 
# Use ">" to save the output to a file
# 
# Use "cat" to pull the contents of a file into the EDirect command
# 
# epost: Stores PMIDs to the History Server
# 
# ----------------------------------------------------------------------
# 
# REMINDERS FROM PART FOUR
# 
# -if: Defines an element/attribute that must be present in order to include a pattern/block.
# (e.g. "If <element> is present in the pattern/block, include pattern/block in the output.")
# 
# -if/-equals: Defines a specific element/attribute that must be equal to a specific value in order to include a pattern/block,
# (e.g. "If an <element> equals [value] in the pattern/block, include pattern/block in the output.")
# 
# 
# Alternatives to -equals: let you define more specific conditions
# -contains: Element or attribute must contain this string
# -starts-with: Element or attribute must start with this string
# -ends-with: Element or attribute must end with this string
# -is-not: Element or attribute must not match this string
# 
# 
# Alternatives to -if: let you combine multiple conditions
# -or: at least one condition must be true
# -and: all conditions must be true
# 
# 
# -position: Includes a block based on its position in a series of blocks.
# Use -position with an integer, "first" or "last":
# 
# ----------------------------------------------------------------------
# 
# TIPS FOR CYGWIN USERS:
# 
# Ctrl + C does not Copy
# (Cygwin default for Copy is Ctrl + Insert)
# 
# Ctrl + V does not Paste
# (Cygwin default for Paste is Shift + Insert)
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
# 
# ----------------------------------------------------------------------
# 
# Tips for Developing a Script
# 
# 1. Identify your goal.
# 	* Identify your input
# 	* Identify your output
# 	* Identify your format
# 2. Choose your tool.
# 3. Decide how much to automate.
# 4. Build one step at a time.
# 
# ----------------------------------------------------------------------
# 
# E-utilities Usage Guidelines and Requirements from NCBI
# https://www.ncbi.nlm.nih.gov/books/NBK25497/#chapter2.Usage_Guidelines_and_Requiremen
# 
# NLM Data Distribution: Download MEDLINE/PubMed Data
# https://www.nlm.nih.gov/databases/download/pubmed_medline.html
# 
# Using EDirect to create a local copy of PubMed
# https://dataguide.nlm.nih.gov/edirect/archive.html
# 
# NCBI Documentation: EDirect: Local Data Cache
# https://www.ncbi.nlm.nih.gov/books/NBK179288/#chapter6.Local_Data_Cache
# 
# ----------------------------------------------------------------------

Case 1: Simple table of data elements

We want a list of articles about breast cancer that were published in 2016 and the first half of 2017 and are linked to ClinicalTrials.gov entries.

For each article we want:
*	PMID
*	NCT Number(s)
*	First Author
*	Journal

----------------------------------------------------------------------

Case Study

COMMAND STRING:

esearch -db pubmed -query "breast cancer AND clinicaltrials.gov[si]"

esearch -db pubmed -query "breast cancer AND clinicaltrials.gov[si]" \
-datetype PDAT -mindate 2017/03/01 -maxdate 2018/02/28

esearch -db pubmed -query "breast cancer AND clinicaltrials.gov[si]" \
-datetype PDAT -mindate 2018/01/01 -maxdate 2018/02/28

efetch -db pubmed -id 29172605,29158011,29136523,29045554,29045543,28918548,28741175,28702218 -format xml

efetch -db pubmed -id 29172605,29158011,29136523,29045554,29045543,28918548,28741175,28702218 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID ISOAbbreviation

efetch -db pubmed -id 29172605,29158011,29136523,29045554,29045543,28918548,28741175,28702218 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID ISOAbbreviation \
-block Author -position first -sep " " -element LastName,Initials

efetch -db pubmed -id 29172605,29158011,29136523,29045554,29045543,28918548,28741175,28702218 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID ISOAbbreviation \
-block Author -position first -sep " " -element LastName,Initials \
-block DataBank -if DataBankName -equals ClinicalTrials.gov \
-sep "|" -element AccessionNumber

CASE STUDY SOLUTION:
esearch -db pubmed -query "breast cancer AND clinicaltrials.gov[si]" \
-datetype PDAT -mindate 2017/03/01 -maxdate 2018/02/28 | \
efetch -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID ISOAbbreviation \
-block Author -position first -sep " " -element LastName,Initials \
-block DataBank -if DataBankName -equals ClinicalTrials.gov \
-sep "|" -element AccessionNumber > clinicaltrials.txt


----------------------------------------------------------------------

**hacettepe different affiliations**



EDirect Cookbook on GitHub
https://ncbi-hackathons.github.io/EDirectCookbook/