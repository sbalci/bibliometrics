# ----------------------------------------------------------------------
#     The Insider's Guide to Accessing NLM Data: EDirect for PubMed
# Part Four: xtract Conditional Arguments
# Course Materials
# https://dataguide.nlm.nih.gov/edirect-for-pubmed-4.txt
# ----------------------------------------------------------------------
# NOTE: Solutions to all exercises are at the bottom of this document.
# ----------------------------------------------------------------------

REMINDERS FROM PART ONE

esearch: Searches a database and returns PMIDs

efetch: Retrieves PubMed records in a variety of formats

Use "|" (Shift + \, pronounced "pipe") to "pipe" the results of one command into the next

----------------------------------------------------------------------

REMINDERS FROM PART TWO

xtract: Pulls data from XML and arranges it in a table

-pattern: Defines rows for xtract

-element: Defines columns for xtract

Identify XML elements by name (e.g. ArticleTitle)

Identify specific child elements with Parent/Child construction (e.g. MedlineCitation/PMID)

Identify attributes with "@" (e.g. MedlineCitation@Status)

----------------------------------------------------------------------

REMINDERS FROM PART THREE

-block: Selects and groups child elements of the same parent

-tab: Defines the separator between columns (default is tab, "\t")

-sep: Defines the separator between values in the same column (default is tab, "\t")

Use ">" to save the output to a file

Use "cat" to pull the contents of a file into the EDirect command

epost: Stores PMIDs to the History Server

----------------------------------------------------------------------

TIPS FOR CYGWIN USERS:

Ctrl + C does not Copy
(Cygwin default for Copy is Ctrl + Insert)

Ctrl + V does not Paste
(Cygwin default for Paste is Shift + Insert)


----------------------------------------------------------------------

TIPS FOR ALL USERS:

Ctrl + C "cancels" and gets you back to a prompt

Up and Down arrow keys allow you to cycle through your recent commands

clear: clears your screen

----------------------------------------------------------------------

If-Then

If the condition is met...
Then, create a new row for the pattern and populate the specified columns.
(If not, skip the pattern and move on to the next one.)

----------------------------------------------------------------------

-if

COMMAND STRING:

efetch -db pubmed -id 27460563,27298442,27392493,27363997,27298443 -format xml

efetch -db pubmed -id 27460563,27298442,27392493,27363997,27298443 -format xml | \
xtract -pattern Author -sep " " -element LastName,Initials Identifier

efetch -db pubmed -id 27460563,27298442,27392493,27363997,27298443 -format xml | \
xtract -pattern Author -if Identifier -sep " " -element LastName,Initials Identifier

----------------------------------------------------------------------

EXERCISE 1:

Write an xtract command that only includes PubMed records if they have MeSH headings
*	One row per PubMed record
*	Two columns: PMID, Citation Status
Hint: Use this efetch to test:

efetch -db pubmed -id 26277396,29313986,19649173,21906097,25380814 -format xml | \
xtract -pattern PubmedArticle -if MeshHeading \
-element MedlineCitation/PMID, MedlineCitation@Status


----------------------------------------------------------------------

-if/-equals

COMMAND STRING:

efetch -db pubmed -id 27460563,27532912,27392493,27363997,24108526 -format xml | \
xtract -pattern PubmedArticle -if ISOAbbreviation -equals JAMA -element Volume Issue

----------------------------------------------------------------------

-if/-equals: Attributes

COMMAND STRING:

efetch -db pubmed -id 27460563,27532912,27392493,27363997,24108526 -format xml | \
xtract -pattern PubmedArticle -if MedlineCitation@Status -equals MEDLINE \
-element MedlineCitation/PMID

----------------------------------------------------------------------

Alternatives to -equals

-contains: Element or attribute contains this string
-starts-with: Element or attribute starts with this string
-ends-with: Element or attribute ends with this string
-is-not: Element or attribute does not match this string

----------------------------------------------------------------------

-if/-contains

COMMAND STRING:

efetch -db pubmed -id 27460563,27532912,27392493,27363997,24108526 -format xml | \
xtract -pattern Author -if Affiliation -contains Japan \
-sep " " -element LastName,Initials Affiliation

