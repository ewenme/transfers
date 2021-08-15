# extract transfers data from page
extract_transfers <- function(page, window) {
  
  # isolate leagues club names
  clubs <- page %>% 
    html_elements(".table-header") %>%
    html_text2() 
  clubs <- clubs[4:length(clubs)-1]
  
  # get leagues transfers
  transfers <- html_table(
    page, ".responsive-table", 
    header = TRUE, fill = TRUE, trim = TRUE
    )
  
  # return elements with expected transfer table form
  cond <- sapply(transfers, function(x) length(x) == 9)
  transfers <- transfers[cond]
  
  # get player names (which get botched in the table above)
  player_names <- page %>% 
    html_elements(".responsive-table .di.nowrap .hide-for-small a") %>%
    html_attr("title")

  clubs_tidy <- rep(clubs, each = 2)
  
  # create tidy transfers data frame
  transfers_tidy <- map_dfr(seq_along(transfers), function(x) {
    
    data <- transfers[[x]]
    
    # clean column names
    data <- clean_names(data)
    
    # assign transfer type
    data$transfer_movement <- case_when(
      "in" %in% colnames(data) ~ "in",
      "out" %in% colnames(data) ~ "out"
    )
    
    # deal with buy/sell data structure differences
    if ("in" %in% colnames(data)) {
      
      data <- rename(data, player_name='in', 
                     club_involved_name=left_2)
      
      data$club_name <- clubs_tidy[[x]]
      data$left <- NULL
      
    } else if ("out" %in% colnames(data)) {
      
      data <- rename(data, player_name='out', 
                     club_involved_name=joined_2)
      
      data$club_name <- clubs_tidy[[x]]
      data$joined <- NULL
      
    }
    
    # select columns to keep
    data <- data[, c("club_name", "player_name", "age", "position", 
                     "club_involved_name", "fee", "transfer_movement")]
    
    # make age numeric
    data$age <- suppressWarnings(as.numeric(data$age))
    
    data
    
  })
  
  transfers_tidy <- transfers_tidy %>% 
    # remove whitespace from chr vars
    mutate_if(is.character, str_trim) %>% 
    # remove clubs w/ no moves
    dplyr::filter(!club_name %in% c("No departures", "No arrivals", "No new arrivals"),
           !player_name %in% c("No departures", "No arrivals", "No new arrivals"))
  
  # remove duplicate player name thing
  if (nrow(transfers_tidy) == 0) return(NULL)
    
  transfers_tidy$player_name <- player_names
  transfers_tidy$transfer_period <- window
  
  return(transfers_tidy)
  
}

# scrape a league seasons transfers
scrape_season_transfers <- function(league_id, league_name, season_id) {
  
  summer_transfers_url <- glue(
    "https://www.transfermarkt.co.uk/{league_name}/transfers/wettbewerb/{league_id}/plus/?saison_id={season_id}&s_w=s"
    )
  winter_transfers_url <- glue(
    "https://www.transfermarkt.co.uk/{league_name}/transfers/wettbewerb/{league_id}/plus/?saison_id={season_id}&s_w=w"
  )
  
  # read page
  summer_transfers_page <- read_html(summer_transfers_url)
  winter_transfers_page <- read_html(winter_transfers_url)
  
  # get transfers data
  summer_transfers <- extract_transfers(summer_transfers_page, window = "Summer")
  winter_transfers <- extract_transfers(winter_transfers_page, window = "Winter")
  
  # merge 
  transfers <- bind_rows(summer_transfers, winter_transfers)
  
  # deal with fees
  transfers_tidy <- mutate(transfers, fee_cleaned = case_when(
    str_sub(fee, -1, -1) == "m" ~ suppressWarnings(as.numeric(str_extract(fee, "\\d+\\.*\\d*"))),
    str_sub(fee, -1, -1) == "k" ~ suppressWarnings(as.numeric(str_extract(fee, "\\d+\\.*\\d*")))/1000,
    str_sub(fee, -3, -1) == "Th." ~ suppressWarnings(as.numeric(str_extract(fee, "\\d+\\.*\\d*")))/1000,
    str_detect(fee, "End of loan") ~ 0,
    fee == "Loan" ~ 0,
    fee %in% c("Free Transfer", "Free transfer") ~ 0,
    fee == "-" ~ 0
  ))
  
  # make club an ordered factor, remove whitespace
  transfers_tidy$club_name <- as_factor(str_trim(transfers_tidy$club_name))
  
  # add league
  transfers_tidy$league_name <- str_replace_all(
    str_to_title(league_name), pattern = "-", replacement = " "
    )
  
  # add transfer year
  transfers_tidy$year <- season_id
  
  # add transfer season
  transfers_tidy$season <- paste0(transfers_tidy$year, "/", transfers_tidy$year + 1)
  
  # pretend to be human
  Sys.sleep(1.5)
  
  return(transfers_tidy)
  
}

# function to get league table
season_clubs <- function(league_name, league_id, season_id) {
  
  # scrape ------------------------------------------------------------------
  
  # set transfers url
  league_url <- glue('https://www.transfermarkt.co.uk/{league_name}/startseite/wettbewerb/{league_id}/plus/?saison_id={season_id}')
  
  # read page
  league_html <- read_html(league_url)
  
  # get leagues club names
  clubs <- league_html %>% 
    html_table(".responsive-table", header=TRUE, fill=TRUE)
  
  # get table into correct format
  clubs <- as.data.frame(clubs[4]) %>% 
    mutate(Club.1 = str_trim(Club.1)) %>% 
    filter(Club.1 != "") %>% 
    select(club=Club.1, alias=name) %>% 
    mutate(id = row_number())
  
  return(clubs)
  
}

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
