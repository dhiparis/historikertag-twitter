# Historikertage Twitter Code
This repository contains the code to recreate the annotated figures, tables, statistics and visualisations of the project "Die twitternde Zunft. Historikertage auf Twitter (2012-2018)" by Mareike König and Paul Ramisch. The project is written in R.
The data report in German can be found on Zenodo: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6362301.svg)](https://doi.org/10.5281/zenodo.6362301)

# Table of Contents
1. Dehydrate Twitter Data & Create Data Tables
    1.1 Dehydrated Data
    1.2 Twitter Developer Account & Access
    1.3 Create histag_all & gender
    1.4 Issues: Deleted Tweets & API changes
4. Tables
3. Figures
4. Citation & License

# 1. Dehydrate Twitter Data & Create Data Tables
The most important piece of data for our paper is data frame containing all the 14207 tweets this paper is based on. Due legal reasons we cannot publicly provide this tweet data, instead we have the dehydrated tweet data, which contains the id (status_id) of each tweet and our annotations. With this you can use the Twitter API to rehydrate the data. To do so you need Twitter API access.
The code for this first step is in **historikertage_corpora.R**

## 1.1 Dehydrated Data
The datasheets contain the dehydrated and annotated tweet ids that were used for our study. With the Twitter API this can be used to hydrate and restore the whole corpus, apart from deleted tweets. There are two versions of the CSV file in **/data**, one with clean id values, the other where the id values are prepended with an “x”. This prevents certain tools from using scientific notation for the ids and breaking them, with the R library rtweet function read_twitter_csv() this is automatically resolved on import.

The files contain the following data:
* status_id: The Twitter status id of the tweet
* corpus_user_id: A corpus specific id for each user within the corpus (not the Twitter user id)
* hauptkategorie_1: Primary category
* hauptkategorie_2: Primary category 2
* Gender: Gender of the user/account
* Nebenkategorie: Secondary category

## 1.2 Twitter Developer Account & Access
In order to access the Twitter API a you need a free developer account with elevated or academic research level access (both free). The essential access only allows access to the newer Twitter API 2, while this code was written for the Twitter API v1.1.
If you don't want to only rehydrate the data, but also search in the historical Twitter data yourself you need and account with academic research, premium or enterprise access.

More information on getting the access here: https://developer.twitter.com/en/docs/twitter-api/getting-started/getting-access-to-the-twitter-api
Implementation in rtweet: https://docs.ropensci.org/rtweet/articles/auth.html
Youtube: Create Twitter Developer Account (German, at 10:33): https://youtu.be/zu9haE92hrI?t=634
Youtube: Create Twitter App and Token (German, at 37:59): https://youtu.be/zu9haE92hrI?t=2279

When you have created a Twitter app, add your credentials in **historikertage_corpora.R** on line 32:
    twitter_key <- "your_twitter_key"
    twitter_secret_key <- "your_twitter_secret_key"
    twitter_api_access_token <- "your_twitter_api_access_token"
    twitter_api_access_token_secret <- "your_twitter_api_access_token_secret"
    twitter_app <- "your_twitter_app_name"

## 1.3 Create histag_all & gender
After adding the credentials you can run the script which will create the data frame **histag_all** with all the tweets, and the data frame **gender**, with all the accounts in the corpus are created. These two data frame are the basis for the tables and figures in the report.
They are being exported to **data/histag_all.csv** and **data/gender.csv**

## 1.4 Issues: Deleted Tweets & API changes
There is one downside to the dehydrated data approach: the data is in constant change. Some Tweets are missing: Tweets that got deleted, tweets from accounts that are private and tweets from accounts that were deleted. Furthermore networks expanded, tweets were liked and retweetet. To adress this, our code was completly refactored and will document in comments were possible problems can lie.

A second issue are certain changes to the data and API. When preparing this code the API didn't return the variable with the number of replies, thus this can't be replicated (reply_count). Futhermore Twitter seems to have changed the variable to determine wether a Tweet contains a photo or a link (urls_expanded_url and media_type). While writing the paper we already came across these issues and cleaned the raw data for the links (see data/2_table-overview.r,  10.2), but it is an important reminder not to blindly trust the API data.

# 2. Tables
The code for the tables can be found in **/tables_code**. After the rehydration and the creation of **data/histag_all.csv** and **data/gender.csv** all but two R scripts run indepentently. They load the needed libraries (if they're installed) and data and to create the tables.
Only **18_table-account-historikertag-tweets.R** amd **19_table-account-VHDTweets-tweets.R** need the Twitter API token to be set as in **historikertage_corpora.R**. This is not needed if the script is running in the same RStudio workspace as historikertage_corpora.R.

The following scripts can be found in /tables_code
* 2_table-overview.R
* 3_table-community-composition.R
* 4_table-user-activity-1-9-90.R
* 5_table-mentions-orig-development.R
* 6_table-mentions-all-development.R
* 7_table-reply-development.R
* 8_table-reply-distribution-development.R
* 9_table-link-development.R
* 10_table-photo-development.R
* 11_table-tweet-date-distribution.R
* 13_table-tweet-category-distribution.R
* 14_table-gender-category.R
* 15_table-gender-likes.R
* 16_table-gender-retweets.R
* 17_table-deleted-tweets.R
* 18_table-account-historikertag-tweets.R
* 19_table-account-VHDTweets-tweets.R

The tables present in the folder /tables were created based on the scripts **/tables_code** with an API call in April 2022, unlike the tables in the paper and data report, which are based on original scrapping close to the *Historikertage* and an API call in December 2019, see the data report on Zenodo for more information on thus. These tables show, how the later API call has certain effects on the numbers, more about this is documented in each code file.

# 3. Figures
The code for the figures can be found in **/figures_code**. After the rehydration and the creation of **data/histag_all.csv** and **data/gender.csv** most R scripts run indepentently. They load the needed libraries (if they're installed) and data and to create the figures.

However the files **28_figure-tweet-distribution-account-historikertag.R** and **29_figure-tweet-distribution-vhdresolution.R** need the respective table script **18_table-account-historikertag-tweets.R** and **19_table-account-VHDTweets-tweets.R** to be executed before as those download and export the corresponding data.

For the network graphs the file **15-20_figure-graph.R** only downloads and creates the raw data to import into [Gephi](https://gephi.org/), downloading the corresponding data will take up to two days due to Twitter call limits. More about this is documented in the file itself.
The same apllies for figures that were exported from [Voyant tools](https://voyant-tools.org/): **21-26_figure-corpus-export-voyant.R** which only recreates raw data that needs to be further processed.

The following scripts can be found in /figures_code:
* 3_figure-number-of-accounts.R
* 4_figure-community-composition.R
* 5_figure-tweets-all-development.R
* 6_figure-tweets-orig-development.R
* 7_figure-retweets-development.R
* 8_figure-likes-development.R
* 9_figure-mentions-orig-development.R
* 10_figure-reply-development.R
* 11_figure-tweet-distribution-2012.R
* 12_figure-tweet-distribution-2014.R
* 13_figure-tweet-distribution-2016.R
* 14_figure-tweet-distribution-2018.R
* 15-20_figure-graph.R
* 21-26_figure-corpus-export-voyant.R
* 27_figure-categories-deleted-tweets.R
* 28_figure-tweet-distribution-account-historikertag.R
* 29_figure-tweet-distribution-vhdresolution.R

As with the tables, in the folder /figures you'll find figures that are based on an API call in April 2022:
![Number of accounts](/figures/3_figure-number-of-accounts.png)
![Community composition](/figures/4_figure-community-composition.png)
![Development of all tweet numbers](/figures/5_figure-tweets-all-development.png)
![Development of original tweet numbers](/figures/6_figure-tweets-orig-development.png)
![Development of retweet numbers](/figures/7_figure-retweets-development.png)
![Development of like numbers](/figures/8_figure-likes-development.png)
![Development of mentions in original tweets](/figures/9_figure-mentions-orig-development.png)
![Development of replies within the corpus](/figures/10_figure-reply-development.png)
![Tweet distribution during the conference 2012](/figures/11_figure-tweet-distribution-2012.png)
![Tweet distribution during the conference 2014](/figures/12_figure-tweet-distribution-2014.png)
![Tweet distribution during the conference 2016](/figures/13_figure-tweet-distribution-2016.png)
![Tweet distribution during the conference 2018](/figures/14_figure-tweet-distribution-2018.png)
![Distribution of categories among deleted tweets ](/figures/27_figure-categories-deleted-tweets.png)
![Tweet distribution of the @historikertag account  ](/figures/28_figure-tweet-distribution-account-historikertag.png)
![Distribution of tweets with the hashtag #vhdresolution](/figures/29_figure-tweet-distribution-vhdresolution.png)

# 4. Citation & License
König, Mareike, & Ramisch, Paul. (2022). Historikertage auf Twitter (2012-2018). Code und Datenset [Data set]. Github. https://github.com/dhiparis/historikertag-twitter

License: [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/legalcode)