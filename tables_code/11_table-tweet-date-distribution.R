# Tweet date distribution
# The papers table also includes deleted tweets, so this again can't be completely mirrored

# Library
library(rtweet)
library(dplyr)

# Load Data
histag_all <- read_twitter_csv("./data/histag_all.csv")

# Create table
table_tweet_date_distribution <- data.frame("year"=character(), "before-day-before"=integer(), "day-before"=integer(), "day-1"=integer(), "day-2"=integer(), "day-3"=integer(), "day-4"=integer(),"day-after"=integer(),"after-day-after"=integer(),"all"=integer(),"before"=integer(),"during"=integer(),"after"=integer())
day_one <- list("12"="2012-09-25", "14"="2014-09-23", "16"="2016-09-20", "18"="2018-09-25")

# Iterate through years
for (i in c("12","14","16","18")) {
  histag_temp <- histag_all[histag_all[,paste("histag_",i, sep = "")] == TRUE & histag_all$is_del == FALSE,]
  
  temp <- data.frame(
    "year" = paste("20",i, sep = ""), 
    "before-day-before" = nrow(histag_temp %>% dplyr::filter(created_at < as.Date(day_one[[i]], tz = "Europe/Berlin") - 1)), 
    "day-before" = nrow(histag_temp %>% dplyr::filter(created_at == as.Date(day_one[[i]], tz = "Europe/Berlin") - 1)), 
    "day-1" = nrow(histag_temp %>% dplyr::filter(created_at == as.Date(day_one[[i]], tz = "Europe/Berlin"))), 
    "day-2" = nrow(histag_temp %>% dplyr::filter(created_at == as.Date(day_one[[i]], tz = "Europe/Berlin") + 1)), 
    "day-3" = nrow(histag_temp %>% dplyr::filter(created_at == as.Date(day_one[[i]], tz = "Europe/Berlin") + 2)), 
    "day-4" = nrow(histag_temp %>% dplyr::filter(created_at == as.Date(day_one[[i]], tz = "Europe/Berlin") + 3)),
    "day-after" = nrow(histag_temp %>% dplyr::filter(created_at == as.Date(day_one[[i]], tz = "Europe/Berlin") + 4)),
    "after-day-after" = nrow(histag_temp %>% dplyr::filter(created_at > as.Date(day_one[[i]], tz = "Europe/Berlin") + 4)),
    "all" = nrow(histag_temp),
    "before" = nrow(histag_temp %>% dplyr::filter(created_at < as.Date(day_one[[i]], tz = "Europe/Berlin"))),
    "during" = nrow(histag_temp %>% dplyr::filter((created_at >= as.Date(day_one[[i]], tz = "Europe/Berlin")) & (created_at <= as.Date(day_one[[i]], tz = "Europe/Berlin") + 3))),
    "after" = nrow(histag_temp %>% dplyr::filter(created_at >= as.Date(day_one[[i]], tz = "Europe/Berlin") + 4)))
  
  table_tweet_date_distribution <- rbind(table_tweet_date_distribution, temp)
  
  # Add relative
  temp_rel <- temp
  temp_rel[1] <- paste(temp[1],"-relative", sep = "")
  temp_rel[2:13] <- round(temp[2:13] / nrow(histag_temp), 3)
  table_tweet_date_distribution <- rbind(table_tweet_date_distribution, temp_rel)
  
  if(exists("all_date")) {
    all_date[2:13] <- all_date[2:13] + temp[2:13]
  } else {
    all_date <- temp
  }
}

# Add all_date columns
all_date[1] <- "all"
table_tweet_date_distribution <- rbind(table_tweet_date_distribution, all_date)
temp_rel <- all_date
temp_rel[1] <- "all-relative"
temp_rel[2:13] <- round(all_date[2:13] / nrow(histag_all[histag_all$is_del == FALSE,]), 3)
table_tweet_date_distribution <- rbind(table_tweet_date_distribution, temp_rel)

# Delete variables
rm(all_date)
rm(temp)
rm(temp_rel)
rm(histag_temp)
rm(day_one)

# Save
write.csv(table_tweet_date_distribution,"./tables/11_table-tweet-date-distribution.csv", row.names = FALSE)