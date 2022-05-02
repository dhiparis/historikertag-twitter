# Development of like numbers

# Libraries
library(rtweet)
library(ggplot2)

# Data
histag_all <- read_twitter_csv("./data/histag_all.csv")
figure_likes_development <- data.frame(year = c(2012,2014,2016,2018), 
                                      count = c(sum(histag_all[histag_all$api_12 == TRUE, ]$favorite_count, na.rm = TRUE), 
                                                sum(histag_all[histag_all$api_14 == TRUE, ]$favorite_count, na.rm = TRUE), 
                                                sum(histag_all[histag_all$api_16 == TRUE, ]$favorite_count, na.rm = TRUE), 
                                                sum(histag_all[histag_all$api_18 == TRUE, ]$favorite_count, na.rm = TRUE)
                                      )
)

# Plot
ggplot(data=figure_likes_development, aes(x=year, y=count, group=1)) +
  geom_line(color="orange") +
  geom_point(color="orange", size=2) +
  ggtitle(label = "Likes/Favs", subtitle = "Auf Basis des API-Korpus, dadurch sind gelöschte Tweets nicht berücksichtigt") +
  xlab("Jahr") + 
  ylab("Anzahl der Likes") +
  theme_minimal()

# Save
ggsave(
  "8_figure-likes-development.png",
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