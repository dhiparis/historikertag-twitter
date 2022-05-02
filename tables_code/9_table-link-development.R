# Development of the number of tweets with links
# In the original paper and data report this is based on the combined corpus, here just on the newly downloaded API corpus

# In the Twitter API data from 2019 the links ($urls_expanded_url) variable also contained photo links, this seems not be case anymore
# Therefore the numbers for just the links are different from the papers data, especially for 2018
# This is a good example how important it is to check the api data, for the original tweets we therefore cleaned the data, see Number of original tweets

# Library
library(rtweet)

# Data
histag_all <- read_twitter_csv("./data/histag_all.csv")
table_link_development <- data.frame(category=character(), "2012"=character(), "2014"=character(), "2016"=character(), "2018"=character(), all=character())

# 1 Number of links and media urls - absolute
temp <- data.frame("number-of-links-absolute-api+tags", 
                   sum(startsWith(as.character(histag_all[histag_all$histag_12 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE),
                   sum(startsWith(as.character(histag_all[histag_all$histag_14 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE),
                   sum(startsWith(as.character(histag_all[histag_all$histag_16 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE),
                   sum(startsWith(as.character(histag_all[histag_all$histag_18 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE),
                   sum(startsWith(as.character(histag_all$urls_expanded_url), "http"), na.rm = TRUE)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_link_development <- rbind(table_link_development, temp)

# 2. Number of links - relative
rm(temp)
temp <- data.frame("number-of-links-relative-api+tags", 
                   round(sum(startsWith(as.character(histag_all[histag_all$histag_12 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE) / sum(histag_all$histag_12 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(startsWith(as.character(histag_all[histag_all$histag_14 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE) / sum(histag_all$histag_14 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(startsWith(as.character(histag_all[histag_all$histag_16 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE) / sum(histag_all$histag_16 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(startsWith(as.character(histag_all[histag_all$histag_18 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE) / sum(histag_all$histag_18 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(startsWith(as.character(histag_all$urls_expanded_url), "http"), na.rm = TRUE) / sum(histag_all$is_del == FALSE),3)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_link_development <- rbind(table_link_development, temp)


# 3. Number of links in original tweets absolute
clean_links <- function(tweet_table, year) {
  if (year == "all") {
    temp <- tweet_table[tweet_table$is_retweet == FALSE, ]
  } else {
    temp <- tweet_table[tweet_table[,year] == TRUE & tweet_table$is_retweet == FALSE, ]
  }
  
  temp <- temp[which(startsWith(as.character(temp$urls_expanded_url), "http"),),]
  temp <- temp[is.na(temp$reply_to_status_id) & !startsWith(as.character(temp$urls_expanded_url), "https://twit"), ]
  
  return(nrow(temp))
}


rm(temp)
temp <- data.frame("number-of-links-orig-absolute-filtered-api+tags", 
                   clean_links(histag_all, "histag_12"),
                   clean_links(histag_all, "histag_14"),
                   clean_links(histag_all, "histag_16"),
                   clean_links(histag_all, "histag_18"),
                   clean_links(histag_all, "all")
)


names(temp)<-c("category","2012","2014","2016","2018","all")
table_link_development <- rbind(table_link_development, temp)

# 4. Number of links original tweets relative
rm(temp)
temp <- data.frame("number-of-links-orig-rel-filtered-api+tags", 
                   round(clean_links(histag_all, "histag_12") / sum(histag_all$histag_12 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE),3),
                   round(clean_links(histag_all, "histag_14") / sum(histag_all$histag_14 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE),3),
                   round(clean_links(histag_all, "histag_16") / sum(histag_all$histag_16 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE),3),
                   round(clean_links(histag_all, "histag_18") / sum(histag_all$histag_18 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE),3),
                   round(clean_links(histag_all, "all") / sum(histag_all$is_retweet == FALSE, na.rm = TRUE),3)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_link_development <- rbind(table_link_development, temp)

# Save
write.csv(table_link_development,"./tables/9_table-link-development.csv", row.names = FALSE)
rm(temp)