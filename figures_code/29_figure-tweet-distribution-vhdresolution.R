# Distribution of tweets with the hashtag #vhdresolution
# This script downloads the tweets from twitter, so you need to set an API token (see historikertage_code.R)

# Libraries
library(rtweet)
library(ggplot2)

# Original Call
# VHDResolution <- search_fullarchive("#VHDResolution", n = 1000, env_name="Archive", token = token2, fromDate="201001010101", toDate = "201912022359")

# Load Data
VHDResolution_dehydrated <- read_twitter_csv("./data/VHDResolution_dehydrated_prepended-ids.csv")
VHDResolution <- lookup_tweets(VHDResolution_dehydrated$status_id, token = token)
VHDResolution <- merge(x = VHDResolution, y = VHDResolution_dehydrated, by = "status_id", all.x=TRUE, all.y=TRUE)
rm(VHDResolution_dehydrated)

# Count deleted tweets
sum(is.na(VHDResolution$user_id))

# Plot the graph
figure_VHDResolution_plot <- ts_plot(VHDResolution, "days")

figure_VHDResolution_plot <- figure_VHDResolution_plot +
  geom_line(color = "orange", size = 1) + 
  ggplot2::theme(
  legend.title = ggplot2::element_blank(),
  legend.position = "bottom",
  plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Tägliche Tweets mit #vhdresolution",
    caption = "Quelle: Twitter-API"
  )

# Save
ggsave(
  "29_figure-tweet-distribution-vhdresolution.png",
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