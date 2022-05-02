# Distribution of categories among deleted tweets 
# The numbers will not only differ from the papers because of the later API call (and presumably more deleted tweets) 
# But also because it can't certainly be said whether an account is deleted or protected and should therefore be filtered out as in the paper
# Or: Whether certain accounts are filtered out because all their tweet(s) that where in the corpus are deleted, and we can't determine their status anymore
# Therefore this numbers must be accessed carefully

# Libraries
library(rtweet)
library(ggplot2)

# Load Data
histag_all <- read_twitter_csv("./data/histag_all.csv")
gender <- read_twitter_csv("./data/gender.csv")

# Function
get_del_tweets_rel <- function(tweet_table, user_table, code) {
  count = sum(tweet_table$is_del == TRUE & tweet_table$hauptkategorie_1 == code & tweet_table$corpus_user_id %in% user_table[user_table$del_or_protected == TRUE,]$corpus_user_id, na.rm = TRUE)
  return(count/sum(tweet_table$is_del == TRUE & tweet_table$corpus_user_id %in% user_table[user_table$del_or_protected == TRUE,]$corpus_user_id, na.rm = TRUE))
}

# Create table
figure_deleted_tweets <- data.frame(type = c("0","1","2","3","4","5","6","7"),
                                    proportion = c(get_del_tweets_rel(histag_all,gender,"0"), 
                                                  get_del_tweets_rel(histag_all,gender,"1"), 
                                                  get_del_tweets_rel(histag_all,gender,"2"), 
                                                  get_del_tweets_rel(histag_all,gender,"3"), 
                                                  get_del_tweets_rel(histag_all,gender,"4"), 
                                                  get_del_tweets_rel(histag_all,gender,"5"), 
                                                  get_del_tweets_rel(histag_all,gender,"6"), 
                                                  get_del_tweets_rel(histag_all,gender,"7"))
                                     )

# Plot
ggplot(data=figure_deleted_tweets, aes(x=type, y=proportion, group=1, label=proportion))  +
  geom_bar(stat="identity", fill="orange") +
  labs(title = "Kategorien gelöschter Historikertag-Tweets", 
          subtitle = "Verteilung gelöschter Historikertag-Tweets der Jahre 2012, 2014, 2016 und 2018 hinsichtlich ihrer Kategorie,  \nTweets gelöschter und geschützter Accounts ausgeblendet",
          caption = paste("\nQuelle: Tweet-Sammlung mithilfe von Scrapping-Tools im Anschluss an die Veranstaltung, manuelle Kategorisierung, n = ",sum(histag_all$is_del == TRUE & histag_all$corpus_user_id %in% gender[gender$del_or_protected  == TRUE,]$corpus_user_id, na.rm = TRUE))
          ) +
  xlab("Kategorie") + 
  ylab("Anteil an Menge gelöschter Tweets") +
  theme_minimal() 

# Save
ggsave(
  "27_figure-categories-deleted-tweets.png",
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