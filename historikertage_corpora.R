# Code for the paper "Historikertage auf Twitter (2012-2018)" by Mareike König and Paul Ramisch
# With this code you can recreate the tables with the tweets and accounts the paper is based on
# Unfortunately you won't be able to get details about deleted and protected tweets and users except of how we tagged these tweets and users

# The tables and figures in the data report and paper are based on this data plus tweets that were deleted or protected
# The code for the figures and tables can be found in the corresponding sub folders

# Table of contents
# 1. Dehydration of the tweet table
# 2. Creation of gender table
# 3. Export

# 1. Dehydration of the tweet table
# Recreate the tweet table the paper is based on
# For the dehydration you need a free twitter developer account, for info here:
# https://developer.twitter.com/en/docs/twitter-api/getting-started/getting-access-to-the-twitter-api
# The original API calls can be found in the file historikertage_api.R, to replicate those calls you need a twitter api premium subscription

# 1.1 Preparation: Library and Twitter API key
# Needed libraries:
# install.packages("rtweet")
# install.packages("plyr")
# install.packages("dplyr")
# install.packages("tidyverse")

library(rtweet)
library(plyr)
library(dplyr)
library(tidyverse)

# Store of API key (get them at https://developer.twitter.com/en)
twitter_key <- "your_twitter_key"
twitter_secret_key <- "your_twitter_secret_key"
twitter_api_access_token <- "your_twitter_api_access_token"
twitter_api_access_token_secret <- "your_twitter_api_access_token_secret"
twitter_app <- "your_twitter_app_name"

token <- create_token(
  app = twitter_app,
  consumer_key = twitter_key,
  consumer_secret = twitter_secret_key,
  access_token = twitter_api_access_token,
  access_secret = twitter_api_access_token_secret)

# If there is problem with the above method, try the browser based authentication
# token <- create_token(
#  app = twitter_app,
#  consumer_key = twitter_key,
#  consumer_secret = twitter_secret_key)

# 1.2 Load dehydrated data
histag_all_dehydrated <- read_twitter_csv("data/histag_all_dehydrated_prepended-ids.csv")

# 1.3 Get the tweets
histag_all_api <- lookup_tweets(histag_all_dehydrated$status_id, token = token)

# 1.4 Combine the encoding and the tweet information
histag_all <- merge(x = histag_all_api, y = histag_all_dehydrated, by = "status_id", all.x=TRUE, all.y=TRUE)

# 1.5 Identify deleted and protected tweets
# A tweet can either be deleted individually or when an account is deleted, furthermore it can't be retrieved via the api if the account is proteced
# This variable combines these three, so tweets that are not visible for the public anymore
# Therefore this variable needs to be carefully used when trying to analyze the reason for its deletion
histag_all$is_del <- FALSE
histag_all[is.na(histag_all$user_id), ]$is_del <- TRUE

# 1.6 Exchange NULL with NA
col_na <- colnames(histag_all_api)[2:90]

for(i in col_na) {
  histag_all[histag_all$is_del == TRUE, i] <- NA
}

rm(col_na)

# 2. Creation of gender table
# 2.1 Distilling information out of tweet table
create_user_table <- function(tweet_table) {
  user_table <- tweet_table %>% group_by(corpus_user_id) %>% summarise(
    user_id = first(na.omit(user_id)),
    corpus_user_id = first(na.omit(corpus_user_id)),
    gender = first(na.omit(Gender)),
    screen_name = first(na.omit(screen_name)),
    name = last(na.omit(name)), 
    account_created_at = first(na.omit(account_created_at)),
    del_or_protected = FALSE, 
    tweet_count = n(),
    tweet_orig_count = sum(is_retweet == FALSE, na.rm = TRUE),
    favorite_count = sum(favorite_count[is_retweet==FALSE], na.rm = TRUE), 
    retweet_count = sum(retweet_count[is_retweet==FALSE], na.rm = TRUE), 
    like_tweet_ratio = (sum(favorite_count[is_retweet==FALSE], na.rm = TRUE) / sum(is_retweet == FALSE, na.rm = TRUE)), 
    retweet_tweet_ratio = (sum(retweet_count[is_retweet==FALSE], na.rm = TRUE) / sum(is_retweet == FALSE, na.rm = TRUE)), 
    followers_count = first(na.omit(followers_count)), 
    friends_count = first(na.omit(friends_count)),
    tweet_count_12 = sum(histag_12 == TRUE, na.rm = TRUE),
    tweet_count_14 = sum(histag_14 == TRUE, na.rm = TRUE),
    tweet_count_16 = sum(histag_16 == TRUE, na.rm = TRUE),
    tweet_count_18 = sum(histag_18 == TRUE, na.rm = TRUE),
    tweet_orig_count_12 = sum(histag_12[is_retweet == FALSE] == TRUE, na.rm = TRUE),
    tweet_orig_count_14 = sum(histag_14[is_retweet == FALSE] == TRUE, na.rm = TRUE),
    tweet_orig_count_16 = sum(histag_16[is_retweet == FALSE] == TRUE, na.rm = TRUE),
    tweet_orig_count_18 = sum(histag_18[is_retweet == FALSE] == TRUE, na.rm = TRUE)
  )
  
  # Set protected or deleted status based on missing values
  # Unfortunately it is not possible just with the rehydrated data, to find out, whether an account is deleted or just protected
  # For own data this could be used: lookup_users(histag_all[histag_all$is_del == TRUE, ]$user_id, parse = TRUE, token = token)
  user_table[is.na(user_table$user_id), ]$del_or_protected <- TRUE
  
  # Prevent wrong analysis by replacing 0 with NA for deleted and protected users; this data can't be obtained again by rehydrating
  user_table[is.na(user_table$user_id), ]$tweet_orig_count <- NA
  user_table[is.na(user_table$user_id), ]$favorite_count <- NA
  user_table[is.na(user_table$user_id), ]$retweet_count <- NA
  user_table[is.na(user_table$user_id), ]$like_tweet_ratio <- NA
  user_table[is.na(user_table$user_id), ]$retweet_tweet_ratio <- NA
  user_table[is.na(user_table$user_id), ]$tweet_orig_count_12 <- NA
  user_table[is.na(user_table$user_id), ]$tweet_orig_count_14 <- NA
  user_table[is.na(user_table$user_id), ]$tweet_orig_count_16 <- NA
  user_table[is.na(user_table$user_id), ]$tweet_orig_count_18 <- NA
  
  return(user_table)
}