----------------------------------------------------------------------

EXERCISE 2:
Write an xtract command that only includes PubMed records for articles published in one of the JAMA journals (e.g. JAMA cardiology, JAMA oncology, etc.)
*	One row per PubMed record
*	Two Columns: PMID, ISOAbbreviation
*	ISOAbbreviation should start with "JAMA"
Hint: Use this efetch to test:

efetch -db pubmed -id 27829097,27829076,19649173,21603067,25380814 -format xml | \
xtract -pattern PubmedArticle -if ISOAbbreviation -starts-with JAMA \
-element MedlineCitation/PMID ISOAbbreviation

----------------------------------------------------------------------

-if in a -block

COMMAND STRING:

efetch -db pubmed -id 16940437,16049336,11972038 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block ArticleId -if ArticleId@IdType -equals doi -element ArticleId

----------------------------------------------------------------------

Combining multiple conditions

-or: at least one condition must be true

-and: all conditions must be true

----------------------------------------------------------------------

-or

COMMAND STRING:

efetch -db pubmed -id 16940437,16049336,11972038 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block ArticleId -if ArticleId@IdType -equals doi \
-or ArticleId@IdType -equals pmc -element ArticleId

----------------------------------------------------------------------

-and

COMMAND STRING:

efetch -db pubmed -id 27798514,24372221,24332497,24307782 -format xml | \
xtract -pattern Author -if LastName -equals Kamal -and Affiliation \
-sep " " -element LastName,Initials Affiliation

efetch -db pubmed -id 27582188,27417495,27409810,27306170,18142192 -format xml | \
xtract -pattern PubmedArticle -if DescriptorName -contains "Zika Virus" \
-and DescriptorName -equals Microcephaly -element MedlineCitation/PMID ArticleTitle

----------------------------------------------------------------------

EXERCISE 3
We want to do a search for author BH Smith, and see the different affiliations that are listed for that author
*	Limit to publications from 2012 through 2017

We only want to see affiliation data for BH Smith, no other authors.

We want our output to be a table of citations with specific data:
*	PMID
*	Author Last Name/Initials (should always be BH Smith)
*	Affiliation Data

Write the whole script (not just the xtract command).


esearch -db pubmed -query "smith bh[Author]" \
-datetype PDAT -mindate 2012 -maxdate 2017 | \
efetch -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -if LastName -equals Smith -and Initials -equals BH -sep " " -element LastName,Initials Affiliation



----------------------------------------------------------------------

-position

Include a -block based on its position:

xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -position first -sep " " -element LastName,Initials

Use -position with an integer, "first" or "last":

-position 3

-position first

-position last

COMMAND STRING:

efetch -db pubmed -id 28594955,28594944,28594945,28594943,28594948,28594957 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -sep " " -element LastName,Initials

efetch -db pubmed -id 28594955,28594944,28594945,28594943,28594948,28594957 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -position first -sep " " -element LastName,Initials

efetch -db pubmed -id 28594955,28594944,28594945,28594943,28594948,28594957 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -position last -sep " " -element LastName,Initials

----------------------------------------------------------------------

Dealing with blanks

Use -def to define a placeholder to replace blank cells

Placement for -def is the same as for -tab/-sep.
*	Subsequent -def arguments overwrite earlier ones.
*	-block arguments clear previous -def arguments.

COMMAND STRING:

efetch -db pubmed -id 28594955,28594944,28594945,28594943,28594948,28594957 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -position first -sep " " -element LastName,Initials Identifier

efetch -db pubmed -id 28594955,28594944,28594945,28594943,28594948,28594957 -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -position first -sep " " -def "N/A" -element LastName,Initials Identifier


----------
**Yes exactly. Suppose I search articles from an institution, then I want to get the position of author from that institution.**
----------


