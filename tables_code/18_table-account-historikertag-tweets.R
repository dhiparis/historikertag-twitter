# Table of tweets per event by @historikertag
# The api token (see historikertage_code.R must be set for this)
# Deleted Retweets might be to the original tweet being deleted while deleted Originaltweets were most likely deleted by the account holders themselves

# Library
library(rtweet)
library(dplyr)
library(tidyverse)

# Download tweets
# Get the most recent 3200 tweets (upper limit by twitter) of the user @historikertag timeline, in April 2022 this accounts for 961 tweets
histag_account_historikertag <- get_timeline("historikertag", n = 3200, token = token) 

# Count function
get_count_used_hashtags <- function(tweet_table, histag_hashtags, orig_rt){
  if(orig_rt != "all"){
    tweet_table <- tweet_table[tweet_table$is_retweet == orig_rt, ]
  } 
  
  used_hashtags <- tweet_table %>% 
    unnest(cols = c(hashtags)) %>% 
    mutate(hashtags = tolower(hashtags)) %>% 
    filter(hashtags %in% histag_hashtags) %>% 
    nest(cols = c(hashtags))
 
  return(nrow(used_hashtags))
}

# Hashtags to count
hashtags <- list("10" = c("ht10"),
                 "12" = c("histag12", "histag2012", "histtag12", "historikertag12", "historikertag2012"),
                 "14" = c("histag14", "histag2014", "histtag14", "historikertag14", "historikertag2014"),
                 "16" = c("histag16", "histag2016", "histtag16", "historikertag16", "historikertag2016"),
                 "18" = c("histag18", "histag2018", "histtag18", "historikertag18", "historikertag2018"))

table_account_historikertag <- data.frame("year" = character(), "Originaltweets" = integer(), "Retweets" = integer(), "All" = integer())

# Create table
for(i in c("10","12","14","16","18")) {
  table_account_historikertag <- rbind(table_account_historikertag,
                                        data.frame("year" = paste("20", i, sep = ""), 
                                                   "Originaltweets" = get_count_used_hashtags(histag_account_historikertag, hashtags[[i]], FALSE), 
                                                   "Retweets" = get_count_used_hashtags(histag_account_historikertag, hashtags[[i]], TRUE), 
                                                   "All" = get_count_used_hashtags(histag_account_historikertag, hashtags[[i]], "all"))
  )
}


# Save
write.csv(table_account_historikertag,"./tables/18_table_account_historikertag.csv", row.names = FALSE)
write_as_csv(histag_account_historikertag, "./data/histag_account_historikertag.csv", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")

rm(hashtags)