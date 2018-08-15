
# setup -------------------------------------------------------------------

# scrape
source("./scr/01-scrape.R")

# load pkgs
library(purrr)
library(janitor)


# tidy --------------------------------------------------------------------

map(transfers, function(x) {
  
  # clean column names
  x <- clean_names(x)
  
  # mark transfer type
  x <- mutate(x, transfer_type = case_when(
    colnames(x[1]) == "in" ~ "Buy",
    colnames(x[1]) == "out" ~ "Sale")
    ) 
  
  # deal with buy/sell col differences
  if (colnames(x[1]) == "in" ) {
    x <- x %>% 
      rename(name='in', club_involved=left_2) %>% 
      select(-left)
    
  } else if (colnames(x[1]) == "out" ) {
    x <- x %>% 
      rename(name='out', club_involved=joined_2) %>% 
      select(-joined)
  }
  
  # select columns to keep
  x <- select(x, name, age, position, club_involved,
              fee, transfer_type)
  
  x
  
})
