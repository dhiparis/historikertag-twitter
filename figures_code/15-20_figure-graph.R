# Collection and Export of data to work with Gephi
# With this code it is possible to collect and export the data for the nodes (the users) and edges (their follow connections)
# The graphs themselves were exported from Gephi, to learn more on that look into the data report, this code contains only the preparation to work with it in Gephi
# Other possible network analysis include retweet and mention networks

# As with all the information that is called via the API, deleted tweets and users can't be part of the study
# There are the following accounts missing: Deleted users, accounts that are protected and users who deleted the only tweet(s) that were in the corpus (these tweets functioned as key to their account info)
# While during our study in December 2019 69 Accounts had this problem (deleted: 59, protected: 18, deleted tweets not being a problem for the original study), 
# as of writing this (April 2022) 204 Accounts are missing from the corpus (= deleted, protected, deleted key tweet(s)), type sum(gender$del_or_protected) to determine how the situation is for you now
# A forth group is later filtered during the CSV export: users that have less than 2 followers within the community, this might also be influenced by now missing accounts
# In the end this means of the original 1711 Nodes in our paper, in April 2022 only 1598 remain. Furthermore new connections might have been added and old ones cut.

# Helpful resources for Gephi & R
# Youtube tutorial on exporting data from R into Gephi: https://www.youtube.com/watch?v=QNJSUCGYRwk
# A PDF with info on importing CSV files into Gephi: https://seinecle.github.io/gephi-tutorials/generated-pdf/importing-csv-data-in-gephi-en.pdf
# Some slides on the import of CSV files into Gephi: https://rstudio-pubs-static.s3.amazonaws.com/217696_9b28d8fb031647618ccc0e0b23c7e902.html#/59

# Table of contents
# 1. Libraries
# 2. Load Data
# 3. Get Followers
# 3. Create List of followers and friends
# 4. Export Edges & Nodes

# 1. Libraries
library(rtweet)
library(dplyr)

# 2. Load Data
histag_all <- read_twitter_csv("./data/histag_all.csv")
gender <- read_twitter_csv("./data/gender.csv")

# 3. Get followers (and friends)
# followers: accounts that follow a specific account
# friends: the accounts a specific account follows

# 3.1 Algorithm to iterate over the user to get the followers
# The threshold prevents that account with a lot followers (in April 2022 this is @AuswaertigesAmt and @Tagesschau) get scraped as that takes a lot of time
# For the scraping the token (see historikertage_code.R) needs to be set

# Set variable to later determine whether user has already been scraped
gender$follower_scraped <- FALSE
followers_all <- data.frame(user_id=character(), friend_of_id=character())
follower_threshold <- 600000

# Twitter allows up to 15 Requests per 15 Minutes, each request containing max. 5 000 accounts, accounts with more followers need multiple requests
# With the following code you can make a rough approximation of how much time it will need depending on the follower_threshold
# As of writing this is 40 hours, however the call can be stopped in between due to the algorithm taking up were it stopped
(sum(gender$followers_count < 5000, na.rm = TRUE) + round(sum(gender[gender$followers_count > 5000 & gender$followers_count < follower_threshold,]$followers_count, na.rm = TRUE) / 5000, 0)) / 60

# The api call uses the gender$followers_count (+10 % buffer) to determine how many it will ask for, so make sure between the initial call of the histag_all and this api call is not to much time (meaning months)
for (i in 1:nrow(gender)) {
  if (!is.na(gender$followers_count[i]) && gender$follower_scraped[i] == FALSE && gender$followers_count[i] < follower_threshold){
    temp <- data.frame(user_id=character(), followed_id=character())
    number_of_followers_return <- gender$followers_count[i] * 1.1
    temp <- get_followers(gender$user_id[i], 
                          n = number_of_followers_return,
                          page = "-1",
                          retryonratelimit = TRUE,
                          parse = TRUE,
                          verbose = TRUE,
                          token = token
    )
    message("Stand: ", i, "/", nrow(gender)) 
    temp$followed_id <- gender$user_id[i]
    followers_all <- rbind(followers_all, temp)
    gender$follower_scraped[i] <- TRUE
    
    rm(temp)
    rm(number_of_followers_return)
  }
}

rm(follower_threshold)

# 3.2 Algorithm to get all friends of the users
# Just to replicate the papers Gephi graph, it is not needed to although scrape the friends; 
# However with this data we can also identify users that have many followers in the historikertag community, e.g. international historians that didn't actively participate
# If you are not interested into looking into this, you can skip this; none of the later code in this file require this step

# gender$friends_scrapped  <- FALSE 
# friends_all <- data.frame(user_id=character(), friend_of_id=character())

# for (i in 1:nrow(gender)) {
#   if (!is.na(gender$friends_count[i]) && gender$friends_scrapped[i] == FALSE){
#     number_of_friends_return <- gender$friends_count[i] * 1.1
#     temp <- data.frame(user_id=character(), friend_of_id=character())
#     temp <- get_followers(gender$user_id[i], 
#                           n = number_of_friends_return,
#                           page = "-1",
#                           retryonratelimit = TRUE,
#                           parse = TRUE,
#                           verbose = TRUE,
#                           token = token
#     )
#     message("Stand: ", i, "/", nrow(gender)) 
#     temp$friend_of_id <- gender$user_id[i]
#     friends_all <- rbind(friends_all, temp)
#     gender$friends_scrapped[i] <- TRUE
#     
#     rm(temp)
#     rm(number_of_friends_return)
#   }
# }


# 4. Make combined list of the followers within the community
# The data frame graph_edges will only contain relationships between accounts in the corpus
graph_edges <- dplyr::filter(followers_all, user_id %in% gender$user_id)

# Filter out Duplicates
graph_edges <- unique(graph_edges)

# Rename the columns
names(graph_edges)<-c("Source","Target")

# Number of followers and friends within community for each account
gender$followers_community_count=0
gender$friends_community_count=0

for (i in 1:nrow(gender)) {
  gender$followers_community_count[i] <- sum(graph_edges$Target == gender$user_id[i])
  gender$friends_community_count[i] <- sum(graph_edges$Source == gender$user_id[i], na.rm = TRUE)
}

# Nodes: Create from gender data frame, filter and prepare for export
graph_nodes <- gender[which(!gender$del_or_protected & gender$followers_community_count > 1), ]
graph_nodes <- graph_nodes[,c(2,4,1,3:ncol(graph_nodes))]

names(graph_nodes)[1] <- "Id"
names(graph_nodes)[2] <- "Label"

# 4. Export Nodes and Edges
# Importing into Gephi has its pitfalls, for problems check out the ressource above, although wether the file encoding is the right one for you
write.csv(graph_edges, file="./data/histag_graph_edges.csv", row.names = FALSE, na = "", fileEncoding = "UTF-16LE")
write.csv(graph_nodes, file="./data/histag_graph_nodes.csv", row.names = F, na = "", fileEncoding = "UTF-16LE")

# Export graph_edges
# Note: This csv contains all follower relations and will be (in this case) around 150 mb
write_as_csv(followers_all, "./data/followers_all.csv", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")
# rm(followers_all)

# Figures 17-20: The accounts where filtered based on the variables user_hashtags or text
