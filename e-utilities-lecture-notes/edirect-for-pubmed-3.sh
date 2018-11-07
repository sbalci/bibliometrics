# ----------------------------------------------------------------------
#     The Insider's Guide to Accessing NLM Data: EDirect for PubMed
# Part Three: Formatting Results and Unix tools
# Course Materials
# https://dataguide.nlm.nih.gov/edirect-for-pubmed-3.txt
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
# TIPS FOR CYGWIN USERS:
# 
# Copy: Ctrl + Insert
# (NOT Ctrl + C!)
# 
# Paste: Shift + Insert
# (NOT Ctrl + V!)
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

-tab and -sep

-tab defines the separator between columns
-sep defines the separator between multiple values in the same columns

The default for both -tab and -sep is "\t" (the tab character)
Changes to -tab and -sep only affect subsequent -element/-first/-last arguments

COMMAND STRING:

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID ISSN LastName

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -tab "\t" -sep "\t" \
-element MedlineCitation/PMID ISSN LastName

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -tab "\t" -sep " " \
-element MedlineCitation/PMID ISSN LastName

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -tab "|" -sep " " \
-element MedlineCitation/PMID ISSN LastName

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -tab "|" -sep "," \
-element MedlineCitation/PMID ISSN LastName

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -tab "|" -sep ", " \
-element MedlineCitation/PMID ISSN LastName

# ----------------------------------------------------------------------
# 
# With -tab/-sep, order matters!
# 
# -tab/-sep only affect subsequent -elements
# 
# Later -tab/-sep overwrite earlier ones
# 
# ----------------------------------------------------------------------

EXERCISE 1
Write an xtract command that:
*	has a new row for each PubMed record
*	has columns for PMID, Journal Title Abbreviation, and Author-supplied Keywords
Each column should be separated by "|"
Multiple keywords in the last column should be separated with commas
Sample Output:

26359634|Elife|Argonaute,RNA silencing,biochemistry,biophysics,human,microRNA,structural biology

Use the following efetch as input:

efetch -db pubmed -id 26359634,24102982,28194521,27794519 -format xml | \
xtract -pattern PubmedArticle -tab "|" -sep "," \
-element MedlineCitation/PMID ISOAbbreviation Keyword




# (ANSWERS TO ALL EXERCISES ARE AT THE BOTTOM OF THIS HANDOUT.)
# 
# ----------------------------------------------------------------------

Authors: First Draft

COMMAND STRING:
efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID LastName Initials

----------------------------------------------------------------------

-block

-block associates multiple child elements of the same parent element in the results

COMMAND STRING:

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID -block Author -element LastName Initials

----------------------------------------------------------------------

What we know so far...


efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -tab "|" -sep ", " \
-element MedlineCitation/PMID ISSN LastName

----------------------------------------------------------------------

Putting two different elements in the same column

Separate multiple -element values with a comma instead of a space.

COMMAND STRING:

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -sep " " -element LastName,Initials

----------------------------------------------------------------------

"-block" resets -tab/-sep to default

COMMAND STRING:

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -tab "|" -element MedlineCitation/PMID \
-block Author -sep " " -element LastName,Initials

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -tab "|" -element MedlineCitation/PMID \
-block Author -tab "|" -sep " " -element LastName,Initials

----------------------------------------------------------------------

EXERCISE 2
Write an xtract command that:
*	Has a new row for each PubMed record
*	Has a column for PMID
*	Lists all of the MeSH headings, separated by "|"
*	If a heading has multiple subheadings attached, separate the heading and subheadings with "/"
Sample Output:
24102982|Cell Fusion|Myoblasts/cytology/metabolism|Muscle Development/physiology

Use the following efetch as input:

efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -tab "|" -element MedlineCitation/PMID \
-block MeshHeading -tab "|" -sep "/" -element MeshHeading/DescriptorName, MeshHeading/QualifierName


efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -tab "|" -element MedlineCitation/PMID \
-block MeshHeading -tab "|" -sep "/" -element DescriptorName,QualifierName


(ANSWERS TO ALL EXERCISES ARE AT THE BOTTOM OF THIS HANDOUT.)

----------------------------------------------------------------------

Saving results to a file

Use ">" to save the output to a file

COMMAND STRING:

efetch -db pubmed -id 24102982,21171099,17150207 -format xml > testfile.txt

efetch -db pubmed -id 24102982,21171099,17150207 -format xml > testfile.xml

----------------------------------------------------------------------

But where is my file!?

Use "pwd" to "Print the Working Directory" (a.k.a display on the screen the name of the directory you are working in). This is where your file was saved.

CYGWIN USERS:

Your working directory is probably a subfolder of the folder where you installed Cygwin. In Cygwin, try:

cygpath -w ~

MAC USERS:

Your working directory is probably in your Users folder:

Users/<your user name>

----------------------------------------------------------------------

Another way to find your files

COMMAND STRING:

efetch -db pubmed -id 24102982,21171099,25359968,17150207 -format uid > specialname.csv

Use "ls" to list the files in your current directory.

----------------------------------------------------------------------

