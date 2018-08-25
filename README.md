European football league transfers
================

Overview
--------

Data on football clubs' player transfers, across all major European leagues recorded on [Transfermarkt](https://www.transfermarkt.co.uk/).

Currently, transfer data runs through the 2000/01 to 2018/19 seasons (latter is the summer window only), and includes the following leagues:

- English Premier League
- English Championship
- French Ligue 1
- German 1.Bundesliga
- Italian Serie A
- Portugese Primeira Liga
- Russian Primera Liga
- Spanish La Liga


Data
----

Transfer-level data in .csv format, found in `/data`. 

Codebook:

-   `club` (club)
-   `name` (player name
-   `age` (age at time of scrape)
-   `position` (player position)
-   `club_involved` (other club involved in transfer)
-   `transfer_movement` (transfer in/out)
-   `fee_cleaned` (transformed `fee` variable)
-   `league` (league)
-   `year` (year)

Code
----

All source code found in `/src`.

Usage
-----

<img src="./figures/chelsea-transfers-web.png" width="471" />

<img src="./figures/premier-league-transfer-spend-2018-web.png" width="471" />

Sources
-------

All squad data was scraped from [Transfermarkt](https://www.transfermarkt.co.uk/), in accordance with their [terms of use](https://www.transfermarkt.co.uk/intern/anb).