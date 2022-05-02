# Tweet distribution during the conference 2016
# Our plot also contained scrapped (and deleted) tweets, so the graph might slightly differ

# Libraries
library(rtweet)
library(dplyr)
library(plyr)
library(ggplot2)
library(scales)

# Data
histag_all <- read_twitter_csv("./data/histag_all.csv")
plot_info <- c("2016-09-19","Historikertag 2016 (20.-23.09.2016)", "Tweets je 20 Minuten von 19.09.-24.09. Betrachtete Hashtags: #histag16, #historikertag16, #historikertag2016, #histtag16", "13_figure-tweet-distribution-2016.png")

# Filter by Date
tsMinute_histag_temp <- histag_all[histag_all$histag_16 == TRUE,] %>% dplyr::filter((created_at >= as.Date(plot_info[1], tz = "Europe/Berlin")) & (created_at <= as.Date(plot_info[1], tz = "Europe/Berlin") + 6))

# Convert tweets data into time series-like data object
tsMinute_histag_temp <- ts_data(tsMinute_histag_temp, by = "mins", trim = 0L, tz = "Europe/Berlin")

# Make 20 min Intervalls
tsMinute_histag_temp$time <- cut(tsMinute_histag_temp$time, breaks = "20 min")
tsMinute_histag_temp <- ddply(tsMinute_histag_temp, "time", numcolwise(sum))

# Conversion to as.POSIXct with german timestamp from UTC (Twitter default)
tsMinute_histag_temp$time <- as.POSIXct(tsMinute_histag_temp$time)
tsMinute_histag_temp$time <- (tsMinute_histag_temp$time + 2*60*60)

# Plot
theme_set(theme_minimal())
ggplot(data = tsMinute_histag_temp, aes(x = time, y = n, group = 1)) +
  geom_line(color = "#00AFBB", size = 1) + 
  scale_x_datetime(breaks = date_breaks("2 hours"), date_labels = "%H", limits = c(as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin")), as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin") + 6)), expand = c(0, 0)) + 
  
  # Date lines
  geom_vline(xintercept = as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin")), linetype=1, color = "grey") +
  geom_vline(xintercept = as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin") + 1), linetype=1, color = "grey") +
  geom_vline(xintercept = as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin") + 2), linetype=1, color = "grey") +
  geom_vline(xintercept = as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin") + 3), linetype=1, color = "grey") +
  geom_vline(xintercept = as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin") + 4), linetype=1, color = "grey") +
  geom_vline(xintercept = as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin") + 5), linetype=1, color = "grey") +
  geom_vline(xintercept = as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin") + 6), linetype=1, color = "grey") +
  
  # Date text
  geom_text(aes(x=as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin")) + 2 * 60 * 60, y=90, label=format(as.Date(plot_info[1]), "%d.%m."), hjust = 0, vjust = 0), check_overlap = T) +
  geom_text(aes(x=as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin") + 1) + 2 * 60 * 60, y=90, label=format(as.Date(plot_info[1]) + 1, "%d.%m."), hjust = 0, vjust = 0), check_overlap = T) +
  geom_text(aes(x=as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin") + 2) + 2 * 60 * 60, y=90, label=format(as.Date(plot_info[1]) + 2, "%d.%m."), hjust = 0, vjust = 0), check_overlap = T) +
  geom_text(aes(x=as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin") + 3) + 2 * 60 * 60, y=90, label=format(as.Date(plot_info[1]) + 3, "%d.%m."), hjust = 0, vjust = 0), check_overlap = T) +
  geom_text(aes(x=as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin") + 4) + 2 * 60 * 60, y=90, label=format(as.Date(plot_info[1]) + 4, "%d.%m."), hjust = 0, vjust = 0), check_overlap = T) +
  geom_text(aes(x=as.POSIXct(as.Date(plot_info[1], tz = "Europe/Berlin") + 5) + 2 * 60 * 60, y=90, label=format(as.Date(plot_info[1]) + 5, "%d.%m."), hjust = 0, vjust = 0), check_overlap = T) +
  
  # Scale (to make plots from different year directly comparable)
  ylim(0, 90) +
  geom_vline(xintercept = 00)+ 
  
  # Show the trend with smooting with Locally Weighted Scatterplot Smoothing (LOESS)
  stat_smooth(color = "#FC4E07", fill = "#FC4E07", method = "loess") +
  ggplot2::theme(
    legend.title = ggplot2::element_blank(),
    legend.position = "bottom",
    plot.title = ggplot2::element_text(face = "bold")) +
  
  # Label
  ggplot2::labs(
    x = NULL, y = NULL,
    title = plot_info[2],
    subtitle = plot_info[3],
    caption = "Quelle: Twitter-API"
  )

# Save
ggsave(
  plot_info[4],
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

rm(tsMinute_histag_temp)
rm(plot_info)
