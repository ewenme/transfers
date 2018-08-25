
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

# historic la liga transfers
laliga_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                         league_name = "primera-division", league_id = "ES1")

# historic bundes transfers
bundes_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                            league_name = "1-bundesliga", league_id = "L1")

# historic serie a transfers
seriea_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                            league_name = "serie-a", league_id = "IT1")

# historic ligue 1 transfers
ligue1_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                            league_name = "ligue-1", league_id = "FR1")


# export ------------------------------------------------------------------

write_csv(epl_transfers, path = file.path(".", "data", "premier-league-transfers.csv"))
write_csv(laliga_transfers, path = file.path(".", "data", "primera-division-transfers.csv"))
write_csv(bundes_transfers, path = file.path(".", "data", "bundesliga-transfers.csv"))
write_csv(seriea_transfers, path = file.path(".", "data", "serie-a-transfers.csv"))
write_csv(ligue1_transfers, path = file.path(".", "data", "ligue-1-transfers.csv"))

rm(epl_transfers, laliga_transfers, bundes_transfers, seriea_transfers, ligue1_transfers)
