# -----------------------------------------------------------------------
# The Insider's Guide to Accessing NLM Data: EDirect for PubMed
# Part Five: Developing and Building Scripts
# Supplemental Course Materials 
# -----------------------------------------------------------------------
# This file contains code blocks and information about Case Studies 2 & 3
# 
# For Case Study 1, see the Part Five handout: edirect-for-pubmed-5.txt
# 
# https://dataguide.nlm.nih.gov/edirect-for-pubmed-5-supplemental.txt
# 
# -----------------------------------------------------------------------

CASE STUDY 2:
Goal: Look at a single author ("Eric D. Peterson") and identify his most frequent co-authors.

CODE BLOCKS:

Phase One: Author Disambiguation

esearch -db pubmed -query "peterson ed[au]"

esearch -db pubmed -query "peterson ed[au]" | \
efetch -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -if LastName -equals Peterson -and Initials -equals ED \
-def "N/A" -element LastName ForeName Identifier

esearch -db pubmed -query "peterson ed[au]" | \
efetch -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -if LastName -equals peterson -and Initials -equals ed \
-and ForeName -is-not "Erik D" \
-element LastName ForeName

esearch -db pubmed -query "peterson ed[au] NOT (peterson erik[fau])"

esearch -db pubmed -query "peterson ed[au] NOT (peterson erik[fau])" | \
efetch -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -if LastName -equals peterson -and Initials -equals ed \
-element LastName ForeName \
-block Investigator -if LastName -equals peterson -and Initials -equals ed \
-element LastName ForeName

esearch -db pubmed -query "peterson ed[au] NOT (peterson erik[fau])" | \
efetch -format xml | \
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -if LastName -equals peterson -and Initials -equals ed \
-element Affiliation \
-block Investigator -if LastName -equals peterson -and Initials -equals ed \
-element Affiliation

Phase Two: Identifying Co-authors

esearch -db pubmed -query "peterson ed[au] NOT (peterson erik[fau])" | \
efetch -format xml | \
xtract -pattern Author -if LastName -is-not Peterson -and Initials -is-not ED -tab " " -element LastName Initials | \
sort-uniq-count-rank

-----------------------------------------------------------------------

CASE STUDY 3:
Goal: Analyze a complex search strategy to identify gaps in the existing strategy and find new search terms to include.

About the strategy: The search is run each week to capture new citations. It searches a list of 300+ veterinary journals, as well as a handful of MeSH subject terms. Both parts of the stratgegy are updated periodically.



CODE BLOCKS:
(NOTE: The following code blocks require having a search strategy saved to a file named "vetjournals.txt" in your home directory. The code will not work properly without that file.)

esearch -db pubmed -query "$(cat vetjournals.txt)" -datetype PDAT -mindate 2017 -maxdate 2017

esearch -db pubmed -query "$(cat vetjournals.txt)" -datetype PDAT -mindate 2017 -maxdate 2017 | \
efetch -format uid

efetch -db pubmed -id 25426834,25319380,24899544 -format xml | \
xtract -pattern MeshHeading -element DescriptorName

DO NOT RUN THE FOLLOWING CODE! 
(It will take several minutes to download such a large set of records in XML!)
***************************************
esearch -db pubmed -query "$(cat vetjournals.txt)" -datetype PDAT -mindate 2017 -maxdate 2017 | \
efetch -format xml | \
xtract -pattern MeshHeading -element DescriptorName | \
sort-uniq-count-rank > descriptors.txt
***************************************
esearch -db pubmed -query "$(cat vetjournals.txt)" -datetype PDAT -mindate 2017 -maxdate 2017 | \
efetch -format xml > vet.xml
***************************************

Note: The following code will only run successfully if you have a file named "vet.xml" that contains PubMed XML in your home directory.

xtract -input vet.xml -pattern MeshHeading -element DescriptorName | sort-uniq-count-rank > descriptors.txt

xtract -input vet.xml -pattern MeshHeading \
-if DescriptorName@MajorTopicYN -equals Y \
-or QualifierName@MajorTopicYN -equals Y -element DescriptorName | \
sort-uniq-count-rank > majortopics.txt

xtract -input vet.xml -pattern Keyword -element Keyword | sort-uniq-count-rank > authorkeywords.txt


xtract vet.xml -pattern Keyword -element Keyword | sort-uniq-count-rank > authorkeywords.txt





