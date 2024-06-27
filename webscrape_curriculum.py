from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import bs4
import pandas as pd

URL = "https://admit.org/school-curriculums"

def scrape_table(url):

    with webdriver.Firefox() as driver: # there are other drivers available
        driver = webdriver.Firefox()
        driver.get(url)
        
        # I don't think this does anything but I'm too scared to delete it
        timeout = 100000
        wait = WebDriverWait(driver, timeout)
        wait
    
    school_curriculum_list = []

    # Extract and print initial data
    initial_html = driver.page_source
    initial_soup = bs4.BeautifulSoup(initial_html, 'lxml')
    initial_table = initial_soup.find_all('table')[0]
    school_curriculum_list.extend(extract_and_print_table(initial_table))


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
        school_curriculum_list.extend(extract_and_print_table(scroll_table))

    school_curriculum_df = pd.DataFrame(school_curriculum_list).drop_duplicates()
    print(school_curriculum_df)

    # Save to excel
    school_curriculum_df.to_csv('admit_org_curriculum.csv', encoding='utf-8', index = False)
    
    # Close the WebDriver
    driver.quit()

def extract_and_print_table(table):
    rows = table.find_all('tr')
    print(len(rows))

    rows_list = []

    for row in rows[1:]:
        cells = row.find_all('td')
        School = cells[0].text.strip()
        AOA = cells[1].text.strip()
        AOA_before_match = cells[2].text.strip()
        Internal_rank = cells[3].text.strip()
        PC_grades = cells[4].text.strip()
        PC_length = cells[5].text.strip()
        Clerkship_grades = cells[6].text.strip()
        NBME_or_in_house = cells[7].text.strip()
        MSPE_adj = cells[8].text.strip()
        Lecture_attendance = cells[9].text.strip()
        Home_hospital = cells[10].text.strip()
        school_curriculum_dict = {'School': School, 'AOA': AOA, 'AOA_before_match': AOA_before_match, 'Internal_rank': Internal_rank, 'PC_grades': PC_grades, 'PC_length': PC_length, 'Clerkship_grades': Clerkship_grades, 'NBME_or_in_house': NBME_or_in_house, 'MSPE_adj': MSPE_adj, 'Lecture_attendance': Lecture_attendance, 'Home_hospital': Home_hospital}
        rows_list.append(school_curriculum_dict)
    
    return(rows_list)

if __name__ == "__main__":
   URL = "https://admit.org/school-curriculums"
   scrape_table(URL)
