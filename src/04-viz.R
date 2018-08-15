
# setup -------------------------------------------------------------------

# scrape/tidy/clean
source("./src/03-clean.R")

# load pkgs
library(ggplot2)
library(hrbrthemes)
library(ggalt)


# visualise ---------------------------------------------------------------

epl_transfers_plot <- ggplot(data = transfer_summary, 
       aes(y = fct_rev(club), x = spend_m, xend = sales_m)) +
  geom_dumbbell(size=2.5, color="#e3e2e1", colour_x = "#EACF9E", 
                colour_xend = "#602D31", dot_guide = TRUE, dot_guide_size=0.1) +
  theme_ipsum_ps(grid = "Xy") +
  labs(title = "Premier League transfer business",
       subtitle="Disclosed transfer fees in the summer 2018 transfer window",
       x="£ millions", y=NULL, 
       caption="Source: Transfermarkt   |   Made by @ewen_") + 
  theme(plot.margin = unit(c(0.35, 0.2, 0.3, 0.35), "cm"))

ggsave(plot = epl_transfers_plot, 
       filename = paste0(league_name, "-transfer-spend-", season_id),
       path = "./figures", device = "svg")
