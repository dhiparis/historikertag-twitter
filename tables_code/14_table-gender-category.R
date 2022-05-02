# Number of tweets per gender and category

# Library
library(rtweet)

# Load Data
histag_all <- read_twitter_csv("./data/histag_all.csv")

# Create table
table_gender_category <- data.frame(category=character(), m=numeric(), f=numeric(), i=numeric(), e=numeric(), z=numeric(), a=numeric(), b=numeric(), u=numeric())

for (i in c(0,1,2,3,4,5,6,7)) {
  temp <- data.frame(i, sum(histag_all$hauptkategorie_1 == i & histag_all$Gender == "m", na.rm = TRUE),
                     sum(histag_all$hauptkategorie_1 == i & histag_all$Gender == "f", na.rm = TRUE),
                     sum(histag_all$hauptkategorie_1 == i & histag_all$Gender == "i", na.rm = TRUE),
                     sum(histag_all$hauptkategorie_1 == i & histag_all$Gender == "e", na.rm = TRUE),
                     sum(histag_all$hauptkategorie_1 == i & histag_all$Gender == "z", na.rm = TRUE),
                     sum(histag_all$hauptkategorie_1 == i & histag_all$Gender == "a", na.rm = TRUE),
                     sum(histag_all$hauptkategorie_1 == i & histag_all$Gender == "b", na.rm = TRUE),
                     sum(histag_all$hauptkategorie_1 == i & histag_all$Gender == "u", na.rm = TRUE)
  )
  names(temp)<-c("category","m","f","i","e","z","a","b","u")
  table_gender_category <- rbind(table_gender_category, temp)
}

temp <- data.frame("all", 
                   sum(histag_all$Gender == "m", na.rm = TRUE),
                   sum(histag_all$Gender == "f", na.rm = TRUE),
                   sum(histag_all$Gender == "i", na.rm = TRUE),
                   sum(histag_all$Gender == "e", na.rm = TRUE),
                   sum(histag_all$Gender == "z", na.rm = TRUE),
                   sum(histag_all$Gender == "a", na.rm = TRUE),
                   sum(histag_all$Gender == "b", na.rm = TRUE),
                   sum(histag_all$Gender == "u", na.rm = TRUE)
)
names(temp)<-c("category","m","f","i","e","z","a","b","u")
table_gender_category <- rbind(table_gender_category, temp)

rm(temp)

# Save
write.csv(table_gender_category,"./tables/14_table-gender-category.csv", row.names = FALSE)