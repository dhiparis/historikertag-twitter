# Development of replies within the corpus

# Unfortunately the twitter API doesn't seem to return the variable reply_count anymore, so it is not possible to replicate our original results
# The original results also count replies that are not in the corpus, but as a work around here one can use the reply_to_status_id
# The development of 2012 to 2014 is mirrored in this data, however 2016 and 2018 the numbers declines much more than based on the reply_count which only show a small decline
# This only shows, that the usage of the hashtag in replies is declining but not replies in general, something one could wrongfully interpret in this data

# Libraries
library(rtweet)
library(ggplot2)

# Data
histag_all <- read_twitter_csv("./data/histag_all.csv")

# Original source
# reply_development <- data.frame(year = c(2012,2014,2016,2018), 
#                                      count = c(sum(histag_all[histag_all$api_12 == TRUE & histag_all$is_del == FALSE, ]$reply_count, na.rm = TRUE), 
#                                                sum(histag_all[histag_all$api_14 == TRUE & histag_all$is_del == FALSE, ]$reply_count, na.rm = TRUE), 
#                                                sum(histag_all[histag_all$api_16 == TRUE & histag_all$is_del == FALSE, ]$reply_count, na.rm = TRUE), 
#                                                sum(histag_all[histag_all$api_18 == TRUE & histag_all$is_del == FALSE, ]$reply_count, na.rm = TRUE)
#                                      )
#)

# New metric
figure_reply_corpus_development <- data.frame(year = c(2012,2014,2016,2018), 
                                        count = c(sum(!is.na(histag_all[histag_all$api_12 == TRUE & histag_all$is_del == FALSE, ]$reply_to_status_id)), 
                                                  sum(!is.na(histag_all[histag_all$api_14 == TRUE & histag_all$is_del == FALSE, ]$reply_to_status_id)), 
                                                  sum(!is.na(histag_all[histag_all$api_16 == TRUE & histag_all$is_del == FALSE, ]$reply_to_status_id)), 
                                                  sum(!is.na(histag_all[histag_all$api_18 == TRUE & histag_all$is_del == FALSE, ]$reply_to_status_id))
                                        )
)

# Plot
ggplot(data=figure_reply_corpus_development, aes(x=year, y=count, group=1)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 300)) +
  geom_line(color="orange") +
  geom_point(color="orange", size=2) +
  ggtitle(label = "Antworten innerhalb des Korpus", subtitle = "Auf Basis des API-Korpus, dadurch sind gelöschte Tweets nicht berücksichtigt\nAntworten ohne ein Tagungshashtag sind nicht berücksichtigt") +
  xlab("Jahr") + 
  ylab("Anzahl der Antworten") +
  theme_minimal()

# Save
ggsave(
  "10_figure-reply-development.png",
  plot = last_plot(),
  device = png,
  path = "./figures/",
  scale = 1,
  width = 1250,
  height = 750,
  units = "px",
  dpi = 150,
  limitsize = TRUE,
  bg = "white"
)