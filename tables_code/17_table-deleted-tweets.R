# Number of deleted tweets
# The numbers will not only differ from the paper because of the later API call (and presumably more deleted tweets) 
# But also because it can be certainly be said whether an account is deleted, protected or all the tweet(s) that where in the corpus  are deleted
# Therefore this numbers most be accessed carefully

# Library
library(rtweet)

# Load Data
histag_all <- read_twitter_csv("./data/histag_all.csv")
gender <- read_twitter_csv("./data/gender.csv")

# Create table
table_deleted_tweets <- data.frame(type="deleted-tweets", 
   "2012" = sum(histag_all$is_del == TRUE & histag_all$histag_12 == TRUE, na.rm = TRUE), 
   "2014" = sum(histag_all$is_del == TRUE & histag_all$histag_14 == TRUE, na.rm = TRUE), 
   "2016" = sum(histag_all$is_del == TRUE & histag_all$histag_16 == TRUE, na.rm = TRUE), 
   "2018" = sum(histag_all$is_del == TRUE & histag_all$histag_18 == TRUE, na.rm = TRUE), 
   "all" = sum(histag_all$is_del == TRUE, na.rm = TRUE))

table_deleted_tweets <- rbind(table_deleted_tweets, data.frame(type="deleted-tweets-of-undel-accounts", 
   "2012" = sum(histag_all$is_del == TRUE & histag_all$histag_12 == TRUE & histag_all$corpus_user_id %in% gender[gender$del_or_protected == FALSE,]$corpus_user_id, na.rm = TRUE), 
   "2014" = sum(histag_all$is_del == TRUE & histag_all$histag_14 == TRUE & histag_all$corpus_user_id %in% gender[gender$del_or_protected == FALSE,]$corpus_user_id, na.rm = TRUE), 
   "2016" = sum(histag_all$is_del == TRUE & histag_all$histag_16 == TRUE & histag_all$corpus_user_id %in% gender[gender$del_or_protected == FALSE,]$corpus_user_id, na.rm = TRUE), 
   "2018" = sum(histag_all$is_del == TRUE & histag_all$histag_18 == TRUE & histag_all$corpus_user_id %in% gender[gender$del_or_protected == FALSE,]$corpus_user_id, na.rm = TRUE), 
   "all" = sum(histag_all$is_del == TRUE & histag_all$corpus_user_id %in% gender[gender$del_or_protected == FALSE,]$corpus_user_id, na.rm = TRUE)))

table_deleted_tweets <- rbind(table_deleted_tweets, data.frame(type="deleted-tweets-of-undel-accounts-rel", 
   "2012" = round(sum(histag_all$is_del == TRUE & histag_all$histag_12 == TRUE & histag_all$corpus_user_id %in% gender[gender$del_or_protected == FALSE,]$corpus_user_id, na.rm = TRUE) / sum(histag_all$histag_12 == TRUE, na.rm = TRUE), 3), 
   "2014" = round(sum(histag_all$is_del == TRUE & histag_all$histag_14 == TRUE & histag_all$corpus_user_id %in% gender[gender$del_or_protected == FALSE,]$corpus_user_id, na.rm = TRUE) / sum(histag_all$histag_14 == TRUE, na.rm = TRUE), 3), 
   "2016" = round(sum(histag_all$is_del == TRUE & histag_all$histag_16 == TRUE & histag_all$corpus_user_id %in% gender[gender$del_or_protected == FALSE,]$corpus_user_id, na.rm = TRUE) / sum(histag_all$histag_16 == TRUE, na.rm = TRUE), 3), 
   "2018" = round(sum(histag_all$is_del == TRUE & histag_all$histag_18 == TRUE & histag_all$corpus_user_id %in% gender[gender$del_or_protected == FALSE,]$corpus_user_id, na.rm = TRUE) / sum(histag_all$histag_18 == TRUE, na.rm = TRUE), 3), 
   "all" = round(sum(histag_all$is_del == TRUE & histag_all$corpus_user_id %in% gender[gender$del_or_protected == FALSE,]$corpus_user_id, na.rm = TRUE) / nrow(histag_all), 3)))



# Save
write.csv(table_deleted_tweets,"./tables/17_table-deleted-tweets.csv", row.names = FALSE)