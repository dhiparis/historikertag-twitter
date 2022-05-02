# Development of mentions in all tweets
# Twitter seems to having updated the mention count for tweets, while this has a strong effect on the orig tweet numbers for 2018 (see 5_mentions-org-development.R), here the effect is weaker

# Library
library(rtweet)

# Data
histag_all <- read_twitter_csv("./data/histag_all.csv")

table_mentions_all_development <- data.frame("year"=character(), "mentions-orig-absolute"=character(), "mentions-orig-relative"=character())

for (i in c("12","14","16","18","all")) {
  if (i == "all") {
    year = "all"
    mentions_all_tweets = sum(!is.na(histag_all[histag_all$is_del == FALSE, ]$mentions_screen_name))
    number_tweets = sum(histag_all$is_del == FALSE)
  } else {
    year = paste("histag_",i, sep = "")
    mentions_all_tweets = sum(!is.na(histag_all[histag_all[,paste("histag_",i, sep = "")] == TRUE & histag_all$is_del == FALSE, ]$mentions_screen_name))
    number_tweets = sum(histag_all[,paste("histag_",i, sep = "")] == TRUE & histag_all$is_del == FALSE, na.rm = TRUE)
  }
  
  temp <- data.frame(year, mentions_all_tweets, round(mentions_all_tweets / number_tweets,3))
  names(temp)<-c("year", "mentions-all-absolute", "mentions-all-relative")
  
  table_mentions_all_development <- rbind(table_mentions_all_development, temp)
  
  rm(temp)
  rm(mentions_all_tweets)
  rm(number_tweets)
  rm(year)
}

# Save
write.csv(table_mentions_all_development,"./tables/6_table-mentions-all-development.csv", row.names = FALSE)

rm(i)