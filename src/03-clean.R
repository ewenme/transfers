
# setup -------------------------------------------------------------------

# scrape/tidy
source("./src/02-tidy.R")

# load pkgs
library(tidyr)
library(forcats)
library(readr)
library(stringr)


# clean -------------------------------------------------------------------

transfers <- transfers %>% 
  # remove whitespace from chr vars
  mutate_if(is.character, str_trim) %>% 
  # remove clubs w/ no moves
  filter(name != "No departures") 

# deal with fees
transfers <- mutate(transfers, fee_cleaned = case_when(
  str_sub(fee, -1, -1) == "m" ~ as.numeric(str_extract(fee, "\\d+\\.*\\d*")),
  str_sub(fee, -1, -1) == "k" ~ as.numeric(str_extract(fee, "\\d+\\.*\\d*"))/1000,
  str_detect(fee, "End of loan") ~ 0,
  fee == "Loan" ~ 0,
  fee == "Free Transfer" ~ 0,
  fee == "-" ~ 0
))

# make club an ordered factor, remove unwanted patterns
transfers$club <- as_factor(str_trim(str_remove_all(transfers$club, pattern = "FC|AFC")))

# create summary fee table
transfer_summary <- transfers %>% 
  group_by(club) %>% 
  summarise(spend_m = sum(fee_cleaned[transfer_movement == "in"], na.rm = TRUE),
            sales_m = sum(fee_cleaned[transfer_movement == "out"], na.rm = TRUE),
            net = sales_m - spend_m)


write_csv(transfers, path = paste0("./data/", league_name, "-transfers-", season_id, ".csv"))
