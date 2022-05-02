# Table grouping users by their activity
# The numbers you will get will slightly differ from the paper as it relies on new api data for the retweet status in number_org_tweets

# Library
library(rtweet)

# Data
gender <- read_twitter_csv("./data/gender.csv")
histag_all <- read_twitter_csv("./data/histag_all.csv")

table_tweets_1_9_90 <- data.frame("year"=character(),"1"=character(),"9"=character(),"90"=character())
names(table_tweets_1_9_90)<-c("year","1","9","90")

for (i in c("12","14","16","18","all")) {
  if (i == "all") {
    var = c("all","tweet_orig_count","tweet_count")
    number_org_tweets = sum(histag_all$is_retweet == FALSE, na.rm = TRUE)
  } else {
    var = c(paste("20",i, sep = ""),paste("tweet_orig_count_",i, sep = ""),paste("tweet_count_",i, sep = ""))
    number_org_tweets = sum(histag_all$is_retweet == FALSE & histag_all[,paste("histag_",i, sep = "")] == TRUE, na.rm = TRUE)
  }
  
  top_01 = sum(head(gender[order(gender[,var[2]], decreasing= T),], n = floor(nrow(gender[gender[,var[3]] > 0,]) * 0.01))[,var[2]]) / number_org_tweets
  top_09 = (sum(head(gender[order(gender[,var[2]], decreasing= T),], n = floor(nrow(gender[gender[,var[3]] > 0,]) * 0.1))[,var[2]]) / number_org_tweets) - top_01
  bottom_90 = 1 - top_01 - top_09
  
  temp <- data.frame(var[1], round(top_01,3), round(top_09,3), round(bottom_90,3))
  names(temp)<-c("year","1","9","90")
  table_tweets_1_9_90 <- rbind(table_tweets_1_9_90, temp)
  
  rm(temp)
  rm(top_01)
  rm(top_09)
  rm(bottom_90)
  rm(number_org_tweets)
}
  
# Save
write.csv(table_tweets_1_9_90, file="./tables/4_table-user-activity-90-9-1.csv", row.names = F, na = "", fileEncoding = "UTF-16LE")

rm(var)
rm(i)

