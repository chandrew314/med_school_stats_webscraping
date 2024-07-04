from bs4 import BeautifulSoup
import csv
import requests
import os

html = requests.get('https://docs.google.com/spreadsheets/d/1tYAHFUP-X_Rj-nR1AerAMr5V5blIUV4_gkJ7p2COchk/edit?gid=514048617#gid=514048617').text

soup = BeautifulSoup(html, "lxml")
tables = soup.find_all("table")
index = 0
for table in tables:
    with open(str(index) + ".csv", "w") as f:
        wr = csv.writer(f, quoting = csv.QUOTE_NONNUMERIC)
        wr.writerows([[td.text for td in row.find_all("td")] for row in table.find_all("tr")])
    index = index + 1
os.rename('0.csv', '2021_med_school_post_ii_stats.csv')