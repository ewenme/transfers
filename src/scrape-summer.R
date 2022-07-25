# load packages / local functions
library(rvest)
library(dplyr)
library(purrr)
library(janitor)
library(readr)
library(stringr)
library(glue)

source("src/functions.R")

# seasons to scrape
season <- as.numeric(format(Sys.Date(), "%Y"))

# get league metadata
league_meta <- read_csv("config/league-meta.csv")

# get data
transfers <- map2(
  league_meta$league_id, league_meta$league_name,
  ~ get_transfers_summer(
    league_id = .x, league_name = .y, season_id = season
  )
)

# export data
map2(
  transfers, league_meta$league_name, ~{
    fs::dir_create(path = "data")
    write_csv(.x, path = glue("data/{.y}.csv"), append = TRUE)
    }
  )