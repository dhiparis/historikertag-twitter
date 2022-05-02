# Yearly number of likes per gender

# Library
library(rtweet)

# Load Data
histag_all <- read_twitter_csv("./data/histag_all.csv")

# Create table
table_gender_likes <- data.frame(year=character(), m=numeric(), f=numeric(), i=numeric(), e=numeric(), z=numeric(), a=numeric(), b=numeric(), u=numeric())

get_gender_likes <- function(year, gender) {
  if(year != "all") {
    return(round(mean(histag_all[histag_all[,paste("histag_",i, sep = "")] == TRUE & histag_all$Gender == gender,]$favorite_count, na.rm = TRUE),2))
  } else {
    return(round(mean(histag_all[histag_all$Gender == gender,]$favorite_count, na.rm = TRUE),2))
  }
}

for (i in c(12,14,16,18,"all")) {
  temp <- data.frame(year = i, 
                     m = get_gender_likes(i, "m"),
                     f = get_gender_likes(i, "f"),
                     i = get_gender_likes(i, "i"),
                     e = get_gender_likes(i, "e"),
                     z = get_gender_likes(i, "z"),
                     a = get_gender_likes(i, "a"),
                     b = get_gender_likes(i, "b"),
                     u = get_gender_likes(i, "u")
  )
  
  table_gender_likes <- rbind(table_gender_likes, temp)
}

rm(temp)

# Save
write.csv(table_gender_likes,"./tables/15_table-gender-likes.csv", row.names = FALSE)