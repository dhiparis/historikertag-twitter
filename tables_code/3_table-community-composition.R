# Composition of the community
# This table has slightly different (< +- 2) numbers in certain places due to an update

# Library
library(rtweet)

# Data
gender <- read_twitter_csv("./data/gender.csv")

table_community_composition <- data.frame("gender"=character(), "2012"=character(), "2014"=character(), "2016"=character(), "2018"=character(), "all"=character())

for (char in c("m","f","i","e","z","a","b","u")) {
  temp <- data.frame(
    char,
    sum(gender$gender == char & gender$tweet_count_12 > 0, na.rm = TRUE),
    sum(gender$gender == char & gender$tweet_count_14 > 0, na.rm = TRUE),
    sum(gender$gender == char & gender$tweet_count_16 > 0, na.rm = TRUE), 
    sum(gender$gender == char & gender$tweet_count_18 > 0, na.rm = TRUE),
    sum(gender$gender == char)
  )
  names(temp)<-c("gender", "2012", "2014", "2016", "2018", "all")
  table_community_composition <- rbind(table_community_composition, temp)
  
  rm(temp)
  temp <- data.frame(
    paste(char, "-relative", sep = ""),
    round(sum(gender$gender == char & gender$tweet_count_12 > 0, na.rm = TRUE)/nrow(gender[gender$tweet_count_12 > 0,]),3),
    round(sum(gender$gender == char & gender$tweet_count_14 > 0, na.rm = TRUE)/nrow(gender[gender$tweet_count_14 > 0,]),3),
    round(sum(gender$gender == char & gender$tweet_count_16 > 0, na.rm = TRUE)/nrow(gender[gender$tweet_count_16 > 0,]),3), 
    round(sum(gender$gender == char & gender$tweet_count_18 > 0, na.rm = TRUE)/nrow(gender[gender$tweet_count_18 > 0,]),3),
    round(sum(gender$gender == char)/nrow(gender),3)
  )
  names(temp)<-c("gender", "2012", "2014", "2016", "2018", "all")
  table_community_composition <- rbind(table_community_composition, temp)
}

rm(temp)
temp <- data.frame(
  "all",
  nrow(gender[gender$tweet_count_12 > 0,]),
  nrow(gender[gender$tweet_count_14 > 0,]),
  nrow(gender[gender$tweet_count_16 > 0,]), 
  nrow(gender[gender$tweet_count_18 > 0,]),
  nrow(gender)
)
names(temp)<-c("gender", "2012", "2014", "2016", "2018", "all")
table_community_composition <- rbind(table_community_composition, temp)

table_community_composition$"2012" <- as.character(table_community_composition$"2012")
table_community_composition$"2014" <- as.character(table_community_composition$"2014")
table_community_composition$"2016" <- as.character(table_community_composition$"2016")
table_community_composition$"2018" <- as.character(table_community_composition$"2018")
table_community_composition$"all" <- as.character(table_community_composition$"all")
write.csv(table_community_composition,"./tables/3_table-community-composition.csv", row.names = FALSE)

rm(temp)
rm(char)