-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
HOMEWORK FOR PART FOUR
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
(Answers are available at: https://dataguide.nlm.nih.gov/classes/edirect-for-pubmed/samplecode4.html)
-----------------------------------------------------------------------
Question 1: 

Fetch the records for the following list of PMIDs:

28197844
28176235
28161874
28183232
28164731
27937077
28118756
27845598
27049596
27710139

Write an xtract command that outputs the PMID and Article Title, but only for records that have a structured abstract. Hint: in PubMed records, structured abstracts are broken up into multiple AbstractText elements, each with their own "NlmCategory" attribute.

-----------------------------------------------------------------------
Question 2:

Modify your command from Question 1 to display the "RESULTS" section of each structured abstract, if there is one, in place of the Article Title. If there is no "RESULTS" section, display just the PMID, leaving the second column blank. Hint: Use the "NlmCategory" attribute to determine whether a particular AbstractText element contains "RESULTS".

-----------------------------------------------------------------------
Question 3:

When indexing a record for MEDLINE, indexers can assign MeSH headings (descriptors) to represent concepts found in an article, and MeSH subheadings (qualifiers) to describe a specific aspect of a concept. Indexers denote some of the assigned MeSH headings as "Major Topics" (i.e. one of the primary topics of the article). When assigning a "Major Topic", the indexer can determine that the heading itself is a major topic, or that a specific heading/subheading pair is a major topic. When a heading/subheading pair is assigned as a Major Topic, only the subheading will be labeled as Major in the PubMed XML.

Write an xtract command that outputs one PubMed record per row. Each row should have the record's PMID and a pipe-delimited list of all of the MeSH Headings the indexers have determined are Major Topics. Note: the list should only include headings (descriptors), not subheadings (qualifiers). However, if a heading/subheading pair is assigned as major, the list should include that heading. 

You can use the following efetch command to retrieve some sample records:
    
    efetch -db pubmed -id 24102982,21171099,17150207 -format xml | \

-----------------------------------------------------------------------
    Question 4:
    
    Write a series of commands to search for articles reporting on clinical trials relating to tularemia and output a table of citations. Each row should include the PMID for an article, as well as the name and affiliation information (if any) for the last author. If the last author does not have affiliation information, put "Not Available" in the last column instead.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    EXERCISE SOLUTIONS:
    -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    EXERCISE 1:
    Write an xtract command that only includes PubMed records if they have MeSH headings
*	One row per PubMed record
*	Two columns: PMID, Citation Status
Hint: Use this efetch to test:
    
    efetch -db pubmed -id 26277396,29313986,19649173,21906097,25380814 -format xml

SOLUTION:
    
    efetch -db pubmed -id 26277396,29313986,19649173,21906097,25380814 -format xml | \
xtract -pattern PubmedArticle -if MeshHeading \
-element MedlineCitation/PMID MedlineCitation@Status

-=-=-=-=-=-=-=-=-=-=-=-=-
    EXERCISE 2:
    Write an xtract command that only includes PubMed records for articles published in one of the JAMA journals (e.g. JAMA cardiology, JAMA oncology, etc.)
*	One row per PubMed record
*	Two Columns: PMID, ISOAbbreviation
*	ISOAbbreviation should start with "JAMA"

efetch -db pubmed -id 27829097,27829076,19649173,21603067,25380814 -format xml

SOLUTION:
    
    efetch -db pubmed -id 27829097,27829076,19649173,21603067,25380814 -format xml | \
xtract -pattern PubmedArticle -if ISOAbbreviation -starts-with JAMA \
-element MedlineCitation/PMID ISOAbbreviation

-=-=-=-=-=-=-=-=-=-=-=-=-
    EXERCISE 3
We want to do a search for author BH Smith, and see the different affiliations that are listed for that author
*	Limit to publications from 2012 through 2017

We only want to see affiliation data for BH Smith, no other authors.

We want our output to be a table of citations with specific data:
    *	PMID
*	Author Last Name/Initials (should always be BH Smith)
*	Affiliation Data

Write the whole script (not just the xtract command).

SOLUTION:
    
    esearch -db pubmed -query "smith bh[Author]" \
-datetype PDAT -mindate 2012 -maxdate 2017 | \
efetch -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -if LastName -equals Smith -and Initials -equals BH -sep " " -element LastName,Initials Affiliation
