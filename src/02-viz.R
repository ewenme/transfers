
# setup -------------------------------------------------------------------

# install packages if missing and load local functions
source("./src/00-global.R")

# load pkgs
library(ggplot2)
library(ggalt)
library(lato)
library(svglite)

# get data
transfers <- read_csv(file = file.path("./data/", "premier-league-transfers.csv"))


# visualise EPL 2018/19 transfers ---------------------------------------------------------------

# seasons data
epl_transfers_2018 <- filter(transfers, year == 2018)

# make club an ordered factor, remove whitespace
epl_transfers_2018$club <- as_factor(epl_transfers_2018$club)

# summarise data
epl_2018_summary <- season_transfer_summary(epl_transfers_2018)

svglite(file = paste0("./figures/", league_name, "-transfer-spend-", season_id, "-raw.svg"),
        width = 8, height = 10)

ggplot(data = epl_2018_summary, 
       aes(y = fct_rev(club), x = spend_m, xend = sales_m)) +
  # add zero line
  geom_vline(xintercept = 0, size = 0.5) +
  # add league position reference lines
  # add dumbells
  geom_dumbbell(size=2, size_x = 3, size_xend = 3,
                color="#e3e2e1", colour_x = "#853438", colour_xend = "#EACF9E") +
  # legend annotations
  geom_text(data = filter(epl_2018_summary, club == "Manchester City"), 
            aes(x=spend_m, y=club, label="Spend"),
            size=3, hjust=-.25, fontface="bold", colour = "#853438") + 
  geom_text(data=filter(epl_2018_summary, club == "Manchester City"), 
            aes(x=sales_m, y=club, label="Sales"),
            size=3, hjust=1.25, fontface="bold", colour="#EACF9E") +
  # titling
  labs(title = "Stories from the summer 2018 Premier League transfer window",
       subtitle="Transfer fees spent and raised by Premier League clubs from the\nsummer 2018 transfer window (so far). Clubs ordered by final league position in the 2017/18 season.",
       x="£ millions", y=NULL, 
       caption="Source: Transfermarkt   |   @ewen_") + 
  # theme
  theme_lato(grid.minor = FALSE, grid.y = FALSE) +
  theme(plot.margin = unit(c(0.35, 0.35, 0.3, 0.35), "cm"),
        axis.text.y.left = element_text(margin = margin(0, 5, 0, 0)),
        plot.title = element_text(hjust = 1, size = 16), 
        plot.subtitle = element_text(hjust = 1, size = 14)) +
  # scales
  scale_x_continuous(expand = c(0, 0), limits = c(0, 175), breaks = seq(0, 175, 25)) +
  coord_cartesian(clip = "off")

dev.off()
