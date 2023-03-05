# load packages / local functions
library(rvest)
library(dplyr)
library(purrr)
library(janitor)
library(readr)
library(stringr)
library(glue)

# enable increased scrape timeout
library(httr)

source("src/functions.R")

# seasons to scrape
seasons <- 1992:2022

# get league metadata
league_meta <- read_csv("config/league-meta-expanded.csv")

# get data
transfers <- map2(
  league_meta$league_name, league_meta$league_id,
  ~ map_dfr(seasons, get_transfers_history, 
            league_name = .x, league_id = .y)
  )

# export data
map2(transfers, league_meta$league_name, ~{
  fs::dir_create(path = "data")
  write_csv(.x, path = glue("data/{.y}.csv"))
})
