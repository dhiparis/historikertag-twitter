# Community composition

# Libraries
library(rtweet)
library(ggplot2)

# Data
gender <- read_twitter_csv("./data/gender.csv")
figure_community_composition <- data.frame(gender = c("Männer","Frauen","Institutionen","Unternehmen","Zeitschriften","Anonym","Bot","Unbekannt"), 
                                 count = c(sum(gender$gender == "m", na.rm = TRUE),
                                           sum(gender$gender == "f", na.rm = TRUE),
                                           sum(gender$gender == "i", na.rm = TRUE),
                                           sum(gender$gender == "e", na.rm = TRUE), 
                                           sum(gender$gender == "z", na.rm = TRUE), 
                                           sum(gender$gender == "a", na.rm = TRUE), 
                                           sum(gender$gender == "b", na.rm = TRUE), 
                                           sum(gender$gender == "u", na.rm = TRUE)
                                           )
)

# lock in factor level order
figure_community_composition$gender <- factor(figure_community_composition$gender, levels = figure_community_composition$gender)

# Plot
ggplot(data=figure_community_composition, aes(x=gender, y=count, group=1, label=count))  +
  geom_bar(stat="identity", fill="orange")+
  geom_text(size = 3, position = position_dodge(width = 1), vjust = -1,)+
  ggtitle(label = "Zusammensetzung der Twitter-Community insgesamt", subtitle = "n = 1970") +
  xlab("Gender/Typ") + 
  ylab("Anzahl der Accounts") +
  theme_minimal() 


# Save
ggsave(
  "4_figure-community-composition.png",
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