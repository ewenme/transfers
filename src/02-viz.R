
# setup -------------------------------------------------------------------

# install packages if missing and load local functions
source("./src/00-global.R")

# load pkgs
library(readr)
library(dplyr)
library(ggplot2)
library(ggalt)
library(gghighlight)
library(ggrepel)
library(lato)
library(svglite)
library(scico)
library(scales)
library(stringr)

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


# top six historic transfers ----------------------------------------------

# get transfers since 2010/11
top_six_transfers <- filter(transfers, year >= 2010,
                            club %in% c("Arsenal FC", "Chelsea FC", "Manchester United",
                                        "Manchester City", "Tottenham Hotspur", "Liverpool FC"))

# season by club summary
top_six_transfer_summary <- season_transfer_summary(top_six_transfers) %>% 
  # add proportional metrics
  group_by(year) %>% 
  mutate(spend_prop = spend_m / sum(spend_m),
         sales_prop = sales_m / sum(sales_m)) %>% ungroup()

# remove unnecessary suffixes
top_six_transfer_summary$club <- str_remove_all(top_six_transfer_summary$club, pattern = "FC|Hotspur")

# create season id
top_six_transfer_summary$season <- str_remove_all(paste0(top_six_transfer_summary$year, "/",
                                          top_six_transfer_summary$year+1), "20")
  
# fix percent format
pct_format <- percent_format(1)

# chart connected scatter
ggplot(aes(x = spend_prop, y = sales_prop, colour = year), data = top_six_transfer_summary) +
  # point / path layers
  geom_point(size = 2.5, alpha = 0.7) +
  geom_path(size = 0.75) +
  # reference lines
  geom_hline(yintercept = 1/6, linetype = "dotted", colour = "grey30") +
  geom_vline(xintercept = 1/6, linetype = "dotted", colour = "grey30") +
  # add year labels
  geom_text_repel(aes(label = season), family = "Lato Semibold") +
  # small multiples
  facet_wrap( ~ club, scales = "fixed") +
  # labels
  labs(title = "Charting the course of top-six transfer activity",
       subtitle = "Seasons 2010/11 - 18/19 (N.B. 2018/19 season includes summer window activity)",
       x = "% of season's league transfer spend £", y = "% of season's league transfer sales £") +
  # scales
  scale_y_continuous(limits = c(0, 0.6), breaks = seq(0, 0.6, 0.1),
                     expand = expand_scale(mult = c(0, 0)), labels = pct_format) +
  scale_x_continuous(limits = c(0, 0.4), breaks = seq(0, 0.4, 0.1),
                     expand = expand_scale(mult = c(0, 0)), labels = pct_format) +
  # theme
  theme_lato(grid = FALSE) +
  guides(colour = FALSE) +
  # palette
  scale_colour_scico(palette = "turku", direction = -1)
