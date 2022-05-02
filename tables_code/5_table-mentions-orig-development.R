# Development of mentions in original tweets
# Twitter seems to having updated the mention count for tweets, this is has no significant effect on the data from 2012 - 2016 and the overall data, but for 2018:
# Here count goes up from 378 in our old api call to 506, in relative terms that is from 31,4 % to 43,3 %

# Library
library(rtweet)

# Data
histag_all <- read_twitter_csv("./data/histag_all.csv")

table_mentions_orig_development <- data.frame("year"=character(), "mentions-orig-absolute"=character(), "mentions-orig-relative"=character())

for (i in c("12","14","16","18","all")) {
  if (i == "all") {
    year = "all"
    mentions_org_tweets = sum(!is.na(histag_all[histag_all$is_retweet == FALSE & histag_all$is_del == FALSE, ]$mentions_screen_name))
    number_org_tweets = sum(histag_all$is_retweet == FALSE, na.rm = TRUE)
  } else {
    year = paste("histag_",i, sep = "")
    mentions_org_tweets = sum(!is.na(histag_all[histag_all[,paste("histag_",i, sep = "")] == TRUE & histag_all$is_retweet == FALSE & histag_all$is_del == FALSE, ]$mentions_screen_name))
    number_org_tweets = sum(histag_all$is_retweet == FALSE & histag_all[,paste("histag_",i, sep = "")] == TRUE, na.rm = TRUE)
  }
  
  temp <- data.frame(year, mentions_org_tweets, round(mentions_org_tweets / number_org_tweets,3))
  names(temp)<-c("year", "mentions-orig-absolute", "mentions-orig-relative")
  
  table_mentions_orig_development <- rbind(table_mentions_orig_development, temp)
  
  rm(temp)
  rm(mentions_org_tweets)
  rm(number_org_tweets)
  rm(year)
}


# Save
write.csv(table_mentions_orig_development,"./tables/5_table-mentions-orig-development.csv", row.names = FALSE)

rm(i)