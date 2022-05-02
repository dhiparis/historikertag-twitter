# Number of accounts

# Libraries
library(rtweet)
library(ggplot2)

# Data
gender <- read_twitter_csv("./data/gender.csv")
figure_number_of_accounts <- data.frame(year = c(2012,2014,2016,2018), 
                                 count = c(nrow(gender[gender$tweet_count_12 > 0,]), 
                                           nrow(gender[gender$tweet_count_14 > 0,]), 
                                           nrow(gender[gender$tweet_count_16 > 0,]), 
                                           nrow(gender[gender$tweet_count_18 > 0,])
                                           )
)

# Plot
ggplot(data=figure_number_of_accounts, aes(x=year, y=count, group=1)) +
  geom_line(color="orange") +
  geom_point(color="orange", size=2) +
  ggtitle(label = "Twitternde Accounts", subtitle = "Auf Basis des Kombinationskorpus, hier sind auch gelöschte Tweets berücksichtigt") +
  xlab("Jahr") + 
  ylab("Anzahl der Accounts") +
  theme_minimal()

# Save
ggsave(
  "3_figure-number-of-accounts.png",
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