Premier League transfers
================

Overview
--------

Data on English Premier League (EPL) clubs' transfers, but source code can be easily adapted for other leagues' transfers recorded on [Transfermarkt](https://www.transfermarkt.co.uk/).

EPL seasons' transfer data:

- 2000/2001 to 2018/2019 (latter is the summer window only)

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

<img src="./figures/premier-league-transfer-spend-2018-web.png" width="471" />

Sources
-------

All squad data was scraped from [Transfermarkt](https://www.transfermarkt.co.uk/), in accordance with their [terms of use](https://www.transfermarkt.co.uk/intern/anb).