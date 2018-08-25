
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

# historic epl transfers
epl_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                         league_name = "premier-league", league_id = "GB1")

laliga_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                         league_name = "primera-division", league_id = "ES1")


# export ------------------------------------------------------------------

write_csv(epl_transfers, path = file.path(".", "data", "premier-league-transfers.csv"))
write_csv(laliga_transfers, path = file.path(".", "data", "primera-division-transfers.csv"))

rm(epl_transfers, laliga_transfers)
