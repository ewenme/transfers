
# setup -------------------------------------------------------------------

# install packages if missing and load local functions
source("./src/00-global.R")

library(rvest)
library(dplyr)
library(tidyr)
library(forcats)
library(readr)
library(stringr)
library(purrr)
library(janitor)


# scrape / export ---------------------------------------------------

scrape_season_transfers(league_name = "premier-league", league_id = "GB1",
                        season_id = 2018, export = TRUE)
