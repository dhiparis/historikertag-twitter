# Development of replies
# Unfortunately the twitter API doesn't seem to return the variable reply_count anymore, so it is not possible to replicate our original results

# Library
library(rtweet)

# Data
histag_all <- read_twitter_csv("./data/histag_all.csv")

table_reply_development <- data.frame("year"=character(), "replies-absolute"=character(), "replies-hashtag-absolute"=character(), "replies-hashtag-relative"=character())

replies_absolute <- list("12" = sum(histag_all[histag_all$api_12 == TRUE & histag_all$is_del == FALSE, ]$reply_count, na.rm = TRUE),
                         "14" = sum(histag_all[histag_all$api_14 == TRUE & histag_all$is_del == FALSE, ]$reply_count, na.rm = TRUE),
                         "16" = sum(histag_all[histag_all$api_16 == TRUE & histag_all$is_del == FALSE, ]$reply_count, na.rm = TRUE),
                         "18" = sum(histag_all[histag_all$api_18 == TRUE & histag_all$is_del == FALSE, ]$reply_count, na.rm = TRUE),
                         "all" = sum(histag_all[histag_all$is_del == FALSE, ]$reply_count, na.rm = TRUE)
)

# With the following code you can compare the data to the one we called:
# replies_absolute <- list("12" = 128, "14" = 639, "16" = 631, "18" = 572, "all" = 1964)

for (i in c("12","14","16","18","all")) {
  if (i == "all") {
    year <- "all"
    replies_absolute_temp = replies_absolute[[i]]
    replies_hashtag_absolute = sum(!is.na(histag_all[histag_all$is_del == FALSE, ]$reply_to_status_id))
  } else {
    year <- paste("histag_",i, sep = "")
    replies_absolute_temp = replies_absolute[[i]]
    replies_hashtag_absolute <- sum(!is.na(histag_all[histag_all[,paste("histag_",i, sep = "")] == TRUE & histag_all$is_del == FALSE, ]$reply_to_status_id))
  }
  
  temp <- data.frame(year, replies_absolute_temp, replies_hashtag_absolute, round(replies_hashtag_absolute / replies_absolute_temp,3))
  names(temp)<-c("year", "replies-absolute", "replies-hashtag-absolute", "replies-hashtag-relative")
  
  table_reply_development <- rbind(table_reply_development, temp)
  
  rm(temp)
  rm(replies_hashtag_absolute)
  rm(replies_absolute_temp)
  rm(year)
}


# Save
write.csv(table_reply_development,"./tables/7_table-reply-development.csv", row.names = FALSE)

rm(i)