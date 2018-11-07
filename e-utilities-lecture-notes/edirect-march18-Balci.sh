EDirect for PubMed Final Exam
DUE: 11:59 PM EDT, March 26, 2018

Serdar Balci

Instructions: 
This exam is completely "open-book" and untimed. Feel free to review any of the recordings, handouts, sample code and/or documentation while answering these questions.

In a text file, write scripts that will answer each of the questions posed below. 

If you get stuck, remember that the instructors will be available to answer questions in our office hours session on Thursday, March 22, at 1 PM ET. If you have questions at any other time, please e-mail us at NLMtrainers@nih.gov.

To submit your exam, save your text file as edirect-march18-XXXXXXX.txt (where XXXXXXX is your last name).

Attach the file to an e-mail, and send it to NLMtrainers@nih.gov no later than the due date specified above. Even if you are unable to answer every question perfectly, we encourage you to submit what you have, so we can provide feedback to help you figure out the rest.

We will review each submission as quickly as possible, and will reply with feedback, and with instructions on how to claim your MLA CE credit.

Thanks for participating in EDirect for PubMed!


Question 1:

Scripps Research Institute


A. One way of evaluating the research output of an organization is by topic.
Write a script that will find articles published in the last two years by
authors affiliated with the Scripps Research Institute, 
and will generate a list of the top 20 MeSH descriptors
most frequently assigned to those articles by indexers.

esearch -db pubmed -query "'Scripps Research Institute'[Affiliation]" \
-datetype PDAT -mindate 2016/03/01 | \
efetch -format xml | \
xtract -pattern DescriptorName -element DescriptorName | \
sort-uniq-count-rank | \
head -n 20



B. Your output for part A may include many MeSH descriptors
that dont seem specifically relevant to this institution
(e.g. Humans, Animals, Male, Female, etc.).
Create another script that will find articles published in the
last two years by authors affiliated with the Scripps Research Institute,
and generates a list of the top 20 MeSH descriptors most frequently assigned
to those articles as Major Topics.
Hint: You may want to review the homework questions from Session 4,
which may give you some ideas as to how to accomplish this.

esearch -db pubmed -query "'Scripps Research Institute'[Affiliation]" \
-datetype PDAT -mindate 2016/03/01 | \
efetch -format xml | \
xtract -pattern DescriptorName -element DescriptorName | \
grep -vxf checktags.txt | \
sort-uniq-count-rank | \
head -n 20






C. Not all articles in PubMed are indexed with MeSH terms.
Another way to evaluate the topical portfolio of an institution
is by looking at the author-supplied keywords.
Create another script that will find articles published
in the last two years by authors affiliated with the Scripps Research Institute,
and generates a list of the top 20 keywords most frequently assigned to those
articles by their authors.
(Note: Because author-supplied keywords are author-supplied,
and are not drawn from a controlled vocabulary,
this method may be less practical as a real-world solution,
without further post-processing. However, its still a good exercise!)

esearch -db pubmed -query "'Scripps Research Institute'[Affiliation]" \
-datetype PDAT -mindate 2016/03/01 | \
efetch -format xml | \
xtract -pattern Keyword -element Keyword | \
sort-uniq-count-rank | \
head -n 20


D. We can also evaluate the output of an institution
by seeing which agencies are funding grants which eventually
leads to published research from its authors. Create 
another script that will find articles published in the last two
years by authors affiliated with the Scripps Research Institute, 
and generates a list of the top 20 funding agencies most frequently
associated with those records.


esearch -db pubmed -query "'Scripps Research Institute'[Affiliation]" \
-datetype PDAT -mindate 2016/03/01 | \
efetch -format xml | \
xtract -pattern Agency -element Agency | \
sort-uniq-count-rank | \
head -n 20



E. Say that instead of evaluating an institution output,
we instead want to evaluate a group of authors.
We know that we will want to re-run this evaluation periodically, 
but that our author list might change. We want to save our search strategy
in a text file instead of including it as part of our script, 
so we can modify it more easily. 
Modify your script from part D to pull the search strategy from a text file.

esearch -db pubmed -query "$(cat authorlist.txt)" \
-datetype PDAT -mindate 2016/03/01 | \
efetch -format xml | \
xtract -pattern Agency -element Agency | \
sort-uniq-count-rank | \
head -n 20




Question 2:

This question tests your ability to output exactly
the data you need from PubMed in a specific format.
We strongly suggest you read the entire question before you begin.

Write a script that generates a list of articles published
in 2016 or 2017 that have been retracted.
Make sure that the output is formatted according to the following guidelines:



A. For each retracted article, the list should  include the PMID for the retracted article,
the name of the retracted article first author, the PMID of the retraction notice and
the citation information of the retraction notice. 

esearch -db pubmed -query "hasretractionin" \
-datetype PDAT -mindate 2016 -maxdate 2017 | \
efetch -format xml |\
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -position first -sep " " -element LastName,Initials \
-block CommentsCorrections -if CommentsCorrections@RefType -equals RetractionIn -element CommentsCorrections/PMID CommentsCorrections/RefSource \
>retractionlist.csv



B. Not every PubMed record includes listed authors.
If a retracted article has no authors listed, exclude it from your results.


C. Some PubMed records list collective or corporate names for some authors,
instead of personal names. If a retracted article has a first author with a collective name,
output the collective name for the first author. If a retracted article has a first author
with a personal name, output the last name and initials, separated by a space.





D. If the retraction notice does not have a PMID,
the output table should have "XXXXXXXX" in place of the retraction notice PMID. 

esearch -db pubmed -query "hasretractionin" \
-datetype PDAT -mindate 2016 -maxdate 2017 | \
efetch -format xml |\
xtract -pattern PubmedArticle -element MedlineCitation/PMID \
-block Author -position first -sep " " -element LastName,Initials \
-block CommentsCorrections -if CommentsCorrections@RefType -equals RetractionIn -def "XXXXXXXX" -element CommentsCorrections/PMID -element CommentsCorrections/RefSource \
>retractionlist.csv


E. Save the output to a text file,
so you can open it in Microsoft Excel or another application.
(PLEASE DO NOT SUBMIT YOUR OUTPUT FILE WITH YOUR EXAM.)

esearch -db pubmed -query "hasretractionin" \
-datetype PDAT -mindate 2016 -maxdate 2017 | \
efetch -format xml |\
xtract -pattern PubmedArticle -if Author -element MedlineCitation/PMID \
-block Author -if Author/CollectiveName -element CollectiveName -block Author -position first -sep " " -element LastName,Initials \
-block CommentsCorrections -if CommentsCorrections@RefType -equals RetractionIn -def "XXXXXXXX" -element CommentsCorrections/PMID -element CommentsCorrections/RefSource \
>retractionlist.txt


Your solution to this question should be a single script
that meets all of the above conditions. To help you get started,
here are some resources that might help you navigate the relevant portions of PubMed data.

Information about searching PubMed for retractions:
https://www.ncbi.nlm.nih.gov/books/NBK3827/#pubmedhelp.Comment_Correction_Type

Information about how retractions are represented in PubMed XML:
https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html#commentscorrections

Information about how author names (personal and collective) are represented in PubMed XML:
https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html#authorlist

Fact Sheet: Errata, Retractions, and Other Linked Citations in PubMed
https://www.nlm.nih.gov/pubs/factsheets/errata.html
