# ----------------------------------------------------------------------
# The Insider's Guide to Accessing NLM Data: EDirect for PubMed
# Part Two: Extracting Data from XML
# Course Materials
# https://dataguide.nlm.nih.gov/edirect-for-pubmed-2.txt
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
# 
# ----------------------------------------------------------------------
# 
# 
# xtract
# 
# Extracts specific elements from XML and arranges them in a customized tabular format.
# 
# ----------------------------------------------------------------------
# 
# Getting XML
# 
# From efetch:
# 
# [...] | efetch -format xml | xtract [...]
# 
# From a file on your computer using "-input":
# 
# xtract -input file.xml [...]
# 
# ----------------------------------------------------------------------
# 
# XML Element Descriptions 
# https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html 
# 
# PubMed DTD Documentation
# https://dtd.nlm.nih.gov/ncbi/pubmed/out/doc/2018/ 
# 
# ----------------------------------------------------------------------
# 
# Before you start xtract-ing...
# 
# Look at some PubMed XML by searching PubMed for a few PMIDs:
# 
# 24102982,21171099,17150207
# 
# ----------------------------------------------------------------------
# 
# Getting a small sample dataset


efetch -db pubmed -id 24102982,21171099,17150207 -format xml

efetch -db pubmed -id 24102982,21171099,17150207 -format xml &> pubmed2.txt


# ----------------------------------------------------------------------
# 
# -pattern to identify which element will create a new row in the output table
# 
# -element to identify which element(s) or attribute(s) will create columns in the output table
# 
# 
# A basic xtract Command:
# 
# COMMAND STRING:
# 
# **pattern for row, element for column**


efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -element ArticleTitle



efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern Author -element LastName




----------------------------------------------------------------------

Creating multiple columns

Create multiple columns using the same -element argument by including multiple XML element names.
Separate the names with spaces.

Example:

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -element Agency GrantID



----------------------------------------------------------------------

EXERCISE 1:
Write an xtract command that:
*	creates a table with one row per PubMed article.
*	Each row should have two columns:
	*	Volume
	*	Issue Number

Use the following efetch as input:

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -element Volume Issue

efetch -db pubmed -id 27101380 -format xml | \
xtract -pattern PubmedArticle -element PMID Year

PMID references, Year multiple 

efetch -db pubmed -id 27101380 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID Year


(ANSWERS TO ALL EXERCISES ARE AT THE BOTTOM OF THIS HANDOUT.)
	
----------------------------------------------------------------------
Isolating the elements we need

COMMAND STRING:
efetch -db pubmed -id 27101380 -format xml | \
xtract -pattern PubmedArticle -element PMID Year 

----------------------------------------------------------------------

Parent/Child construction

Retrieves only elements that are the child of a specific parent.

Format: ParentElement/ChildElement

Example:
-element MedlineCitation/PMID

----------------------------------------------------------------------

Solving xtract Example 1
We have a set of records
We want a tabular list with PMID, Journal Title Abbreviation, and Article Title

COMMAND STRING:
efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID Journal/ISOAbbreviation ArticleTitle

----------------------------------------------------------------------

xtract-ing attribute values

Format: ElementName@AttributeName

Example:

-element DescriptorName@MajorTopicYN

----------------------------------------------------------------------

EXERCISE 2
Write an xtract command that:
*	Has one row per PubMed records
*	Has three columns:
	*	PMID
	*	Journal ISSN
	*	Citation status

Use the following efetch as input:

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID Journal/ISSN MedlineCitation@Status

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID Journal/ISSN MedlineCitation@Status Author/LastName


(ANSWERS TO ALL EXERCISES ARE AT THE BOTTOM OF THIS HANDOUT.)
	
----------------------------------------------------------------------

EXERCISE 3: Putting it all together

We want to find out which authors have been writing about traumatic brain injuries in athletes
*	Limit to publications from 2016 and 2017.
We want to see just the author names, one per line.
We want the last name and initials, separated by a space.
We want the whole script (not just the xtract command).

esearch -db pubmed -query "traumatic brain injuries athletes" \
-datetype PDAT -mindate 2016 -maxdate 2017 | \
efetch -format xml | \
xtract -pattern Author -element Author/LastName Author/Initials



(ANSWERS TO ALL EXERCISES ARE AT THE BOTTOM OF THIS HANDOUT.)


----------------------------------------------------------------------

sort-uniq-count-rank

Four steps of sort-uniq-count-rank
1. Sorts all of the lines in your input alphabetically by the full contents of the line
2. Eliminates all duplicates, leaving only unique values.
3. Counts up how many of each unique value there were in your input, and provides that frequency count next to each unique value.
4. Re-sorts the unique values in descending order by frequency, so the most frequently occurring values are at the top.

COMMAND STRING:

esearch -db pubmed -query "traumatic brain injury athletes" -datetype PDAT -mindate 2016 -maxdate 2017 | \
efetch -format xml | \
xtract -pattern Author -element LastName Initials | \
sort-uniq-count-rank

----------------------------------------------------------------------

head

Limits output to only the first few lines of input.

Example:

head -n 10
Outputs only the first ten lines of the input.

COMMAND STRING:

esearch -db pubmed -query "traumatic brain injury athletes" -datetype PDAT -mindate 2016 -maxdate 2017 | \
efetch -format xml | \
xtract -pattern Author -element LastName Initials | \
sort-uniq-count-rank | \
head -n 10

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
HOMEWORK FOR PART TWO)
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
(Answers are available at: https://dataguide.nlm.nih.gov/classes/edirect-for-pubmed/samplecode2.html)
-----------------------------------------------------------------------
Question 1:

Using the efetch command below to retrieve PubMed XML, write an xtract command with one record per row, with columns for PMID, Journal Title Abbreviation, Publication Year, Volume, Issue and Page Numbers.

efetch -db pubmed -id 12312644,12262899,11630826,22074095,22077608,21279770,22084910 -format xml

-----------------------------------------------------------------------
Question 2:

Create a table of the authors attached to PubMed record 28341696. The table should include each author's last name, initials, and affiliation information (if listed).

-----------------------------------------------------------------------
Question 3:

Write a series of commands to generate a table of PubMed records for review articles about the paleolithic diet. The table should have one row per citation, and should include columns for the PMID, the citation status, and the article title.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
EXERCISE SOLUTIONS:
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
EXERCISE 1:
Write an xtract command that:
*	creates a table with one row per PubMed article.
*	Each row should have two columns:
	*	Volume
	*	Issue Number

SOLUTION:

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -element Volume Issue

-=-=-=-=-=-=-=-=-=-=-=-=-
EXERCISE 2:
Write an xtract command that:
*	Has one row per PubMed records
*	Has three columns:
	*	PMID
	*	Journal ISSN
	*	Citation status

SOLUTION:

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID Journal/ISSN MedlineCitation@Status


-=-=-=-=-=-=-=-=-=-=-=-=-
EXERCISE 3: Putting it all together

We want to find out which authors have been writing about traumatic brain injuries in athletes
*	Limit to publications from 2016 and 2017.
We want to see just the author names, one per line.
We want the last name and initials, separated by a space.
We want the whole script (not just the xtract command).

SOLUTION:

esearch -db pubmed -query "traumatic brain injury athletes" -datetype PDAT -mindate 2016 -maxdate 2017 | \
efetch -format xml | \
xtract -pattern Author -element LastName Initials

