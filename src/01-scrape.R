
# setup -------------------------------------------------------------------

# load packages / local functions
source("./src/00-setup.R")

# seasons to scrape
seasons <- 1992:2018

# scrape ---------------------------------------------------

# epl transfers
epl_transfers <- map_dfr(
  seasons, scrape_season_transfers,
  league_name = "premier-league", league_id = "GB1"
  )

# la liga transfers
laliga_transfers <- map_dfr(
  seasons, scrape_season_transfers, 
  league_name = "primera-division", league_id = "ES1"
  )

# bundes transfers
bundes_transfers <- map_dfr(
  seasons, scrape_season_transfers, 
  league_name = "1-bundesliga", league_id = "L1"
  )

# serie a transfers
seriea_transfers <- map_dfr(
  seasons, scrape_season_transfers, 
  league_name = "serie-a", league_id = "IT1"
  )

# ligue 1 transfers
ligue1_transfers <- map_dfr(
  seasons, scrape_season_transfers, 
  league_name = "ligue-1", league_id = "FR1"
  )

# eng championship transfers
championship_transfers <- map_dfr(
  seasons, scrape_season_transfers, 
  league_name = "championship", league_id = "GB2"
)

# prt liga nos transfers
liga_nos_transfers <- map_dfr(
  seasons, scrape_season_transfers, 
  league_name = "liga-nos", league_id = "PO1"
)

# eredivisie transfers
eredivisie_transfers <- map_dfr(
  seasons, scrape_season_transfers, 
  league_name = "eredivisie", league_id = "NL1"
)

# russian premier liga transfers
premier_liga_transfers <- map_dfr(
  seasons, scrape_season_transfers, 
  league_name = "premier-liga", league_id = "RU1"
)

# export ------------------------------------------------------------------

write_csv(epl_transfers, path = file.path(".", "data", "english-premier-league-transfers.csv"))
write_csv(laliga_transfers, path = file.path(".", "data", "spanish-primera-division-transfers.csv"))
write_csv(bundes_transfers, path = file.path(".", "data", "german-bundesliga-transfers.csv"))
write_csv(seriea_transfers, path = file.path(".", "data", "italian-serie-a-transfers.csv"))
write_csv(ligue1_transfers, path = file.path(".", "data", "french-ligue-1-transfers.csv"))
write_csv(championship_transfers, path = file.path(".", "data", "english-championship-transfers.csv"))
write_csv(liga_nos_transfers, path = file.path(".", "data", "portugese-liga-nos-transfers.csv"))
write_csv(eredivisie_transfers, path = file.path(".", "data", "dutch-eredivisie-transfers.csv"))
write_csv(premier_liga_transfers, path = file.path(".", "data", "russian-premier-liga-transfers.csv"))
