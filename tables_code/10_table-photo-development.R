# Development of the tweets with links
# Mirrored to the lowered count of tweets with links through the api now the photo count is significantly higher in 2018 with the newly called data

# Library
library(rtweet)

# Data
histag_all <- read_twitter_csv("./data/histag_all.csv")
table_photo_development <- data.frame(category=character(), "2012"=character(), "2014"=character(), "2016"=character(), "2018"=character(), all=character())

# 1. Number of Photos - absolute
temp <- data.frame("number-of-photos-absolute-api", 
                   sum(histag_all[histag_all$histag_12 == TRUE,]$media_type == "photo", na.rm = TRUE),
                   sum(histag_all[histag_all$histag_14 == TRUE,]$media_type == "photo", na.rm = TRUE),
                   sum(histag_all[histag_all$histag_16 == TRUE,]$media_type == "photo", na.rm = TRUE),
                   sum(histag_all[histag_all$histag_18 == TRUE,]$media_type == "photo", na.rm = TRUE),
                   sum(histag_all$media_type == "photo", na.rm = TRUE)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_photo_development <- rbind(table_photo_development, temp)

# 2. Number of Photos - relative
rm(temp)
temp <- data.frame("number-of-photos-relative-api", 
                   round(sum(histag_all[histag_all$histag_12 == TRUE,]$media_type == "photo", na.rm = TRUE) / sum(histag_all$histag_12 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(histag_all[histag_all$histag_14 == TRUE,]$media_type == "photo", na.rm = TRUE) / sum(histag_all$histag_14 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(histag_all[histag_all$histag_16 == TRUE,]$media_type == "photo", na.rm = TRUE) / sum(histag_all$histag_16 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(histag_all[histag_all$histag_18 == TRUE,]$media_type == "photo", na.rm = TRUE) / sum(histag_all$histag_18 == TRUE & histag_all$is_del == FALSE),3),
                   round(sum(histag_all$media_type == "photo", na.rm = TRUE) / sum(histag_all$is_del == FALSE),3)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_photo_development <- rbind.data.frame(table_photo_development, temp)

# 3. Number of Photos in original tweets - absolute
rm(temp)
temp <- data.frame("number-of-photos-absolute-api", 
                   sum(histag_all[histag_all$histag_12 == TRUE & histag_all$is_retweet == FALSE,]$media_type == "photo", na.rm = TRUE),
                   sum(histag_all[histag_all$histag_14 == TRUE & histag_all$is_retweet == FALSE,]$media_type == "photo", na.rm = TRUE),
                   sum(histag_all[histag_all$histag_16 == TRUE & histag_all$is_retweet == FALSE,]$media_type == "photo", na.rm = TRUE),
                   sum(histag_all[histag_all$histag_18 == TRUE & histag_all$is_retweet == FALSE,]$media_type == "photo", na.rm = TRUE),
                   sum(histag_all[histag_all$is_retweet == FALSE,]$media_type == "photo", na.rm = TRUE)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_photo_development <- rbind(table_photo_development, temp)

# 2 Number of Photos in original tweets - relative
rm(temp)
temp <- data.frame("number-of-photos-relative-api", 
                   round(sum(histag_all[histag_all$histag_12 == TRUE & histag_all$is_retweet == FALSE,]$media_type == "photo", na.rm = TRUE) / sum(histag_all$histag_12 == TRUE & histag_all$is_del == FALSE & histag_all$is_retweet == FALSE),3),
                   round(sum(histag_all[histag_all$histag_14 == TRUE & histag_all$is_retweet == FALSE,]$media_type == "photo", na.rm = TRUE) / sum(histag_all$histag_14 == TRUE & histag_all$is_del == FALSE & histag_all$is_retweet == FALSE),3),
                   round(sum(histag_all[histag_all$histag_16 == TRUE & histag_all$is_retweet == FALSE,]$media_type == "photo", na.rm = TRUE) / sum(histag_all$histag_16 == TRUE & histag_all$is_del == FALSE & histag_all$is_retweet == FALSE),3),
                   round(sum(histag_all[histag_all$histag_18 == TRUE & histag_all$is_retweet == FALSE,]$media_type == "photo", na.rm = TRUE) / sum(histag_all$histag_18 == TRUE & histag_all$is_del == FALSE & histag_all$is_retweet == FALSE),3),
                   round(sum(histag_all[histag_all$is_retweet == FALSE,]$media_type == "photo", na.rm = TRUE) / sum(histag_all$is_del == FALSE  & histag_all$is_retweet == FALSE),3)
)

names(temp)<-c("category","2012","2014","2016","2018","all")
table_photo_development <- rbind.data.frame(table_photo_development, temp)

# Save
write.csv(table_photo_development,"./tables/10_table-photo-development.csv", row.names = FALSE)

rm(temp)