EXERCISE 3: Retrieving XML 
How can I get the full XML of all articles about the relationship of Zika Virus to microcephaly in Brazil?  Save your results to a file.

(ANSWERS TO ALL EXERCISES ARE AT THE BOTTOM OF THIS HANDOUT.)

----------------------------------------------------------------------

cat

Short for concatenate, "cat" opens files to display them on the screen. "cat" can also combine/append files


----------------------------------------------------------------------

Reading a search string from a file 

Use "$(cat filename)" to use the contents of a file in a command

COMMAND STRING:

esearch -db pubmed -query "$(cat searchstring.txt)"

----------------------------------------------------------------------

epost uploads a list of PMIDs to the history server

COMMAND STRING:

epost -db pubmed -id 24102982,21171099

epost -db pubmed -id 24102982,21171099 | efetch -format abstract

----------------------------------------------------------------------

An epost-efetch pipeline

cat specialname.csv | epost -db pubmed | efetch -format abstract

Using the -input argument

epost -db pubmed -input specialname.csv | efetch -format abstract
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

HOMEWORK FOR PART THREE
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
(Answers are available at: https://dataguide.nlm.nih.gov/classes/edirect-for-pubmed/samplecode3.html)
-----------------------------------------------------------------------
Question 1:

In the PubMed XML of each record, there is a <History> element, with one or more <PubmedPubDate> elements which provide dates for various stages in each article's life cycle. These can include when the article was submitted to the publisher for review, when the article was accepted by the publisher for publication, when it was added to PubMed, and/or when it was indexed for MEDLINE, among others. Not all citations will include entries for each type of date.

For the following list of PMIDs

22389010
20060130
14678125
19750182
19042713
18586245

write a series of commands that retrieves each record and extracts all of these different dates, along with the labels that indicate which type of date is which.

Each PubMed record should appear on a separate line. Each line should start with the PMID, followed by a tab, followed by the list of dates. For each date, include the label, followed by a ":", followed by the year, month and day, separated by slashes. Separate each date with a "|".

Example output:
    
    18586245        received:2008/01/21|revised:2008/05/05|accepted:2008/05/07|pubmed:2008/7/1|medline:2008/10/28|entrez:2008/7/1

-----------------------------------------------------------------------
    Question 2: 
    
    Identify your "working directory". Write a series of commands that retrieve PubMed data, redirect the output to a file, and locate the file on your computer.

-----------------------------------------------------------------------
    Question 3:
    
    Write a series of commands that identifies the top ten agencies that have most frequently funded published research on diabetes and pregnancy over the last year and a half. Your script should start with a search for articles about diabetes and pregnancy that were published between January 1, 2016 and June 30, 2017, should extract the agencies listed as funders on each citation, and should output a list of the ten most frequently occurring agencies. Save the results to a file.

Note: This script may take some time to run. As you build it, consider testing with small set of PubMed records, or with a search that has a smaller date range.

-----------------------------------------------------------------------
    Question 4:
    
    Write a PubMed search strategy and save it to a file. Write a series of commands to search PubMed using the search string contained in the file and retrieve a list of PMIDs for all records which meet the search criteria.

-----------------------------------------------------------------------
    Question 5:
    
    Save the following list of PMIDs in a .csv file:
    
    22389010
20060130
14678125
19750182
19042713
18586245

Write a series of commands to retrieve the full PubMed XML records for all of the PMIDs in the file, and save the resulting XML to a .xml file.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    EXERCISE SOLUTIONS:
    -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    EXERCISE 1
Write an xtract command that:
    *	has a new row for each PubMed recprd
*	has columns for PMID, Journal Title Abbreviation, and Author-supplied Keywords
Each column should be separated by "|"
Multiple keywords in the last column should be separated with commas
Sample Output:
    
    26359634|Elife|Argonaute,RNA silencing,biochemistry,biophysics,human,microRNA,structural biology


SOLUTION:
    
    efetch -db pubmed -id 26359634,24102982,28194521,27794519 -format xml | \
xtract -pattern PubmedArticle -tab "|" -sep "," -element MedlineCitation/PMID ISOAbbreviation Keyword

-=-=-=-=-=-=-=-=-=-=-=-=-
    EXERCISE 2:
    Write an xtract command that:
    *	Has a new row for each PubMed record
*	Has a column for PMID
*	Lists all of the MeSH headings, separated by "|"
*	If a heading has multiple subheadings attached, separate the heading and subheadings with "/"
Sample Output:
    24102982|Cell Fusion|Myoblasts/cytology/metabolism|Muscle Development/physiology

SOLUTION:
    
    efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \
xtract -pattern PubmedArticle -tab "|" -element MedlineCitation/PMID \
-block MeshHeading -tab "|" -sep "/" -element DescriptorName,QualifierName

-=-=-=-=-=-=-=-=-=-=-=-=-
    EXERCISE 3: Retrieving XML 
How can I get the full XML of all articles about the relationship of Zika Virus to microcephaly in Brazil?  Save your results to a file.

SOLUTION:
    
    esearch -db pubmed \
-query "zika virus microcephaly brazil" | \
efetch -format xml > zika.xml