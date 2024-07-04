# Med School Stats Webscraping
Webscraping scripts for medical school admissions stats from [admit.org](https://admit.org/school-list-builder), a website/model built by reddit user Happiest_Rabbit and more thoroughly explained in [this post](https://www.reddit.com/r/premed/comments/1ap5ic5/admit_standardized_score_and_school_list_builder/). The purpose of these scripts is to be able to more easily maniplate the data about [accepted student statistics](https://admit.org/school-statistics) and [medical school curriculums](https://admit.org/school-curriculums).

## 7/4/24 edit
I recently also added the code required to scrape [this document](https://docs.google.com/spreadsheets/d/1tYAHFUP-X_Rj-nR1AerAMr5V5blIUV4_gkJ7p2COchk/edit?gid=514048617#gid=514048617) as well. It contains more detailed information about out-of-state and in-state acceptance rates.

## Quirks
There are 193 schools listed on admit.org, but when I scrape the tables from the web the resulting dataframes only have 191 rows/schools. I have no idea why, and I'm not CS person so someone else can figure it out bc I'm too lazy to.
