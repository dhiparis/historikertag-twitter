# Tweet distribution of the @historikertag account
# Before plotting this figure the tweets of @historikertag need to be downloaded, see (tables_code/18_table-account-historikertag-tweets.R)

# Libraries
library(rtweet)
library(ggplot2)

# Load Data
histag_account_historikertag <- read_twitter_csv("./data/histag_account_historikertag.csv")

figure_histag_account_plot <- ts_plot(histag_account_historikertag, "days")

figure_histag_account_plot <- figure_histag_account_plot +
  geom_line(color = "orange", size = 1) + 
  ggplot2::theme(
  legend.title = ggplot2::element_blank(),
  legend.position = "bottom",
  plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Tägliche Tweets von @historikertag",
    caption = "Quelle: Twitter-API"
  )

# Save
ggsave(
  "28_figure-tweet-distribution-account-historikertag.png",
  plot = last_plot(),
  device = png,
  path = "./figures/",
  scale = 1,
  width = 2000,
  height = 1000,
  units = "px",
  dpi = 150,
  limitsize = TRUE,
  bg = "white"
)