library(shiny)
library(shinythemes)
library(RISmed)

#ui <- fluidPage()

ui <- fluidPage(
    theme = shinytheme("superhero"),
    #Title
    titlePanel("Pathology Articles From Turkey"),

# I would like to hear your feedback: https://goo.gl/forms/YjGZ5DHgtPlR1RnB3
    
    sidebarLayout(
        #Input() Functions
        sidebarPanel(
            ("Select Journal Properties"),
            #textInput("JName", "Journal Name", value = "Mod Pathol"),
            
            radioButtons(
                "JGroup",
                "Select Journal Group",
                list("Modern Pathology", "AJSP")
            ),
            
            actionButton("dataButton", "Veri Getir"),
            hr(),
            actionButton("PMIDButton", "PMID listesi"),
            hr(),
            actionButton("TitleButton", "Son 10 makalenin başlıkları")
            
        ),
        
        #Output() Functions
        mainPanel(
            Sys.time(),
            ("tarihli Türkiye Adresli Patoloji Makaleleri"),
            hr(),
            textOutput("NumberOfArticles"),
            hr(),
            textOutput("PMIDlist"),
            hr(),
            tableOutput("TitleList")
            
        )
    )
)

#server <- function(input, output) {}
server <- function(input, output) {
    
    
    getarticles <- eventReactive(input$dataButton, {
        searchformula <- switch(input$JGroup,
                                'Modern Pathology' = '"Mod Pathol"[Journal] AND Turkey[Affiliation]',
                                'AJSP' = '"Am J Surg Pathol"[Journal] AND Turkey[Affiliation]')
       
        #swith ile read.txt ile search string getirilebilir mi? dosya www altına kaydedilebilir
        
         articles <-
            EUtilsSummary(searchformula, type = 'esearch', db = 'pubmed')
        
        getarticles <- EUtilsGet(articles)
        getarticles
    })
    
    
    output$NumberOfArticles <- renderText({
        PMIDs <- PMID(getarticles())
        n <- as.character(length(PMIDs))
        a <-
            c("Seçtiğiniz dergi grubunda",
              n,
              "adet makale saptanmıştır.")
        a
    })
    
    output$PMIDlist <- eventReactive(input$PMIDButton, {
        
        PMIDs <- PMID(getarticles())
        a <- c("Makalelerin PMID'leri: ", PMIDs)
        a
        
    })
    
  #  output$TitleList <- renderTable({
  #      Titles <- ArticleTitle(getarticles())
  #      Titles
  #  })
   
    output$TitleList <- renderTable({
        PMIDs <- PMID(getarticles())
        ArticleTitles <- ArticleTitle(getarticles())
        Years <- YearPubmed (getarticles())
        DataArticles <- cbind.data.frame(PMIDs, Years, ArticleTitles)
        DataArticles
    })
    
     
#    output$Titlelist <- eventReactive(input$TitleButton, {
 #       
  #      Titles <- as.data.frame(ArticleTitle(getarticles()))
   #     Titles
        #a <- c("Son 10 makalenin başlıkları:", Titles)
        #a
        
    # })
    
    
    #Tablo 1
#    PMIDs <- PMID(fetchMPtur)
 #   ArticleTitles <- ArticleTitle(fetchMPtur)
#    YearPubmed (fetchMPtur)
  #  MPTurDataArticles <- cbind.data.frame(PMIDs, ArticleTitles)
   # View(MPTurDataArticles)
    
    #Tablo 2 Atıflar
#    Cited(fetchMPtur) 
    
    # Other potentials
    #Author(getarticles())
    #AbstractText(fetchMPtur)
    #Author(fetchMPtur)[[1]]
    #Affiliation(fetchMPtur)
    #Affiliation(fetchMPtur)[[1]]
    #ArticleId(fetchMPtur)
    #ArticleTitle(fetchMPtur)
    #ArticleTitle(fetchMPtur)[1:10]
    
#    Country(fetchMPtur)
#    ELocationID(fetchMPtur)
#    ISOAbbreviation(fetchMPtur)
 #   ISSN(fetchMPtur)
#    ISSNLinking(fetchMPtur)
#    Issue(fetchMPtur)
#    Language(fetchMPtur)
#    Title (fetchMPtur)
#    PublicationType (fetchMPtur)
#    MedlineTA (fetchMPtur)
#    NlmUniqueID (fetchMPtur)
#    ISSNLinking (fetchMPtur)
#    PublicationStatus (fetchMPtur)
#    ArticleId (fetchMPtur)
#    Volume (fetchMPtur)
#    Issue (fetchMPtur)
#    ISOAbbreviation(fetchMPtur) 
#    MedlinePgn (fetchMPtur)
#    Country (fetchMPtur)
    
#    Mesh (fetchMPtur)
    
#    MedlinePgn(fetchMPtur)
#    MedlineTA(fetchMPtur)

#    PublicationStatus(fetchMPtur)
#    PublicationType(fetchMPtur)
#    PublicationType(fetchMPtur)[[10]]

#    Title(fetchMPtur)
#    Volume(fetchMPtur)
#    YearPubmed(fetchMPtur)

    # class(PublicationType(fetchMPtur))
    # list_fetchMPtur <- PublicationType(fetchMPtur)
    # names_mylist <- PMID(fetchMPtur)
    # names(list_fetchMPtur) <- names_mylist
    # list_fetchMPtur
    # list_fetchMPtur$`27586202`[1]
    # list_fetchMPtur$`15073605`[1]
    # list_fetchMPtur$`15073605`[2]
    # as.character(list_fetchMPtur)
    # unique(as.character(list_fetchMPtur))
    
    #xtract PubMed lecture 3'te sadece Turkey adresi olan yazarı çekmek mümkün
    
}


#shinyApp(ui = ui, server = server)
shinyApp(ui = ui, server = server)