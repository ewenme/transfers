
# setup -------------------------------------------------------------------

library(rvest)
library(dplyr)

# set parameters
league_name = "premier-league"
league_id = "GB1"
season_id = 2018

# set transfers url
transfers_url <- paste0('https://www.transfermarkt.co.uk/', league_name,
                        '/transfers/wettbewerb/', league_id, '/saison_id/', season_id)

# read page
transfers_html <- read_html(transfers_url)


# scrape ---------------------------------------------------

# get leagues club names
clubs <- transfers_html %>% 
  html_nodes(".table-header") %>%
  html_text() %>% 
  .[2:length(.)]

# get leagues transfers
transfers <- transfers_html %>% 
  html_table(".responsive-table", header=TRUE, fill=TRUE)

# return elements with expected transfer table form
cond <- sapply(transfers, function(x) length(x) == 9)
transfers <- transfers[cond]

rm(cond, transfers_url, league_name, league_id, season_id)
