# Development of the reply distribution
# Unfortunately the Twitter API doesn't seem to return the variable reply_count anymore, so it is not possible to replicate our original results

# Library
library(rtweet)

# Data
histag_all <- read_twitter_csv("./data/histag_all.csv")

table_reply_distribution_development <- data.frame("year"=character(), "replies-absolute"=character(), "replies-orig-absolute"=character(), "replies-orig-relative"=character())


for (i in c("12","14","16","18","all")) {
  if (i == "all") {
    year <- "all"
    replies_absolute <- sum(histag_all[histag_all$is_del == FALSE, ]$reply_count, na.rm = TRUE)
    replies_orig_absolute <- sum(histag_all$is_del == FALSE & histag_all$reply_count > 0, na.rm = TRUE)
    orig_absolute <- sum(histag_all$is_retweet == FALSE & histag_all$is_del == FALSE, na.rm = TRUE)
  } else {
    year <- paste("histag_",i, sep = "")
    replies_absolute <- sum(histag_all[histag_all[,paste("histag_",i, sep = "")] == TRUE & histag_all$is_del == FALSE, ]$reply_count, na.rm = TRUE)
    replies_orig_absolute <- sum(histag_all[,paste("histag_",i, sep = "")] == TRUE & histag_all$is_del == FALSE & histag_all$reply_count > 0, na.rm = TRUE)
    orig_absolute <- sum(histag_all[,paste("histag_",i, sep = "")] == TRUE & histag_all$is_retweet == FALSE & histag_all$is_del == FALSE, na.rm = TRUE)
  }
  
  temp <- data.frame(year, replies_absolute, replies_orig_absolute, round(replies_orig_absolute / orig_absolute,3))
  names(temp)<-c("year", "replies-absolute", "replies-orig-absolute", "replies-orig-relative")
  
  table_reply_distribution_development <- rbind(table_reply_distribution_development, temp)

  rm(temp)
  rm(year)
  rm(replies_absolute)
  rm(replies_orig_absolute)
  rm(orig_absolute)
}


# Save
write.csv(table_reply_distribution_development,"./tables/8_table-reply-distribution-development.csv", row.names = FALSE)

rm(i)