gender <- create_user_table(histag_all)

# 2.2 Add further information for each user: Used hashtags, text, most used category
# 2.2.1 Functions
get_used_hashtags_by_user <- function(tweet_table, user_table, iterator, drop_hashtags) {
  used_hashtags <- select(tweet_table[which(tweet_table$user_id == user_table$user_id[iterator]), ], hashtags)
  if(!nrow(used_hashtags) == 0){ 
    used_hashtags <- select(used_hashtags, hashtags) %>% 
      unnest(cols = c(hashtags)) %>% 
      mutate(hashtags = tolower(hashtags)) %>% 
      filter(!hashtags %in% drop_hashtags)
    
    used_hashtags <- as.character(paste(unlist(t(used_hashtags$hashtags)), collapse=", ")) 
  } else {
    used_hashtags <- NA
  }
  
  return(used_hashtags)
}

get_text_by_user <- function(tweet_table, user_table, iterator) {
  text <- select(tweet_table[which(tweet_table$user_id == user_table$user_id[iterator]), ], text)
  if(!nrow(text) == 0){ 
    text <- select(text, text) %>% 
      mutate(text = tolower(text)) 
    text <- as.character(paste(unlist(t(text$text)), collapse=", ")) 
  } else {
    text <- NA
  }
  
  return(text)
}

get_most_used_category_by_user <- function(tweet_table, user_table, iterator) {
  category <- select(tweet_table[which(tweet_table$user_id == user_table$user_id[iterator]), ], hauptkategorie_1)
  if(!nrow(category) == 0){ 
    category <- select(category, hauptkategorie_1) %>%
      count(hauptkategorie_1, sort=TRUE) %>% 
      slice_head(n = 1)
      category <- category$hauptkategorie_1
  } else {
    category <- NA
  }
  
  return(as.character(category))
}

# 2.2.2 Application of functions
drop_hashtags <- c(NA, "histag12", "histag14", "histag16", "histag18", "histag2012", "histag2014", "histag2016", "histag2018", "histtag12", "histtag14", "histtag16", "histtag18", "historikertag", "historikertag2012", "historikertag2014", "historikertag2016", "historikertag2018", "historikertag12", "historikertag14", "historikertag16", "historikertag18")

gender$used_hashtags <- NA
gender$most_used_category <- NA
gender$text <- NA

for (i in 1:nrow(gender)) {
  gender$used_hashtags[i] <- get_used_hashtags_by_user(histag_all, gender, i, drop_hashtags)
  gender$most_used_category[i] <- get_most_used_category_by_user(histag_all, gender, i)
  gender$text[i] <- get_text_by_user(histag_all, gender, i)
}

# 2.3 Number of followers and friends within community
# The variables followers_community_count and friends_community_count are defined in the file figures_code/15-20_graph.R 
# as they require big api calls, which are themselves only necessary for network analysis data preparation; if you are interested in those please look there

# 3. Export
# 3.1 Export as CSV
write_as_csv(gender, "data/gender.csv", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")
write_as_csv(histag_all, "data/histag_all", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")

# 3.2 Dehydrate
# This step isn't needed for the tables, only for sharing of the corpus
# histag_all_dehydrated <- histag_all[ , c("status_id", "corpus_user_id", "hauptkategorie_1", "hauptkategorie_2", "Gender", "Nebenkategorie", "histag_12", "orig_12", "api_12", "histag_14", "orig_14", "api_14", "histag_16", "orig_16", "api_16", "histag_18", "orig_18", "api_18")]
# write_as_csv(histag_all_dehydrated, "data/histag_all_dehydrated_prepended-ids_new.csv", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")
# rm(histag_all_dehydrated)

# With this code the corpus_user_id was created in the first place to be able to identify tweets from the same user without using the user_id (due to privacy concerns):
# histag_all_dehydrated <- transform(histag_all_dehydrated, corpus_user_id = as.numeric(factor(user_id)))


