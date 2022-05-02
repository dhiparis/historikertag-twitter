# Development of mentions in original tweets

# Libraries
library(rtweet)
library(ggplot2)

# Data
histag_all <- read_twitter_csv("./data/histag_all.csv")
figure_mentions_orig_development <- data.frame(year = c(2012,2014,2016,2018), 
                                      count = c(sum(!is.na(histag_all[histag_all$api_12 == TRUE & histag_all$is_retweet == FALSE & histag_all$is_del == FALSE, ]$mentions_screen_name)), 
                                                sum(!is.na(histag_all[histag_all$api_14 == TRUE & histag_all$is_retweet == FALSE & histag_all$is_del == FALSE, ]$mentions_screen_name)), 
                                                sum(!is.na(histag_all[histag_all$api_16 == TRUE & histag_all$is_retweet == FALSE & histag_all$is_del == FALSE, ]$mentions_screen_name)), 
                                                sum(!is.na(histag_all[histag_all$api_18 == TRUE & histag_all$is_retweet == FALSE & histag_all$is_del == FALSE, ]$mentions_screen_name))
                                      )
)

# Plot
ggplot(data=figure_mentions_orig_development, aes(x=year, y=count, group=1)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 800)) +
  geom_line(color="orange") +
  geom_point(color="orange", size=2) +
  ggtitle(label = "Originaltweets mit Mentions", subtitle = "Auf Basis des API-Korpus, dadurch sind gelöschte Tweets nicht berücksichtigt") +
  xlab("Jahr") + 
  ylab("Anzahl der Tweets") +
  theme_minimal()

# Save
ggsave(
  "9_figure-mentions-orig-development.png",
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