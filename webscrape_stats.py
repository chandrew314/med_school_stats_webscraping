from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import bs4
import pandas as pd

URL = "https://admit.org/school-statistics"

def scrape_table(url):

    with webdriver.Firefox() as driver: # there are other drivers available
        driver = webdriver.Firefox()
        driver.get(url)

        # I don't think this does anything but I'm too scared to delete it
        timeout = 100000
        wait = WebDriverWait(driver, timeout)
        wait
    
    school_statistics_list = []

    # Extract and print initial data
    initial_html = driver.page_source
    initial_soup = bs4.BeautifulSoup(initial_html, 'lxml')
    initial_table = initial_soup.find_all('table')[0]
    school_statistics_list.extend(extract_and_print_table(initial_table))


    # Simulate scroll events to load additional content
    for scroll_count in range(200):  # Assuming there are 10 scroll events in total; total table pixel height is 9932px
       
       # Scroll down using JavaScript
        driver.execute_script("window.scrollBy(0, 52);")

        # Wait for the dynamically loaded content to appear
        WebDriverWait(driver, 1000).until(
            EC.presence_of_element_located((By.CLASS_NAME, "styles_table__9Xg05"))
        )

        # Extract and print the newly loaded quotes
        scroll_html = driver.page_source
        scroll_soup = bs4.BeautifulSoup(scroll_html, 'lxml')
        scroll_table = scroll_soup.find_all('table')[0]
        school_statistics_list.extend(extract_and_print_table(scroll_table))

    school_statistics_df = pd.DataFrame(school_statistics_list).drop_duplicates()
    print(school_statistics_df)

    school_statistics_df.to_csv('admit_org_stats.csv', encoding='utf-8', index = False)
    
    # Close the WebDriver
    driver.quit()

def extract_and_print_table(table):
    rows = table.find_all('tr')
    print(len(rows))

    rows_list = []

    for row in rows[1:]:
        cells = row.find_all('td')
        Rank = cells[0].text.strip()
        School = cells[1].text.strip()
        Applications = cells[2].text.strip()
        Interviews = cells[3].get_text(separator = '.').strip().split('.')[0]
        Percent_interviewed = cells[3].get_text(separator = '.').strip().split('.')[1]
        Admits = cells[4].get_text(separator = '.').strip().split('.')[0]
        Percent_admitted_post_ii = cells[4].get_text(separator = '.').strip().split('.')[1]
        MCAT = cells[5].text.strip()
        GPA = cells[6].text.strip()
        school_stats_dict = {'Rank': Rank, 'School': School, 'Applications': Applications, 'Interviews': Interviews, 'Percent_interviewed': Percent_interviewed, 'Admits': Admits, 'Percent_admitted_post_II': Percent_admitted_post_ii, 'MCAT': MCAT, 'GPA': GPA}
        rows_list.append(school_stats_dict)
    
    return(rows_list)

if __name__ == "__main__":
   URL = "https://admit.org/school-statistics"
   scrape_table(URL)
