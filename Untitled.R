ISSNList2 <- JournalHomeGrid <- read_csv("JournalHomeGrid.csv", 
                                        skip = 1) %>% 
    select(ISSN, `Full Journal Title`) %>% 
    rename(Journal = ISSN)




articles_per_journal2 <- articles_per_journal %>% 
    spread(key = Country, value = n) %>% 
    left_join(ISSNList2, by = "Journal")

write.xlsx(articles_per_journal2, "articles_per_journal_2.xlsx")
