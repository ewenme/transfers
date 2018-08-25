
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

# epl transfers
epl_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                         league_name = "premier-league", league_id = "GB1")

# la liga transfers
laliga_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                         league_name = "primera-division", league_id = "ES1")

# bundes transfers
bundes_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                            league_name = "1-bundesliga", league_id = "L1")

# serie a transfers
seriea_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                            league_name = "serie-a", league_id = "IT1")

# ligue 1 transfers
ligue1_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                            league_name = "ligue-1", league_id = "FR1")

# championship transfers
championship_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                            league_name = "championship", league_id = "GB2")

# russian premier liga transfers
russia_liga_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                                  league_name = "premier-liga", league_id = "RU1")

# portugal premier liga transfers
portugal_liga_transfers <- map_dfr(2000:2018, scrape_season_transfers, 
                                 league_name = "primeira-liga", league_id = "PO1")


# export ------------------------------------------------------------------

write_csv(epl_transfers, path = file.path(".", "data", "english-premier-league-transfers.csv"))
write_csv(laliga_transfers, path = file.path(".", "data", "spanish-primera-division-transfers.csv"))
write_csv(bundes_transfers, path = file.path(".", "data", "german-bundesliga-transfers.csv"))
write_csv(seriea_transfers, path = file.path(".", "data", "italian-serie-a-transfers.csv"))
write_csv(ligue1_transfers, path = file.path(".", "data", "french-ligue-1-transfers.csv"))
write_csv(championship_transfers, path = file.path(".", "data", "english-championship-transfers.csv"))
write_csv(russia_liga_transfers, path = file.path(".", "data", "russian-premier-liga-transfers.csv"))
write_csv(portugal_liga_transfers, path = file.path(".", "data", "portugal-primeira-liga-transfers.csv"))


rm(epl_transfers, laliga_transfers, bundes_transfers, seriea_transfers, ligue1_transfers, 
   championship_transfers, russia_liga_transfers, portugal_liga_transfers)
