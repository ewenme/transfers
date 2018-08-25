
# setup -------------------------------------------------------------------

# install packages if missing and load local functions
source("./src/00-global.R")

# load pkgs
library(readr)
library(dplyr)
library(stringr)
library(purrr)
library(ggplot2)
library(ggalt)
library(gghighlight)
library(ggrepel)
library(lato)
library(hrbrthemes)
library(scico)
library(scales)
library(gganimate)

# get data
epl_transfers <- read_csv(file = file.path("./data/", "english-premier-league-transfers.csv"))
laliga_transfers <- read_csv(file = file.path("./data/", "spanish-primera-division-transfers.csv"))

# get richlist data
richlist_club_leagues <- c("english-premier-league-transfers.csv", "spanish-primera-division-transfers.csv",
                          "german-bundesliga-transfers.csv", "italian-serie-a-transfers.csv")
richlist_transfers <- map_dfr(file.path("./data", richlist_club_leagues), read_csv)


# visualise EPL 2018/19 transfers ---------------------------------------------------------------

# seasons data
epl_transfers_2018 <- filter(epl_transfers, year == 2018)

# make club an ordered factor
epl_transfers_2018$club <- as_factor(epl_transfers_2018$club)

# summarise data
epl_2018_summary <- season_transfer_summary(epl_transfers_2018)

# visualise
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


# la liga 2018/19 transfers -----------------------------------------------

# seasons data
laliga_transfers_2018 <- filter(laliga_transfers, year == 2018)

# seasons clubs
laliga_clubs_2018 <- season_clubs(league_name = "laliga", league_id = "ES1", season_id = 2018)

# make club an ordered factor, remove whitespace
laliga_transfers_2018$club <- factor(laliga_transfers_2018$club, levels = laliga_clubs_2018$club)

# summarise data
laliga_transfers_2018_summary <- season_transfer_summary(laliga_transfers_2018)

# visualise
ggplot(data = laliga_transfers_2018_summary, 
       aes(y = fct_rev(club), x = spend_m, xend = sales_m)) +
  # add zero line
  geom_vline(xintercept = 0, size = 0.5) +
  # add dumbells
  geom_dumbbell(size=2, size_x = 3, size_xend = 3,
                color="#e3e2e1", colour_x = "#853438", colour_xend = "#EACF9E") +
  # legend annotations
  geom_text(data = filter(laliga_transfers_2018_summary, club == "FC Barcelona"), 
            aes(x=spend_m, y=club, label="Spend"),
            size=3, hjust=-.25, fontface="bold", colour = "#853438") + 
  geom_text(data=filter(laliga_transfers_2018_summary, club == "FC Barcelona"), 
            aes(x=sales_m, y=club, label="Sales"),
            size=3, hjust=1.25, fontface="bold", colour="#EACF9E") +
  # titling
  labs(title = "Stories from the summer 2018 La Liga transfer window",
       subtitle="Transfer fees spent and raised by La Liga clubs from the summer 2018 transfer window (so far).\nClubs ordered by final league position in the 2017/18 season.",
       x="£ millions", y=NULL, 
       caption="Source: Transfermarkt   |   @ewen_") + 
  # theme
  theme_lato(grid.minor = FALSE, grid.y = FALSE) +
  theme(plot.margin = unit(c(0.35, 0.35, 0.3, 0.35), "cm"),
        axis.text.y.left = element_text(margin = margin(0, 5, 0, 0)),
        plot.title = element_text(hjust = 0, size = 16), 
        plot.subtitle = element_text(hjust = 0, size = 14)) +
  # scales
  scale_x_continuous(expand = c(0, 0), limits = c(0, 175), breaks = seq(0, 175, 25)) +
  coord_cartesian(clip = "off")


# EPL top six historic transfers ----------------------------------------------

# get transfers since 2010/11
top_six_transfers <- filter(epl_transfers, year >= 2010,
                            club %in% c("Arsenal FC", "Chelsea FC", "Manchester United",
                                        "Manchester City", "Tottenham Hotspur", "Liverpool FC"))

# remove unnecessary suffixes
top_six_transfers$club <- str_trim(str_remove_all(top_six_transfers$club, pattern = "FC|Hotspur"))

# season by club summary
top_six_transfer_summary <- season_transfer_summary(top_six_transfers) %>% 
  # add proportional metrics
  group_by(year) %>% 
  mutate(spend_prop = spend_m / sum(spend_m),
         sales_prop = sales_m / sum(sales_m)) %>% ungroup()

# create season id
top_six_transfer_summary$season <- str_remove_all(paste0(top_six_transfer_summary$year, "/",
                                          top_six_transfer_summary$year+1), "20")

# create labels
top_six_transfer_summary <- mutate(top_six_transfer_summary, 
                                   season_label = case_when(
                                     club == "Chelsea" ~ season,
                                     year %in% c(2010, 2018) ~ season,
                                     TRUE ~ ""))

