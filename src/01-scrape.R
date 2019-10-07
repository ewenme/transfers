
# setup -------------------------------------------------------------------

# load packages / local functions
source("./src/00-setup.R")

# seasons to scrape
seasons <- 2019

# scrape ---------------------------------------------------

# epl transfers
epl_transfers <- map_dfr(
  seasons, scrape_season_transfers,
  league_name = "premier-league", league_id = "GB1"
  )

# eng championship transfers
championship_transfers <- map_dfr(
  seasons, scrape_season_transfers, 
  league_name = "championship", league_id = "GB2"
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

# create directory tree
fs::dir_create(path = file.path("data", seasons))

# export data function
export_data <- function(data, filename) {
  
  data <- split(data, data$year)
  
  invisible(
    lapply(names(data), 
           function(x) {
             write_csv(data[[x]], path = glue("data/{x}/{filename}.csv"))
           } 
           )
  )
}

# export data
export_data(epl_transfers, filename = "english_premier_league")
export_data(laliga_transfers, filename = "spanish_primera_division")
export_data(bundes_transfers, filename = "german_bundesliga_1")
export_data(seriea_transfers, filename = "italian_serie_a")
export_data(ligue1_transfers, filename = "french_ligue_1")
export_data(championship_transfers, filename = "english_championship")
export_data(liga_nos_transfers, filename = "portugese_liga_nos")
export_data(eredivisie_transfers, filename = "dutch_eredivisie")
export_data(premier_liga_transfers, filename = "russian_premier_liga")
