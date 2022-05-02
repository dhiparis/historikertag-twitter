# Corpus Analysis in Voyant tools
# The figures 21 - 26 are exported from Voyant tools, with this code it is just possible to export the raw unprocessed tweet text
# More info on Voyant tools: https://voyant-tools.org/

# 1. Library
library(rtweet)

# Data
histag_all <- read_twitter_csv("./data/histag_all.csv")

# Export data
write_as_csv(histag_all[histag_all$is_retweet == FALSE, c('text')], "./data/21_25_26_histag_all-orig.csv", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")
write_as_csv(histag_all[histag_all$is_retweet == FALSE & histag_all$Gender == "m", c('text')], "./data/22_histag_all-orig-gender-m.csv", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")
write_as_csv(histag_all[histag_all$is_retweet == FALSE & histag_all$Gender == "f", c('text')], "./data/23_histag_all-orig-gender-f.csv", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")
write_as_csv(histag_all[histag_all$is_retweet == FALSE & histag_all$histag_18 == TRUE, c('text')], "./data/24_histag_all-orig-18.csv", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")
