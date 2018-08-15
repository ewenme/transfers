
# setup -------------------------------------------------------------------

# scrape
source("./scr/01-scrape.R")

# load pkgs
library(purrr)
library(janitor)

clubs_tidy <- rep(clubs, each=2)


# tidy --------------------------------------------------------------------

transfers <- map_dfr(seq_along(transfers), function(x) {
  
  data <- transfers[[x]]
  
  # clean column names
  data <- clean_names(data)
  
  # mark transfer type
  data <- mutate(data, transfer_type = case_when(
    colnames(data[1]) == "in" ~ "Buy",
    colnames(data[1]) == "out" ~ "Sale")
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
           fee, transfer_type) %>% 
    mutate(age=as.numeric(age))
  
  data
  
})
