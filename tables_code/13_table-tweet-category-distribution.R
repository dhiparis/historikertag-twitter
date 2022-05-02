# Tweet category distribution

# Library
library(rtweet)
library(dplyr)

# Load Data
histag_all <- read_twitter_csv("./data/histag_all.csv")

# Create table
table_tweet_category_distribution <- data.frame("category"=character(),"orig_2012"=integer(),"rt_2012"=integer(),"orig_2014"=integer(),"rt_2014"=integer(),"orig_2016"=integer(),"rt_2016"=integer(),"orig_2018"=integer(),"rt_2018"=integer(),"all_orig"=integer(),"all_rt"=integer())

# Function to get number of tweets per category and year
get_number_of_tweets_category <- function(year, category, type){
  if(category != "all" & year != "all") {
    return(nrow(histag_all[histag_all[,paste("histag_",year, sep = "")] == TRUE & histag_all$hauptkategorie_1 == category & histag_all$is_retweet == type & histag_all$is_del == FALSE,]))
  }
  
  if(category != "all" & year == "all") {
    return(nrow(histag_all[histag_all$hauptkategorie_1 == category & histag_all$is_retweet == type & histag_all$is_del == FALSE,]))
  } 
  
  if(category == "all" & year != "all") {
    return(nrow(histag_all[histag_all[,paste("histag_",year, sep = "")] == TRUE & histag_all$is_retweet == type & histag_all$is_del == FALSE,]))
  }
  
  if(category == "all" & year == "all") {
    return(nrow(histag_all[histag_all$is_retweet == type & histag_all$is_del == FALSE,]))
  }
}

# Iterate through categorys
for (i in c("all",7,6,5,4,3,2,1,0)) {
  temp <- data.frame("category" = i,
                     "orig_2012" = get_number_of_tweets_category("12",i,FALSE),
                     "rt_2012" = get_number_of_tweets_category("12",i,TRUE),
                     "orig_2014" = get_number_of_tweets_category("14",i,FALSE),
                     "rt_2014" = get_number_of_tweets_category("14",i,TRUE),
                     "orig_2016" = get_number_of_tweets_category("16",i,FALSE),
                     "rt_2016" = get_number_of_tweets_category("16",i,TRUE),
                     "orig_2018" = get_number_of_tweets_category("18",i,FALSE),
                     "rt_2018" = get_number_of_tweets_category("18",i,TRUE),
                     "orig_all" = get_number_of_tweets_category("all",i,FALSE),
                     "rt_all" = get_number_of_tweets_category("all",i,TRUE)
  )
  
  if(i != "all") {
    # Get the relative proportion by diving through the all row (last row in the data frame)
    temp_rel <- temp
    temp_rel[1] <- paste(i,"_rel", sep = "")
    temp_rel[,2:ncol(temp_rel)] <- round(temp_rel[,2:ncol(temp_rel)] / tail(table_tweet_category_distribution[,2:ncol(table_tweet_category_distribution)], n = 1), 3)
        
    table_tweet_category_distribution <- rbind(temp_rel,table_tweet_category_distribution)
  }
  
  table_tweet_category_distribution <- rbind(temp,table_tweet_category_distribution)
}

rm(temp)
rm(temp_rel)

# Save
write.csv(table_tweet_category_distribution,"./tables/13_table-tweet-category-distribution.csv", row.names = FALSE)