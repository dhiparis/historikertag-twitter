# table_overview
# Be aware that all the values from the papers table that based on the API corpus (signaled by: **), will differ because of the later api call
# To measure this effect, there is a new sub row counting the now downloaded tweets (see 1.4)

# Library
library(rtweet)

# Data
histag_all <- read_twitter_csv("./data/histag_all.csv")
gender <- read_twitter_csv("./data/gender.csv")

table_overview <- data.frame(category=character(), "2012"=character(), "2014"=character(), "2016"=character(), "2018"=character(), all=character())

# 1. Number of Tweets
# 1.1  Number of Tweets combined corpora
temp <- data.frame("number-of-tweets", 
                   nrow(histag_all[histag_all$histag_12 == TRUE, ]),
                   nrow(histag_all[histag_all$histag_14 == TRUE, ]),
                   nrow(histag_all[histag_all$histag_16 == TRUE, ]),
                   nrow(histag_all[histag_all$histag_18 == TRUE, ]),
                   nrow(histag_all)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 1.2 Number of Tweets old corpora
temp <- data.frame("number-of-tweets-old", 
                   nrow(histag_all[histag_all$orig_12 == TRUE, ]),
                   nrow(histag_all[histag_all$orig_14 == TRUE, ]),
                   nrow(histag_all[histag_all$orig_16 == TRUE, ]),
                   nrow(histag_all[histag_all$orig_18 == TRUE, ]),
                   nrow(histag_all[histag_all$orig_12 == TRUE | histag_all$orig_14 == TRUE  | histag_all$orig_16 == TRUE  | histag_all$orig_18 == TRUE , ])
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 1.3 Number of Tweets API corpora
# This number reflects the API tweets used in the paper
temp <- data.frame("number-of-tweets-api-koenig-ramisch", 
                   nrow(histag_all[histag_all$api_12 == TRUE, ]),
                   nrow(histag_all[histag_all$api_14 == TRUE, ]),
                   nrow(histag_all[histag_all$api_16 == TRUE, ]),
                   nrow(histag_all[histag_all$api_18 == TRUE, ]),
                   nrow(histag_all[histag_all$api_12 == TRUE | histag_all$api_14 == TRUE | histag_all$api_16 == TRUE | histag_all$api_18 == TRUE, ]) 
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 1.4 Number of Tweets API corpora now
# This number reflects the API tweets you got while reproducing the data
# When this code was written in April 2021 (the original api call was in December 2019), there was already a major number of tweets deleted:
# 2012: 1201 (-1,2 %), 2014: 3766 (-6,0 %), 2016: 4223 (-5,8 %), 2018: 3519 (-4,2 %), all: 12652 (-5,0 %)
temp <- data.frame("number-of-tweets-api-new", 
                   nrow(histag_all[histag_all$api_12 == TRUE & histag_all$is_del == FALSE, ]),
                   nrow(histag_all[histag_all$api_14 == TRUE & histag_all$is_del == FALSE, ]),
                   nrow(histag_all[histag_all$api_16 == TRUE & histag_all$is_del == FALSE, ]),
                   nrow(histag_all[histag_all$api_18 == TRUE & histag_all$is_del == FALSE, ]),
                   nrow(histag_all[(histag_all$api_12 == TRUE | histag_all$api_14 == TRUE | histag_all$api_16 == TRUE | histag_all$api_18 == TRUE)  & histag_all$is_del == FALSE, ]) 
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 2.1 Original tweets
# 2.1 Original tweets absolute
rm(temp)
temp <- data.frame("number-of-orig-tweets-absolute-api", 
                   sum(histag_all$histag_12 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE),
                   sum(histag_all$histag_14 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE),
                   sum(histag_all$histag_16 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE),
                   sum(histag_all$histag_18 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE),
                   sum(histag_all$is_retweet == FALSE, na.rm = TRUE)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 2.2 Original tweets relative
rm(temp)
temp <- data.frame("number-of-orig-tweets-relative-api", 
                   round(sum(histag_all$histag_12 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE) / nrow(histag_all[histag_all$api_12 == TRUE & histag_all$is_del == FALSE, ]), 3),
                   round(sum(histag_all$histag_14 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE) / nrow(histag_all[histag_all$api_14 == TRUE & histag_all$is_del == FALSE, ]), 3),
                   round(sum(histag_all$histag_16 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE) / nrow(histag_all[histag_all$api_16 == TRUE & histag_all$is_del == FALSE, ]), 3),
                   round(sum(histag_all$histag_18 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE) / nrow(histag_all[histag_all$api_18 == TRUE & histag_all$is_del == FALSE, ]), 3),
                   round(sum(histag_all$is_retweet == FALSE, na.rm = TRUE) / nrow(histag_all[(histag_all$api_12 == TRUE | histag_all$api_14 == TRUE | histag_all$api_16 == TRUE | histag_all$api_18 == TRUE)& histag_all$is_del == FALSE, ]), 3)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 3. Retweets
# 3.1 Retweets absolute
rm(temp)
temp <- data.frame("number-of-retweets-absolute-api", 
                   sum(histag_all$histag_12 == TRUE & histag_all$is_retweet == TRUE, na.rm = TRUE),
                   sum(histag_all$histag_14 == TRUE & histag_all$is_retweet == TRUE, na.rm = TRUE),
                   sum(histag_all$histag_16 == TRUE & histag_all$is_retweet == TRUE, na.rm = TRUE),
                   sum(histag_all$histag_18 == TRUE & histag_all$is_retweet == TRUE, na.rm = TRUE),
                   sum(histag_all$is_retweet == TRUE, na.rm = TRUE)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 3.2 Retweets relative
rm(temp)
temp <- data.frame("number-of-retweets-relative-api", 
                   round(sum(histag_all$histag_12 == TRUE & histag_all$is_retweet == TRUE, na.rm = TRUE) / nrow(histag_all[histag_all$api_12 == TRUE & histag_all$is_del == FALSE, ]),3),
                   round(sum(histag_all$histag_14 == TRUE & histag_all$is_retweet == TRUE, na.rm = TRUE) / nrow(histag_all[histag_all$api_14 == TRUE & histag_all$is_del == FALSE, ]),3),
                   round(sum(histag_all$histag_16 == TRUE & histag_all$is_retweet == TRUE, na.rm = TRUE) / nrow(histag_all[histag_all$api_16 == TRUE & histag_all$is_del == FALSE, ]),3),
                   round(sum(histag_all$histag_18 == TRUE & histag_all$is_retweet == TRUE, na.rm = TRUE) / nrow(histag_all[histag_all$api_18 == TRUE & histag_all$is_del == FALSE, ]),3),
                   round(sum(histag_all$is_retweet == TRUE, na.rm = TRUE) / nrow(histag_all[(histag_all$api_12 == TRUE | histag_all$api_14 == TRUE | histag_all$api_16 == TRUE | histag_all$api_18 == TRUE)  & histag_all$is_del == FALSE, ]),3) 
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 4. Likes/favs
rm(temp)
temp <- data.frame("number-of-favs-api", 
                   sum(histag_all[histag_all$histag_12 == TRUE, ]$favorite_count, na.rm = TRUE),
                   sum(histag_all[histag_all$histag_14 == TRUE, ]$favorite_count, na.rm = TRUE),
                   sum(histag_all[histag_all$histag_16 == TRUE, ]$favorite_count, na.rm = TRUE),
                   sum(histag_all[histag_all$histag_18 == TRUE, ]$favorite_count, na.rm = TRUE),
                   sum(histag_all$favorite_count, na.rm = TRUE)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 5. Replies
# While setting up this code and recalling the api, it didn't return the reply_count; hopefully it works for you!
# It is unclear whether this is an issue with the current rtweet version or the newer Twitter api
rm(temp)
temp <- data.frame("number-of-replies-api", 
                   sum(histag_all[histag_all$histag_12 == TRUE, ]$reply_count, na.rm = TRUE),
                   sum(histag_all[histag_all$histag_14 == TRUE, ]$reply_count, na.rm = TRUE),
                   sum(histag_all[histag_all$histag_16 == TRUE, ]$reply_count, na.rm = TRUE),
                   sum(histag_all[histag_all$histag_18 == TRUE, ]$reply_count, na.rm = TRUE),
                   sum(histag_all$reply_count, na.rm = TRUE)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 6. Deleted tweets
# This also includes protected tweets and tweets that got deleted when a user account has been deleted
rm(temp)
temp <- data.frame("number-of-identified-deleted-tweets-api+tags", 
                   sum(histag_all$histag_12 == TRUE & histag_all$is_del == TRUE),
                   sum(histag_all$histag_14 == TRUE & histag_all$is_del == TRUE),
                   sum(histag_all$histag_16 == TRUE & histag_all$is_del == TRUE),
                   sum(histag_all$histag_18 == TRUE & histag_all$is_del == TRUE),
                   sum(histag_all$is_del == TRUE)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 7. Community
# 7.1 Community
rm(temp)
temp <- data.frame("number-of-users-api+tags", 
                   nrow(gender[gender$tweet_count_12 > 0,]),
                   nrow(gender[gender$tweet_count_14 > 0,]),
                   nrow(gender[gender$tweet_count_16 > 0,]),
                   nrow(gender[gender$tweet_count_18 > 0,]),
                   nrow(gender)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 7.2 Community active
rm(temp)
temp <- data.frame("number-of-users-orig-tweets-api+tags", 
                   nrow(gender[gender$tweet_orig_count_12 > 0 & !is.na(gender$tweet_orig_count_12), ]),
                   nrow(gender[gender$tweet_orig_count_14 > 0 & !is.na(gender$tweet_orig_count_14), ]),
                   nrow(gender[gender$tweet_orig_count_16 > 0 & !is.na(gender$tweet_orig_count_16), ]),
                   nrow(gender[gender$tweet_orig_count_18 > 0 & !is.na(gender$tweet_orig_count_18), ]),
                   nrow(gender[gender$tweet_orig_count > 0 & !is.na(gender$tweet_orig_count), ])
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)


# 8. Median tweets per year and active user 
rm(temp)
temp <- data.frame("median-of-tweets-per-user-api+tags", 
                   median(gender[gender$tweet_count_12 > 0, ]$tweet_count_12),
                   median(gender[gender$tweet_count_14 > 0, ]$tweet_count_14),
                   median(gender[gender$tweet_count_16 > 0, ]$tweet_count_16),
                   median(gender[gender$tweet_count_18 > 0, ]$tweet_count_18),
                   median(gender[gender$tweet_count > 0, ]$tweet_count)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 9. Mean tweets per year and active user 
rm(temp)
temp <- data.frame("mean-of-tweets-per-user-api+tags", 
                   round(mean(gender[gender$tweet_count_12 > 0, ]$tweet_count_12),3),
                   round(mean(gender[gender$tweet_count_14 > 0, ]$tweet_count_14),3),
                   round(mean(gender[gender$tweet_count_16 > 0, ]$tweet_count_16),3),
                   round(mean(gender[gender$tweet_count_18 > 0, ]$tweet_count_18),3),
                   round(mean(gender[gender$tweet_count > 0, ]$tweet_count),3)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 10. Number of links
# In the original paper and data report this is based on the combined corpus, here just on the newly downloaded api corpus

# In the twitter api data from 2019 the links ($urls_expanded_url) variable also contained photo links, this seems not be case anymore
# Therefore the numbers for just the links are different from the papers data, especially for 2018
# This is a good example how important it is to check the api data, for the original tweets we therefore cleaned the data, see 11. Number of original tweets

# 10.1 Number of links and media urls - absolute
rm(temp)
temp <- data.frame("number-of-links-absolute-api+tags", 
                   sum(startsWith(as.character(histag_all[histag_all$histag_12 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE),
                   sum(startsWith(as.character(histag_all[histag_all$histag_14 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE),
                   sum(startsWith(as.character(histag_all[histag_all$histag_16 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE),
                   sum(startsWith(as.character(histag_all[histag_all$histag_18 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE),
                   sum(startsWith(as.character(histag_all$urls_expanded_url), "http"), na.rm = TRUE)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 10.2 Number of links - relative
rm(temp)
temp <- data.frame("number-of-links-relative-api+tags", 
                   round(sum(startsWith(as.character(histag_all[histag_all$histag_12 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE) / sum(histag_all$histag_12 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(startsWith(as.character(histag_all[histag_all$histag_14 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE) / sum(histag_all$histag_14 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(startsWith(as.character(histag_all[histag_all$histag_16 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE) / sum(histag_all$histag_16 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(startsWith(as.character(histag_all[histag_all$histag_18 == TRUE, ]$urls_expanded_url), "http"), na.rm = TRUE) / sum(histag_all$histag_18 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(startsWith(as.character(histag_all$urls_expanded_url), "http"), na.rm = TRUE) / sum(histag_all$is_del == FALSE),3)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)


# 11. Number of links in original tweets
# 11.1 Number of links original tweets absolute
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
table_overview <- rbind(table_overview, temp)

# 11.2 Number of links original tweets relative
rm(temp)
temp <- data.frame("number-of-links-orig-rel-filtered-api+tags", 
                   round(clean_links(histag_all, "histag_12") / sum(histag_all$histag_12 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE),3),
                   round(clean_links(histag_all, "histag_14") / sum(histag_all$histag_14 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE),3),
                   round(clean_links(histag_all, "histag_16") / sum(histag_all$histag_16 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE),3),
                   round(clean_links(histag_all, "histag_18") / sum(histag_all$histag_18 == TRUE & histag_all$is_retweet == FALSE, na.rm = TRUE),3),
                   round(clean_links(histag_all, "all") / sum(histag_all$is_retweet == FALSE, na.rm = TRUE),3)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 12. Number of photos
# In contrast to the links (see 10. and 11.), where there were fewer instances in this new call, the number of photos increased, again especially for 2018

# 12.1 Number of Photos - absolute
rm(temp)
temp <- data.frame("number-of-photos-absolute-api", 
                   sum(histag_all[histag_all$histag_12 == TRUE,]$media_type == "photo", na.rm = TRUE),
                   sum(histag_all[histag_all$histag_14 == TRUE,]$media_type == "photo", na.rm = TRUE),
                   sum(histag_all[histag_all$histag_16 == TRUE,]$media_type == "photo", na.rm = TRUE),
                   sum(histag_all[histag_all$histag_18 == TRUE,]$media_type == "photo", na.rm = TRUE),
                   sum(histag_all$media_type == "photo", na.rm = TRUE)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 12.2 Number of Photos - relative
rm(temp)
temp <- data.frame("number-of-photos-relative-api", 
                   round(sum(histag_all[histag_all$histag_12 == TRUE,]$media_type == "photo", na.rm = TRUE) / sum(histag_all$histag_12 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(histag_all[histag_all$histag_14 == TRUE,]$media_type == "photo", na.rm = TRUE) / sum(histag_all$histag_14 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(histag_all[histag_all$histag_16 == TRUE,]$media_type == "photo", na.rm = TRUE) / sum(histag_all$histag_16 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(histag_all[histag_all$histag_18 == TRUE,]$media_type == "photo", na.rm = TRUE) / sum(histag_all$histag_18 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(histag_all$media_type == "photo", na.rm = TRUE) / sum(histag_all$is_del == FALSE),3)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind.data.frame(table_overview, temp)

# 13 Number of mentions
# 13.1 Number of mentions - absolute
rm(temp)
temp <- data.frame("number-of-mentions-absolute-api", 
                   sum(!is.na(histag_all[histag_all$histag_12 == TRUE, ]$mentions_screen_name), na.rm = TRUE),
                   sum(!is.na(histag_all[histag_all$histag_14 == TRUE, ]$mentions_screen_name), na.rm = TRUE),
                   sum(!is.na(histag_all[histag_all$histag_16 == TRUE, ]$mentions_screen_name), na.rm = TRUE),
                   sum(!is.na(histag_all[histag_all$histag_18 == TRUE, ]$mentions_screen_name), na.rm = TRUE),
                   sum(!is.na(histag_all$mentions_screen_name), na.rm = TRUE)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 13.2 Number of mentions - relative
rm(temp)
temp <- data.frame("number-of-mentions-relative-api", 
                   round(sum(!is.na(histag_all[histag_all$histag_12 == TRUE, ]$mentions_screen_name), na.rm = TRUE) / sum(histag_all$histag_12 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(!is.na(histag_all[histag_all$histag_14 == TRUE, ]$mentions_screen_name), na.rm = TRUE) / sum(histag_all$histag_14 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(!is.na(histag_all[histag_all$histag_16 == TRUE, ]$mentions_screen_name), na.rm = TRUE) / sum(histag_all$histag_16 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(!is.na(histag_all[histag_all$histag_18 == TRUE, ]$mentions_screen_name), na.rm = TRUE) / sum(histag_all$histag_18 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(!is.na(histag_all$mentions_screen_name), na.rm = TRUE) / sum(histag_all$is_del == FALSE),3)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

# 13.3 Number of mentions in original tweets - absolute
rm(temp)
temp <- data.frame("number-of-mentions-org-absolute-api", 
                   sum(!is.na(histag_all[histag_all$histag_12 == TRUE & histag_all$is_retweet == FALSE, ]$mentions_screen_name), na.rm = TRUE),
                   sum(!is.na(histag_all[histag_all$histag_14 == TRUE & histag_all$is_retweet == FALSE, ]$mentions_screen_name), na.rm = TRUE),
                   sum(!is.na(histag_all[histag_all$histag_16 == TRUE & histag_all$is_retweet == FALSE, ]$mentions_screen_name), na.rm = TRUE),
                   sum(!is.na(histag_all[histag_all$histag_18 == TRUE & histag_all$is_retweet == FALSE, ]$mentions_screen_name), na.rm = TRUE),
                   sum(!is.na(histag_all[histag_all$is_retweet == FALSE, ]$mentions_screen_name), na.rm = TRUE)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_overview <- rbind(table_overview, temp)

table_overview$"2012" <- as.character(table_overview$"2012")
table_overview$"2014" <- as.character(table_overview$"2014")
table_overview$"2016" <- as.character(table_overview$"2016")
table_overview$"2018" <- as.character(table_overview$"2018")

write.csv(table_overview,"./tables/2_table_overview.csv", row.names = FALSE)