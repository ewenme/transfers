# install CRAN packages if missing
list.of.packages <- c("rvest", "dplyr", "purrr", "janitor", "tidyr", "forcats",
                      "readr", "stringr", "ggplot2", "ggalt", "devtools")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# install github packages if missing
if (!require("lato")) devtools::install_github("briandconnelly/lato") 