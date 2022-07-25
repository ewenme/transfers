# load packages / local functions
source("src/packages.R")
source("src/functions.R")

# seasons to scrape
seasons <- 1992:2021

# get league metadata
league_meta <- read_csv("config/league-meta.csv")

# get data
transfers <- map2(
  league_meta$league_name, league_meta$league_id,
  ~ map_dfr(seasons, scrape_season_transfers, 
            league_name = .x, league_id = .y)
  )

# export data
map2(transfers, league_meta$league_name, ~{
  fs::dir_create(path = "data")
  write_csv(.x, path = glue("data/{.y}.csv"))
})
