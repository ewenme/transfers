# load packages / local functions
library(rvest)
library(dplyr)
library(purrr)
library(janitor)
library(readr)
library(stringr)
library(glue)
library(httr)

source("src/functions.R")

# seasons to scrape
seasons <- 1992:2022

# get league metadata
league_meta <- read_csv("config/league-meta-expanded.csv")

# get data
transfers <- pmap(
  list(league_meta$league_name, league_meta$league_id, league_meta$country),
  ~ map_dfr(seasons, get_transfers_history, 
            league_name = ..1, league_id = ..2, country=..3)
  )

# export data
map2(transfers, league_meta$league_name, ~{
  fs::dir_create(path = "data")
  write_csv(.x, path = glue("data/{.y}.csv"))
})
