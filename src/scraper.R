
# setup -------------------------------------------------------------------

# load packages / local functions
source("src/packages.R")
source("src/functions.R")

# get league metadata
league_meta <- read_csv("config/league-meta.csv")

# seasons to scrape
seasons <- 2021

# scrape ---------------------------------------------------

transfers <- map2(
  league_meta$league_name, league_meta$league_id,
  ~ map_dfr(seasons, scrape_season_transfers, 
            league_name = .x, league_id = .y)
  )

# export ---------------------------------------------------

# create directory tree
fs::dir_create(path = file.path("data", seasons))

# export data
map2(transfers, league_meta$file_name, export_data)
