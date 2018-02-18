This document is updated on 2018-02-18

Reproducible Bibliometric Analysis of Pathology Articles
========================================================

### PubMed Indexed Peer Reviewed Articles in Pathology Journals: A country based comparison

It is a very common bibliometric study to retrospectively analyse the
number of peer reviewed articles written from a country to view the
amount of contribution made in a specific scientific discipline.

These studies require too much effort, since the data is generally
behind paywalls and restrictions.

I have previously contributed to a research to identify the Articles
from Turkey Published in Pathology Journals Indexed in International
Indexes; which is published here:
<http://www.turkjpath.org/summary_en.php3?id=1423> DOI:
10.5146/tjpath.2010.01006

This study required manually investigating many excel files, which was
time consuming and redoing and updating the data and results also
require a similar amount of effort.

In order to automatize this analysis, I have used PubMed data from
National Library of Medicine (<https://www.ncbi.nlm.nih.gov/pubmed/>).
This collection has the most comprehensive information about peer
reviewed articles in medicine. It also has an API
(<https://dataguide.nlm.nih.gov/>), and R packages are available for
getting and fetching data from the server.

Pathology Journal ISSN List data was retrieved from “in cites
Clarivate”, and Journal Data Filtered as follows: JCR Year: 2016
Selected Editions: SCIE,SSCI Selected Categories: ‘PATHOLOGY’ Selected
Category Scheme: WoS

Using these data I would like to make reproducible reports and shiny
apps, not only on pathology field but also in other areas of medicine.
This will be very useful to compare disciplines and different nations.

Pathology Journal Articles in PubMed
====================================

(<https://www.ncbi.nlm.nih.gov/pubmed/>)

load required packages
======================

library(tidyverse) library(RISmed) library(ggplot2) library(purrr)

PubMed Query For Pathology Journals AND Countries
=================================================

Load Pathology Journal ISSNs, data retrieved from “incites clarivate:
Journal Data Filtered By: Selected JCR Year: 2016 Selected Editions:
SCIE,SSCI Selected Categories: ‘PATHOLOGY’ Selected Category Scheme: WoS

ISSNList &lt;- JournalHomeGrid &lt;- read\_csv(“JournalHomeGrid.csv”,
skip = 1) %&gt;% select(ISSN) %&gt;% filter(!is.na(ISSN)) %&gt;% t()
%&gt;% paste(“OR”, collapse = “”)

ISSNList &lt;- gsub(" OR $“,”" ,ISSNList)

Generate Search Formula For Pathology Journals AND Countries
============================================================

searchformulaTR &lt;- paste(“‘“,ISSNList,”’”, " AND
“,”Turkey\[Affiliation\]“) searchformulaDE &lt;-
paste(”‘“,ISSNList,”’“,” AND “,”Germany\[Affiliation\]“) searchformulaJP
&lt;- paste(”‘“,ISSNList,”’“,” AND “,”Japan\[Affiliation\]“)

Search PubMed
=============

TurkeyArticles &lt;- EUtilsSummary(searchformulaTR, type = ‘esearch’, db
= ‘pubmed’, mindate = 2007, maxdate = 2017, retmax = 10000) fetchTurkey
&lt;- EUtilsGet(TurkeyArticles)

GermanyArticles &lt;- EUtilsSummary(searchformulaDE, type = ‘esearch’,
db = ‘pubmed’, mindate = 2007, maxdate = 2017, retmax = 10000)
fetchGermany &lt;- EUtilsGet(GermanyArticles)

JapanArticles &lt;- EUtilsSummary(searchformulaJP, type = ‘esearch’, db
= ‘pubmed’, mindate = 2007, maxdate = 2017, retmax = 10000) fetchJapan
&lt;- EUtilsGet(JapanArticles)

Articles per countries per year
===============================

tableTR &lt;- table(YearPubmed(fetchTurkey)) %&gt;% as\_tibble() %&gt;%
rename(Turkey = n, Year = Var1)

tableDE &lt;- table(YearPubmed(fetchGermany)) %&gt;% as\_tibble() %&gt;%
rename(Germany = n, Year = Var1)

tableJP &lt;- table(YearPubmed(fetchJapan)) %&gt;% as\_tibble() %&gt;%
rename(Japan = n, Year = Var1)

articles\_per\_year &lt;- list( tableTR, tableDE, tableJP ) %&gt;%
reduce(left\_join, by = “Year”, .id = “id”) %&gt;% gather(Country, n,
2:4)

articles\_per\_year*C**o**u**n**t**r**y* &lt;  − *f**a**c**t**o**r*(*a**r**t**i**c**l**e**s*<sub>*p*</sub>*e**r*<sub>*y*</sub>*e**a**r*Country,
levels =c(“Japan”, “Germany”, “Turkey”))

Graph 1
-------

ggplot(data = articles\_per\_year, aes(x = Year, y = n, group = Country,
colour = Country, shape = Country, levels = Country )) + geom\_line() +
geom\_point() + labs(x = “Year”, y = “Number of Articles”) +
ggtitle(“Pathology Articles Per Year”) + theme(plot.title =
element\_text(hjust = 0.5), text = element\_text(size = 10))

Articles per journals per country
=================================

ISSNTR &lt;- table(ISSN(fetchTurkey)) %&gt;% as\_tibble() %&gt;%
rename(Turkey = n, Journal = Var1)

ISSNDE &lt;- table(ISSN(fetchGermany)) %&gt;% as\_tibble() %&gt;%
rename(Germany = n, Journal = Var1)

ISSNJP &lt;- table(ISSN(fetchJapan)) %&gt;% as\_tibble() %&gt;%
rename(Japan = n, Journal = Var1)

articles\_per\_journal &lt;- list( ISSNTR, ISSNDE, ISSNJP ) %&gt;%
reduce(left\_join, by = “Journal”, .id = “id”) %&gt;% gather(Country, n,
2:4)

Graph 2
=======

ggplot(data = articles\_per\_journal, aes(x = Journal, y = n, group =
Country, colour = Country, shape = Country, levels = Country )) +
geom\_point() + labs(x = “Journals with decreasing impact factor”, y =
“Number of Articles”) + ggtitle(“Pathology Articles Per Journal”) +
theme(plot.title = element\_text(hjust = 0.5),
axis.text.x=element\_blank())

JournalsTR &lt;- cbind.data.frame(YearPubmed(fetchTurkey),
ISSN(fetchTurkey)) %&gt;% rename( Year = “YearPubmed(fetchTurkey)”, ISSN
= “ISSN(fetchTurkey)”) %&gt;% mutate(Country = “Turkey”)

JournalsDE &lt;- cbind.data.frame(YearPubmed(fetchGermany),
ISSN(fetchGermany)) %&gt;% rename( Year = “YearPubmed(fetchGermany)”,
ISSN = “ISSN(fetchGermany)”) %&gt;% mutate(Country = “Germany”)

JournalsJP &lt;- cbind.data.frame(YearPubmed(fetchJapan),
ISSN(fetchJapan)) %&gt;% rename( Year = “YearPubmed(fetchJapan)”, ISSN =
“ISSN(fetchJapan)”) %&gt;% mutate(Country = “Japan”)

articles\_per\_journal &lt;- union(JournalsTR, JournalsDE) %&gt;%
union(JournalsJP) %&gt;% group\_by(Country, ISSN) %&gt;%
summarise(count=n()) %&gt;% ungroup()

articles\_per\_journal*I**S**S**N* &lt;  − *f**a**c**t**o**r*(*a**r**t**i**c**l**e**s*<sub>*p*</sub>*e**r*<sub>*j*</sub>*o**u**r**n**a**l*ISSN)

### Graph 2

articles\_per\_journal %&gt;% ggplot(aes(x = ISSN, y = count, group =
Country, colour = Country, shape = Country)) + geom\_point()

     labs(x = "ISSN", y = "Number of Articles") +
     ggtitle("Pathology Articles Per Journal") +
     theme(plot.title = element_text(hjust = 0.5))

Materials and Methods Used For This Analyses
============================================

The Insider’s Guide to Accessing NLM Data
-----------------------------------------

### “Welcome to E-utilities for PubMed” Class Materials

<https://dataguide.nlm.nih.gov/classes/intro/materials.html>

> Webinar Recording
> <https://dataguide.nlm.nih.gov/classes/intro/recording.html>

> “Welcome to E-utilities for PubMed” Sample Code for Class Exercises
> <https://dataguide.nlm.nih.gov/classes/intro/samplecode.html>

#### Sample Codes

Find the current “most active” authors for a given topic Goal:

Find out who the “hot” authors are on a given topic. We are looking for
authors that have written the most papers recently (i.e. in the last two
years), on a specific subject. (For this example, we are looking at
papers about diabetes and pregnancy.) Solution:

    esearch -db pubmed -query "(diabetes AND pregnancy) AND (\"2015/01/01\"[PDAT] : \"2017/12/31\"[PDAT])" | \
    efetch -format xml | \
    xtract -pattern Author -sep " " -element LastName,Initials | \
    sort-uniq-count-rank | \
    head -n 10

[https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=“science](https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=“science)”\[journal\]+AND+breast+cancer+AND+2008\[pdat\]

[https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=“nature](https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=“nature)”\[journal\]+AND+breast+cancer+AND+2008\[pdat\]

<https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=11748933,11700088&retmode=text&rettype=abstract>

<https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=11748933,11700088&retmode=xml&rettype=abstract>

This series of commands searches PubMed for the string “(diabetes AND
pregnancy) AND (”2015/01/01“\[PDAT\] :”2017/12/31“\[PDAT\])”, retrieves
the full XML records for each of the search results, extracts the last
name and initials of every author on every record, sorts the authors by
frequency of occurrence in the results set, and presents the top ten
most frequently-occurring authors, along with the number of times that
author appeared. Discussion:

esearch -db pubmed -query “(diabetes AND pregnancy) AND
("2015/01/01"\[PDAT\] : "2017/12/31"\[PDAT\])” \|  

The first line of this command uses esearch to search PubMed (-db
pubmed) for our search query (-query “(diabetes AND pregnancy) AND
("2015/01/01"\[PDAT\] : "2017/12/31"\[PDAT\])”). Our search query is
constructed almost exactly like we would construct it in PubMed: we have
a topic string (“diabetes AND pregnancy”) enclosed in parentheses and
ANDed together with a date range. However, the double quotation marks
(“) in our search string pose a problem. We need to”escape“ the double
quotation marks (”) in our search query by putting a “” before them.
This tells EDirect to interpret the quotation marks as just another
character, and not a special character that marks the end of the -query
argument. Otherwise, EDirect would interpret the double quotation marks
before the first date as marking the end of the search query, and the
rest of the query would not be searched.

The “\|” character pipes the results of our esearch into our next
command, and the “” character at the end of the line allows us to
continue our string of commands on the next line, for easier-to-read
formatting.

efetch -format xml \|  

The second line takes the esearch results from our first line and uses
efetch to retrieve the full records for each of our results in the XML
format (-format xml), and pipes the XML output to the next line.

xtract -pattern Author -sep " " -element LastName,Initials \|  

The third line uses the xtract command to retrieve only the elements we
need from the XML output, and display those elements in a tabular
format. The -pattern command indicates that we should start a new row
for every author (-pattern Author). Even if there are multiple authors
on a single citation, each author will be on a new line, rather than
putting all authors for the same citation on the same line. The command
then extracts each author’s last name and initials (-element
LastName,Initials) and separates the two elements with a single space
(-sep " “). This will output a list of authors’ names and initials, one
author per line, and will pipe the list to the next line.

sort-uniq-count-rank \|  

The fourth line uses a special EDirect function (sort-uniq-count-rank)
to sort the list of authors received from the previous line, grouping
together the duplicates. The function then counts how many occurrences
there are of each unique author, removes the duplicate authors, and then
sorts the list of unique authors by how frequently they occur, with the
most frequent authors at the top. The function also returns the
numerical count, making it easier to quantify how frequently each author
occurs in the data set.

head -n 10

The fifth line, which is optional, shows us only the first ten rows from
the output of the sort-uniq-count-rank function (head -n 10). Because
this function puts the most frequently occurring authors first, this
will show us only the ten most frequently occurring authors in our
search results set. To show more or fewer rows, adjust the “10” up or
down. If you want to see all of the authors, regardless of how
frequently they appear, remove this line entirely. (If you do choose to
remove this line, make sure you also remove the “\|” and “” characters
from the previous line. Otherwise, the system will wait for you to
finish entering your command.) Generate list of funding agencies who are
most active in funding a particular topic Goal:

Find out which funding agencies have been funding research on a given
topic. We are looking for agencies that are associated with papers
published recently (i.e. in the last two years), on a specific subject.
(For this example, we are looking at papers about diabetes and
pregnancy.) Solution:

esearch -db pubmed -query “(diabetes AND pregnancy) AND
("2015/01/01"\[PDAT\] : "2017/12/31"\[PDAT\])” \|  
efetch -format xml \|  
xtract -pattern Grant -element Agency \|  
sort-uniq-count-rank \|  
head -n 10

This series of commands searches PubMed for the string “(diabetes AND
pregnancy) AND (”2015/01/01“\[PDAT\] :”2017/12/31“\[PDAT\])”, retrieves
the full XML records for each of the search results, extracts the
funding agency for every grant listed on every record, sorts the funding
agencies by frequency of occurrence in the results set, and presents the
top ten most frequently-occurring agencies, along with the number of
times that agency appeared. Discussion:

esearch -db pubmed -query “(diabetes AND pregnancy) AND
("2015/01/01"\[PDAT\] : "2017/12/31"\[PDAT\])” \|  

The first line of this command uses esearch to search PubMed (-db
pubmed) for our search query (-query “(diabetes AND pregnancy) AND
("2015/01/01"\[PDAT\] : "2017/12/31"\[PDAT\])”). Our search query is
constructed almost exactly like we would construct it in PubMed: we have
a topic string (“diabetes AND pregnancy”) enclosed in parentheses and
ANDed together with a date range. However, the double quotation marks
(“) in our search string pose a problem. We need to”escape“ the double
quotation marks (”) in our search query by putting a “” before them.
This tells EDirect to interpret the quotation marks as just another
character, and not a special character that marks the end of the -query
argument. Otherwise, EDirect would interpret the double quotation marks
before the first date as marking the end of the search query, and the
rest of the query would not be searched.

The “\|” character pipes the results of our esearch into our next
command, and the “” character at the end of the line allows us to
continue our string of commands on the next line, for easier-to-read
formatting.

efetch -format xml \|  

The second line takes the esearch results from our first line and uses
efetch to retrieve the full records for each of our results in the XML
format (-format xml), and pipes the XML output to the next line.

xtract -pattern Grant -element Agency \|  

The third line uses the xtract command to retrieve only the elements we
need from the XML output, and display those elements in a tabular
format. The -pattern command indicates that we should start a new row
for every grant (-pattern Grant). Even if there are multiple grants on a
single citation, each grant will be on a new line, rather than putting
all grants for the same citation on the same line. The command then
extracts each grant’s funding agency (-element Agency). This will output
a list of agencies, one agency per line, and will pipe the list to the
next line.

sort-uniq-count-rank \|  

The fourth line uses a special EDirect function (sort-uniq-count-rank)
to sort the list of agencies received from the previous line, grouping
together the duplicates. The function then counts how many occurrences
there are of each unique agency, removes the duplicate agencies, and
then sorts the list of unique agencies by how frequently they occur,
with the most frequent agencies at the top. The function also returns
the numerical count, making it easier to quantify how frequently each
agency occurs in the data set.

head -n 10

The fifth line, which is optional, shows us only the first ten rows from
the output of the sort-uniq-count-rank function (head -n 10). Because
this function puts the most frequently occurring agencies first, this
will show us only the ten most frequently occurring agencies in our
search results set. To show more or fewer rows, adjust the “10” up or
down. If you want to see all of the agencies, regardless of how
frequently they appear, remove this line entirely. (If you do choose to
remove this line, make sure you also remove the “\|” and “” characters
from the previous line. Otherwise, the system will wait for you to
finish entering your command.) Create a customized version of the
Discovery Bar “Results By Year” histogram, comparing two searches Goal:

In order to recreate the “Results By Year” histogram available in the
PubMed Discovery Bar for a given search, we need to count how many
occurrences of each Publication Year there are in the results set, then
sort those counts by year. To compare the “Results By Year” for two
searches, we need to do this twice, and combine the two outputs. For
this example, the searches we are doing relate to abuse of specific
opioids (“fentanyl abuse” vs. “oxycodone abuse”), and we will restrict
our results to articles published between 1988 and 2017. Solution:

esearch -db pubmed -query “fentanyl abuse” -datetype PDAT -mindate 1988
-maxdate 2017 \|  
efetch -format xml \|  
xtract -pattern PubmedArticle -block PubDate -element Year MedlineDate
\|  
cut -c -4 \|  
sort-uniq-count-rank \|  
sort -n -t $‘’ -k 2 &gt; fentanyl\_abuse.txt

esearch -db pubmed -query “oxycodone abuse” -datetype PDAT -mindate 1988
-maxdate 2017 \|  
efetch -format xml \|  
xtract -pattern PubmedArticle -block PubDate -element Year MedlineDate
\|  
cut -c -4 \|  
sort-uniq-count-rank \|  
sort -n -t $‘’ -k 2 &gt; oxycodone\_abuse.txt

join -j 2 -o 0,1.1,2.1 -a1 -a2 -e0 -t $‘’ &lt;(cat fentanyl\_abuse.txt)
&lt;(cat oxycodone\_abuse.txt) &gt; abuse\_compare.txt

This series of commands searches PubMed for the string “fentanyl abuse”
(restricted to publication dates between 1988 and 2017), retrieves the
full XML records for each of the search results, extracts the year of
publication from each record, counts how frequently each publication
year appears in the results, then re-sorts by chronologically by year.
The results are then saved to a file. The process is repeated for the
string “oxycodone abuse”, and the two files are merged together.

(This example uses some Unix tools like sort, cut, and join that were
not discussed in detail in “Welcome to E-utilities for PubMed”. We will
address some of them in greater detail in our follow-up class, “EDirect
for PubMed”, but you can find a brief description of some of these tools
in the appendices of NCBI’s EDirect documentation, under the heading
“UNIX Utilities.”) Discussion:

esearch -db pubmed -query “fentanyl abuse” -datetype PDAT -mindate 1988
-maxdate 2017 \|  

The first line of this command uses esearch to search PubMed (-db
pubmed) for our search query (-query “fentanyl abuse”). Our search query
is constructed exactly like we would construct it in PubMed: no tags, no
punctuation, no Boolean operators. We simply put in our terms and they
are automatically ANDed together. We use a few more arguments to restict
our results based on publication date (-datetype PDAT -mindate 1988
-maxdate 2017).

The “\|” character pipes the results of our esearch into our next
command, and the “” character at the end of the line allows us to
continue our string of commands on the next line, for easier-to-read
formatting.

efetch -format xml \|  

The second line takes the esearch results from our first line and uses
efetch to retrieve the full records for each of our results in the XML
format (-format xml), and pipes the XML output to the next line.

xtract -pattern PubmedArticle -block PubDate -element Year MedlineDate
\|  

The third line uses the xtract command to retrieve only the elements we
need from the XML output, and display those elements in a tabular
format. The -pattern command indicates that we should start a new row
for each PubMed record (-pattern PubmedArticle). We then want to look in
the PubDate element for each record, and extract either the Year element
or the MedlineDate element (each citation should only have one or the
other; -block PubDate -element Year MedlineDate). Each line in the
output will have either a publication year (from the Year element), or a
publication year followed by a month or other, more specific date
information (from the MedlineDate element). The output will then be
piped to the next line.

cut -c -4 \|  

The fourth line cuts off each line after the fourth character, leaving
only the four digits of the year on each row (cut -c -4). The list of
years is then piped to the next line.

sort-uniq-count-rank \|  

The fifth line uses a special EDirect function (sort-uniq-count-rank) to
sort the list of years received from the previous line, grouping
together the duplicates. The function then counts how many occurrences
there are of each unique year, removes the duplicate years, and then
sorts the list of unique years by how frequently they occur, with the
most frequently occurring years at the top. The function also returns
the numerical count for each year.

sort -n -t $‘’ -k 2 &gt; fentanyl\_abuse.txt

The sixth line then re-sorts the results numerically by the second
column of data (sort -n -t $‘’ -k 2), which is the list of unique years
(the first column of data is the frequency counts generated on the
previous line). The list of years and frequency counts is now sorted
chronologically, and the result is then sent to a file (&gt;
fentanyl\_abuse.txt).

esearch -db pubmed -query “oxycodone abuse” -datetype PDAT -mindate 1988
-maxdate 2017 \|  
efetch -format xml \|  
xtract -pattern PubmedArticle -block PubDate -element Year MedlineDate
\|  
cut -c -4 \|  
sort-uniq-count-rank \|  
sort -n -t $‘’ -k 2 &gt; oxycodone\_abuse.txt

The first six lines are then repeated, substituting out “fentanyl” for
“oxycodone” in both the search string and the output file name.

join -j 2 -o 0,1.1,2.1 -a1 -a2 -e0 -t $‘’ &lt;(cat fentanyl\_abuse.txt)
&lt;(cat oxycodone\_abuse.txt) &gt; abuse\_compare.txt

The final line uses a more advanced Unix command, join, that will allow
us to merge together the two output files according to the values of a
“key” column (in our case, the publication year). Both of our output
files have the publication year in the second column, so we will join
the two files using the second column of each file (join -j 2). We
specify that the “key” column should be output first, followed by the
first column of each file (-o 0,1.1,2.1). We want to make sure to
include all of the publication years that were listed in either results
set, even if they don’t appear in the other (with SQL or other database
querying techniques, this is sometimes referred to as a “full outer
join”; -a1 -a2). If one of the files has no results for a given
publication year, we will output a 0 instead of a blank, and we will
separate the columns in our output by tabs (-e0 -t $‘’).

The last part of the final line tells the join command which files to
merge (&lt;(cat fentanyl\_abuse.txt) &lt;(cat oxycodone\_abuse.txt)) and
where to save the output (&gt; abuse\_compare.txt). If you want to
instead view the results in your terminal window, you can omit the
“&gt;” and everything that follows it on the last line. Find the most
commonly-discussed topics of articles written by authors from a specific
institution Goal:

Find the most common topics for articles written by any author from a
specific institution. For the purposes of this exercise, we will find
the “most common topics” by determining which MeSH headings are most
frequently attached to the records from our institution. This exercise
assumes that the institution has many authors (or many research
components with different names), and that searching for all of the
authors (or all papers with any of the institution’s names listed in the
affiliation data) involves creating a long and complicated search
string. Solutions:

As mentioned before, most use cases have multiple solutions. There is
almost always a way to accomplish 100% of your goal in a single script.
However, there are usually also ways of accomplishing 90%, 75% or 50% of
your goal in a single script, and doing the remaining 10%, 25% or 50%
manually. Each individual user should decide whether the additional time
and effort it will take to get from 90% to 100% is more or less
efficient than simply doing the remaining 10% manually.

With that in mind, we have presented three different solutions below.
Each solution is closer and closer to “perfect.” However, each solution
adds new complexity and new commands which are more powerful, but also
increasingly complicated. We encourage you to read through all three
examples and see if one of them meets your needs, or if one of them
could be adapted to meet your needs. Version 1: Basic

esearch -db pubmed -query “$(cat searchstring.txt)” \|  
efetch -format xml \|  
xtract -pattern DescriptorName -element DescriptorName \|  
sort-uniq-count-rank \|  
head -n 10

This series of commands searches PubMed for a string defined in the text
file “searchstring.txt”, retrieves the full XML records for each of the
search results, extracts each of the MeSH descriptors associated with
every record in the results set, sorts the MeSH headings by frequency of
occurrence in the results set, and presents the top ten most
frequently-occurring MeSH headings, along with the number of times that
heading appears. Discussion:

esearch -db pubmed -query “$(cat searchstring.txt)" \| \\
 The first line uses esearch to search PubMed (-db pubmed). The line uses the Unix command cat to read the entire contents of a file (searchstring.txt) and use it as the search query (-query "$(cat
searchstring.txt)”). This allows us to use a long and complex search
strategy (involving many author names, many institutional names, or
both), and to keep that search string in a separate file. Over time, we
can update the search strategy without having to edit our actual script.
Additionally, it makes the script more readable.

The “\|” character pipes the results of our esearch into our next
command, and the “” character at the end of the line allows us to
continue our string of commands on the next line, for easier-to-read
formatting.

efetch -format xml \|  

The second line takes the esearch results from our first line and uses
efetch to retrieve the full records for each of our results in the XML
format (-format xml), and pipes the XML output to the next line.

xtract -pattern DescriptorName -element DescriptorName \|  

The third line uses the xtract command to retrieve only the elements we
need from the XML output, and display those elements in a tabular
format. The -pattern command indicates that we should start a new row
for every MeSH heading in the results set (-pattern DescriptorName).
Even if there are multiple MeSH headings on a single citation (which
there likely will be), each MeSH heading will be on a new line, rather
than putting all MeSH headings for the same citation on the same line.
The command then extracts the name of each MeSH heading (-element
DescriptorName). This will output a list of MeSH headings, one per line,
and will pipe the list to the next line.

sort-uniq-count-rank \|  

The fourth line uses a special EDirect function (sort-uniq-count-rank)
to sort the list of MeSH headings received from the previous line,
grouping together the duplicates. The function then counts how many
occurrences there are of each unique MeSH heading, removes the duplicate
headings, and then sorts the list of unique headings by how frequently
they occur, with the most frequent headings at the top. The function
also returns the numerical count for each heading.

head -n 10

The fifth line, which is optional, shows us only the first ten rows from
the output of the sort-uniq-count-rank function (head -n 10). Because
this function puts the most frequently occurring MeSH headings first,
this will show us only the ten most frequently occurring headings in our
search results set. To show more or fewer rows, adjust the “10” up or
down. If you want to see all of the headings, regardless of how
frequently they appear, remove this line entirely. (If you do choose to
remove this line, make sure you also remove the “\|” and “” characters
from the previous line. Otherwise, the system will wait for you to
finish entering your command.) Version 2: Intermediate

esearch -db pubmed -query “$(cat searchstring.txt)” \|  
efetch -format xml \|  
xtract -pattern DescriptorName -element DescriptorName \|  
grep -vxf checktags.txt \|  
sort-uniq-count-rank \|  
head -n 10

As you may have noticed in Version 1 (depending on your search terms),
“Humans” was probably among the most common MeSH headings in your
output. Virtually every biomedical article will describe subjects of
research (human or animal; mice or rats, etc.). Clinical articles will
describe treatment, diagnosis, etc. of diseases in patients. These
articles will almost always mention the number of patients, their sex
and age. Experimental articles will almost always mention the species
and sex of the animal subjects.

These concepts, which are mentioned in almost every article, are
designated as “check tags”. Check tags are routinely added to articles
even if they are just mentioned in the article. If you like, you could
just ignore these MeSH headings in your results. However, Version 2 of
this code includes some lines which will automatically remove any
headings that are check tags from your output. Discussion:

esearch -db pubmed -query “$(cat searchstring.txt)” \|  
efetch -format xml \|  
xtract -pattern DescriptorName -element DescriptorName \|  

The first three lines are the same as Version 1, ending with the xtract
command which outputs a list of MeSH headings, one per line, and will
pipe the list to the next line.

grep -vxf checktags.txt \|  

The fourth line uses a very powerful Unix command, grep, which
specializes in matching patterns in text. This line compares each line
of text being piped in from our xtract command against every line in a
specified file, and removes any lines from our xtract which match any of
the lines in the file. The file (“checktags.txt”) contains a list of all
of the MeSH headings which are check tags, with one heading on each
line. You can download the checktags.txt file and use it as is, or you
can modify it to filter out a different set of MeSH headings. The
filtered list of MeSH headings is now piped to the next line.

sort-uniq-count-rank \|  
head -n 10

The remaining lines of Version 2 are the same as Version 1. Version 3:
Advanced

esearch -db pubmed -query “$(cat searchstring.txt)” \|  
efetch -format xml \|  
xtract -pattern DescriptorName -sep “” -element
<DescriptorName@MajorTopicYN>,DescriptorName \|  
grep -vxf nchecktags.txt \|  
cut -c 2- \|  
sort-uniq-count-rank \|  
head -n 10

Version 2 filtered out the check tags from our result. However, while
check tags are often added even if they are just mentioned in an
article, those MeSH headings can sometimes be more central topics to the
article. For example, “pregnancy” is a check tag, which is used to refer
to research involving pregnant subjects. However, “pregnancy” can also
be the main subject of an article. When it is, it will be denoted as a
Major Topic. If we want to be even more precise than Version 2, we could
make sure that we only filter out check tags when they are not the Major
Topic of an article. Discussion:

esearch -db pubmed -query “$(cat searchstring.txt)” \|  
efetch -format xml \|  
xtract -pattern DescriptorName -sep “” -element
<DescriptorName@MajorTopicYN>,DescriptorName \|  

Again, most of Version 3 is the same as Version 2. The first difference
is in the third line. In addition to extracting the DescriptorName, we
are also going to be extracting the attribute “MajorTopicYN” for each
DescriptorName element (-element
<DescriptorName@MajorTopicYN>,DescriptorName). The MajorTopicYN
indicator (which is always either a “Y” if the MeSH heading is a Major
Topic, or “N” if it is not) will be appended to the beginning of the
descriptor name, because we have eliminated the separator between
elements (-sep “”).

grep -vxf nchecktags.txt \|  

Since the output from our xtract now consists of MeSH headings with
either “Y” or “N” in front of them, we also need to edit the file that
contains the check tags we are filtering out (grep -vxf nchecktags.txt).
The new file (nchecktags.txt) is almost identical to the old file, with
the exception that each heading in the file now starts with “N” (e.g.
“Humans” becomes “NHumans”). If any of the headings in the output from
our xtract are Major Topics, they will have a “Y” in front of them, and
will not be filtered out by our N-prefixed check tag file. As before,
the remaining, non-check tag MeSH headings are piped to the next line.

cut -c 2- \|  

Finally, we need to remove our extraneous “Y” and “N” characters from
the front of the remaining MeSH headings (cut -c 2-).

sort-uniq-count-rank \|  
head -n 10

The remaining lines of Version 3 are the same as Version 2. Version 4:
???

Version 3 solved many of the problems, but is still not perfect. It does
not handle MeSH subheadings, for example, and adding “N” to the front of
each of the Check Tags in our filter file is inelegant. There are still
more ways to improve this script, but the 90% of the task that this
accomplishes will hopefully meet your needs. If it doesn’t, feel free to
keep improving it!

> Entrez Programming Utilities Help
> <https://www.ncbi.nlm.nih.gov/books/NBK25501/>

> Entrez Direct: E-utilities on the UNIX Command Line
> <https://www.ncbi.nlm.nih.gov/books/NBK179288/>

### Installing EDirect

<https://dataguide.nlm.nih.gov/edirect/install.html>

#### EDirect installation

To install EDirect, open your Unix terminal and execute the following
commands. (The easiest way to do this is to copy the whole block and
paste it directly into your terminal window.)

    cd ~
    /bin/bash
    perl -MNet::FTP -e \
        '$ftp = new Net::FTP("ftp.ncbi.nlm.nih.gov", Passive => 1);
        $ftp->login; $ftp->binary;
        $ftp->get("/entrez/entrezdirect/edirect.tar.gz");'
    gunzip -c edirect.tar.gz | tar xf -
    rm edirect.tar.gz
    builtin exit
    export PATH=$PATH:$HOME/edirect >& /dev/null || setenv PATH "${PATH}:$HOME/edirect"
    ./edirect/setup.sh

This installs the EDirect software and gets it ready to use. Depending
on your system’s configuration, you may see the following message:

`In order to complete the configuration process, please execute the following:`

followed by a command that looks something like:

`echo "export PATH=\$PATH:\$HOME/edirect" >> $HOME/.bash_profile`

If you see this prompt, copy the command provided and paste it into your
terminal.

Once the installation is complete, you will see the following message in
your terminal window:

`Entrez Direct has been successfully downloaded and installed.`

You can confirm EDirect is installed correctly by using the testing
script below.

To confirm that EDirect is installed and working properly, you can run
your first EDirect script! Just type (or copy and paste) the following
code into your terminal window, and press Enter.

    echo "***********************" > installconfirm
    echo "esearch version:" >> installconfirm
    esearch -version >> installconfirm
    echo "xtract version:" >> installconfirm
    xtract -version >> installconfirm
    echo "EDirect install status:" >> installconfirm
    esearch -db pubmed -query "Babalobi OO[au] AND 2008[pdat]" | \
    efetch -format xml | \
    xtract -pattern Author -if Affiliation -contains Medicine \
    -element Initials >> installconfirm
    echo "***********************" >> installconfirm
    cat installconfirm
    rm installconfirm

The result should be a message similar to the following:

    ***********************
    esearch version:
    7.90
    xtract version:
    7.90
    EDirect install status:
    OK
    ***********************

If you see this output, you have installed EDirect successfully!

### The 9 E-utilities and Associated Parameters

<https://dataguide.nlm.nih.gov/eutilities/utilities.html>

R Libraries
-----------

WoS
---

Google Scholar
--------------
