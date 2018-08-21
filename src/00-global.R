
# dependencies ------------------------------------------------------------

# install CRAN packages if missing
list.of.packages <- c("rvest", "dplyr", "purrr", "janitor", "tidyr", "forcats",
                      "readr", "stringr", "ggplot2", "ggalt", "devtools")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# install github packages if missing
if (!require("lato")) devtools::install_github("briandconnelly/lato") 


# functions ---------------------------------------------------------------

# scrape a league seasons transfers
scrape_season_transfers <- function(league_name, league_id, season_id, export=FALSE) {
  
  # scrape ------------------------------------------------------------------
  
  # set transfers url
  transfers_url <- paste0('https://www.transfermarkt.co.uk/', league_name,
                          '/transfers/wettbewerb/', league_id, '/saison_id/', season_id)
  
  # read page
  transfers_html <- read_html(transfers_url)
  
  # get leagues club names
  clubs <- transfers_html %>% 
    html_nodes(".table-header") %>%
    html_text() %>% 
    .[2:length(.)]
  
  # get leagues transfers
  transfers <- transfers_html %>% 
    html_table(".responsive-table", header=TRUE, fill=TRUE)
  
  # return elements with expected transfer table form
  cond <- sapply(transfers, function(x) length(x) == 9)
  transfers <- transfers[cond]
  
  
  # tidy --------------------------------------------------------------------
  
  clubs_tidy <- rep(clubs, each=2)
  
  transfers <- map_dfr(seq_along(transfers), function(x) {
    
    data <- transfers[[x]]
    
    # clean column names
    data <- clean_names(data)
    
    # mark transfer type
    data <- mutate(data, transfer_movement = case_when(
      colnames(data[1]) == "in" ~ "in",
      colnames(data[1]) == "out" ~ "out")
    ) 
    
    # deal with buy/sell col differences
    if (colnames(data[1]) == "in" ) {
      
      data <- data %>% 
        rename(name='in', club_involved=left_2) %>%
        mutate(club = clubs_tidy[[x]]) %>% 
        select(-left)
      
    } else if (colnames(data[1]) == "out" ) {
      
      data <- data %>% 
        rename(name='out', club_involved=joined_2) %>% 
        mutate(club = clubs_tidy[[x]]) %>% 
        select(-joined)
      
    }
    
    # select columns to keep
    data <- data %>% 
      select(club, name, age, position, club_involved,
             fee, transfer_movement) %>% 
      mutate(age=suppressWarnings(as.numeric(age)))
    
    data
    
  })
  
  # clean -------------------------------------------------------------------
  
  transfers <- transfers %>% 
    # remove whitespace from chr vars
    mutate_if(is.character, str_trim) %>% 
    # remove clubs w/ no moves
    filter(!name %in% c("No departures", "No arrivals"))
  
  # deal with fees
  transfers <- mutate(transfers, fee_cleaned = case_when(
    str_sub(fee, -1, -1) == "m" ~ suppressWarnings(as.numeric(str_extract(fee, "\\d+\\.*\\d*"))),
    str_sub(fee, -1, -1) == "k" ~ suppressWarnings(as.numeric(str_extract(fee, "\\d+\\.*\\d*")))/1000,
    str_detect(fee, "End of loan") ~ 0,
    fee == "Loan" ~ 0,
    fee == "Free Transfer" ~ 0,
    fee == "-" ~ 0
  ))
  
  # make club an ordered factor, remove whitespace
  transfers$club <- as_factor(str_trim(transfers$club))
  
  # add league
  transfers$league <- league_name
  
  # add transfer season
  transfers$year <- season_id
  
  # export to csv
  if(export == TRUE) {
    write_csv(transfers, path = paste0("./data/", league_name, "-transfers-", season_id, ".csv"))
  }
  
  return(transfers)
  
}

# function to create transfer season summary
season_transfer_summary <- function(x) {
  
  # create summary fee table
  transfer_summary <- x %>% 
    group_by(club, league, year) %>% 
    summarise(spend_m = sum(fee_cleaned[transfer_movement == "in"], na.rm = TRUE),
              sales_m = sum(fee_cleaned[transfer_movement == "out"], na.rm = TRUE),
              net = sales_m - spend_m) %>% 
    ungroup()
  
  return(transfer_summary)
}
