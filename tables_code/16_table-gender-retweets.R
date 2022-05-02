# Number of tweets per gender and category
# In the paper version the average retweet was build by diving the sum of retweets per gender by the number of all tweets
# A clearer and better representation is given by dividing just through the original tweets (not all tweets) as retweets can't be retweetet themselves
# The outcommented code is the legacy code of the paper

# Library
library(rtweet)

# Load Data
histag_all <- read_twitter_csv("./data/histag_all.csv")

# Create table
table_gender_retweets <- data.frame(year=character(), m=numeric(), f=numeric(), i=numeric(), e=numeric(), z=numeric(), a=numeric(), b=numeric(), u=numeric())

get_gender_retweets <- function(year, gender_code) {
  if(year != "all") {
    # num_tweets_temp <- nrow(histag_all[histag_all[,paste("histag_",year, sep = "")] == TRUE & histag_all$Gender == gender_code & histag_all$is_del == FALSE,])
    # return(round(sum(histag_all[histag_all[,paste("histag_",year, sep = "")] == TRUE & histag_all$Gender == gender_code & histag_all$is_retweet == FALSE,]$retweet_count, na.rm = TRUE)/num_tweets_temp,2))
    return(round(mean(histag_all[histag_all[,paste("histag_",year, sep = "")] == TRUE & histag_all$Gender == gender_code & histag_all$is_retweet == FALSE,]$retweet_count, na.rm = TRUE),2))
  } else {
    # num_tweets_temp <- nrow(histag_all[histag_all$Gender == gender_code & histag_all$is_del == FALSE,])
    # return(round(sum(histag_all[histag_all$Gender == gender_code & histag_all$is_retweet == FALSE,]$retweet_count, na.rm = TRUE)/num_tweets_temp,2))
    return(round(mean(histag_all[histag_all$Gender == gender_code & histag_all$is_retweet == FALSE,]$retweet_count, na.rm = TRUE),2))
  }
}

for (i in c(12,14,16,18,"all")) {
  temp <- data.frame(year = i, 
                     m = get_gender_retweets(i, "m"), 
                     f = get_gender_retweets(i, "f"),
                     i = get_gender_retweets(i, "i"),
                     e = get_gender_retweets(i, "e"),
                     z = get_gender_retweets(i, "z"),
                     a = get_gender_retweets(i, "a"),
                     b = get_gender_retweets(i, "b"),
                     u = get_gender_retweets(i, "u")
  )
  
  table_gender_retweets <- rbind(table_gender_retweets, temp)
}

rm(temp)

# Save
write.csv(table_gender_retweets,"./tables/16_table-gender-retweets.csv", row.names = FALSE)