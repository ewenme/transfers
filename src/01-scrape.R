
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

# scrape ---------------------------------------------------

epl_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                         league_name = "premier-league", league_id = "GB1")


# export ------------------------------------------------------------------

write_csv(epl_transfers, path = file.path(".", "data", "premier-league-transfers.csv"))

rm(epl_transfers)