# connected scatter: one club
top_six_transfer_summary %>% 
  filter(club == "Chelsea") %>% 
  ggplot(aes(x = sales_m, y = spend_m, colour=year)) +
  # point / path layers
  geom_path(size = 0.75, linejoin = "mitre") +
  geom_point(fill = "white", size = 3, shape = 21, stroke = 1.5) +
  # add year labels
  geom_text_repel(aes(label = season_label), family = "IBMPlexSans-SemiBold", size = 5, segment.colour = NA) +
  # reference lines
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", colour = "grey70") +
  geom_abline(intercept = 0, slope = 0.5, linetype = "dashed", colour = "grey70") +
  geom_abline(intercept = 0, slope = 2, linetype = "dashed", colour = "grey70") +
  # labels
  labs(title = "Chelsea's transfer spend in the latest window (2018/19) was over double the value raised from sales - a deficit last exceeded in 2012/13\n",
       subtitle = "Charting the course of Chelsea's player transfer activity through the '10/11 - '18/19 seasons (N.B. '18/19 season includes summer window activity only). Circles represent a season's transfer business, demonstrating transfer sales (horizontal axis) vs transfer spend (vertical axis). Dashed reference lines help indicate whether a team was buying or selling more, that season.\n\n\n",
       x = "transfer sales (£millions)", y = "transfer spend (£millions)",
       caption="Source: Transfermarkt   |   @ewen_") +
  # scales
  scale_y_continuous(limits = c(0, 250), expand = c(0, 0)) +
  scale_x_continuous(limits = c(0, 200), expand = c(0, 0)) +
  # theme
  theme_ipsum_ps(grid = "xy", base_size = 14, axis_title_size = 14, caption_size = 14, axis_text_size = 14) +
  guides(colour = FALSE) +
  # palette
  scale_colour_scico(palette = "turku", direction = -1)

ggsave(filename = "./figures/chelsea-transfers-raw.svg", width = 10, height = 12, dpi = 320)
dev.off()

# cconnected scatter: top six
ggplot(aes(x = sales_m, y = spend_m, colour = year), data = top_six_transfer_summary) +
  # point / path layers
  geom_path(size = 0.75, linejoin = "mitre") +
  geom_point(fill = "white", size = 2, shape = 21, stroke = 1) +
  # add year labels
  geom_text_repel(aes(label = season_label), family = "IBMPlexSans-SemiBold", size = 4, segment.colour = NA) +
  # small multiples
  facet_wrap( ~ club, scales = "fixed") +
  # labels
  labs(title = "As a share of Top Six transfer spend, Liverpool's most recent window is second only to Manchester City in '10/11\n",
       subtitle = "Profiling shares of the traditional 'Top 6' clubs' transfer activity, charting the course of the '10/11 - '18/19 seasons (N.B. '18/19 season includes summer window activity only). Circles represent a season's transfer business, demonstrating transfer sales (horizontal axis) vs transfer spend (vertical axis).\n\n",
       x = "transfer sales (£millions)", y = "transfer spend (£millions)",
       caption="Source: Transfermarkt   |   @ewen_") +
  # scales
  scale_y_continuous(limits = c(0, 300)) +
  scale_x_continuous(limits = c(0, 200)) +
  # theme
  theme_ipsum_ps(grid = "xy", base_size = 14, axis_title_size = 14, caption_size = 14, axis_text_size = 14) +
  guides(colour = FALSE) +
  # palette
  scale_colour_scico(palette = "turku", direction = -1)

# ggsave(filename = "./figures/top-six-transfers-raw.svg", width = 10, height = 12, dpi = 320)
# dev.off()

# # animate idea - await transition_reveal
# top_six_transfer_summary %>% 
#   filter(club == "Chelsea") %>% 
#   ggplot(aes(x = sales_m, y = spend_m)) +
#   # point / path layers
#   geom_path(size = 0.75, linejoin = "mitre") +
#   # geom_point(fill = "white", size = 3, shape = 21, stroke = 1.5) +
#   transition_filter(1, 1)


# rich list history -------------------------------------------------------

richlist_clubs_transfers <- filter(richlist_transfers, 
                                   club %in% c("Arsenal FC", "Chelsea FC", "Manchester United",
                                               "Manchester City", "Tottenham Hotspur", "Liverpool FC",
                                               "FC Barcelona", "Real Madrid", "Bayern Munich", 
                                               "Juventus FC"))

# season by club summary
richlist_clubs_transfer_summary <- season_transfer_summary(richlist_clubs_transfers) %>% 
  # add proportional metrics
  group_by(year) %>% 
  mutate(spend_prop = spend_m / sum(spend_m),
         sales_prop = sales_m / sum(sales_m)) %>% ungroup()

ggplot(data = richlist_clubs_transfer_summary, aes(x=year, y=net, group = club)) +
  geom_line() +
  facet_wrap( ~ club, nrow = 2) +
  gghighlight(use_direct_label = FALSE) +
  scale_y_reverse() +
  theme_lato()
