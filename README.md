Premier League transfers
================

Overview
--------

Data on English Premier League (EPL) clubs' transfers.

Windows:

-   Summer 2018

Data
----

Transfer-level data in .csv format (filenames follow a `<league_name>-<year>` naming convention).

-   `club` (club)
-   `name` (player name
-   `age` (age at time of scrape)
-   `position` (player position)
-   `club_involved` (other club involved in transfer)
-   `transfer_movement` (transfer in/out)
-   `fee_cleaned` (transformed `fee` variable)

Usage
-----

<img src="./figures/premier-league-transfer-spend-2018-web.png" width="471" />

Code
----

All source code contained in `src` folder.

Sources
-------

All squad data was scraped from [Transfermarkt](https://www.transfermarkt.co.uk/), in accordance with their [terms of use](https://www.transfermarkt.co.uk/intern/anb).