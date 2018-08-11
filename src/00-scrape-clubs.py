# librarys
import requests
from bs4 import BeautifulSoup
soup = BeautifulSoup(page.content, 'html.parser')
import pandas as pd

# request page
page = requests.get("https://www.transfermarkt.com/premier-league/startseite/wettbewerb/GB1/saison_id/2018", headers={'User-Agent': 'Custom'})

# get club table object
table = soup.find(class_="grid-view", id="yw1")

# get table body
table_body = table.find('tbody')

# build table data
data = []

rows = table_body.find_all('tr')
for row in rows:
    cols = row.find_all('td')
    cols = [ele.text.strip() for ele in cols]
    data.append([ele for ele in cols if ele]) 

# convert to dataframe
data = pd.DataFrame(data)
data = data[data.columns[0:6]] 
data.columns = ['club', 'club_abr', 'squad', 'age', 'foreign_players', 'total_mkt_value']

