import pandas as pd
# import thefuzz as fuzz
# from thefuzz import process
# from thefuzz import fuzz

admit_df = pd.read_csv('admit_org_stats_curriculum.csv')
docs_df = pd.read_csv('2021_med_school_post_ii_stats.csv').dropna(axis = 1, how = 'all').dropna(axis = 0, how = 'all')

# admit_df['School'] = admit_df['School'].apply(
#   lambda x: process.extractOne(x, docs_df['School'], scorer = fuzz.partial_token_sort_ratio)[0]
# )

print(admit_df['School'].tolist().sort())
print(list(docs_df['School']).sort())

mapping_dict = {'Alabama COM': 'Alabama COM', 'Albany Medical College': 'Albany Medical College', 'Albert Einstein': 'Albert Einstein', 
                'Arkansas COM': 'Arkansas', 'ATSU (Kirksville)': 'ATSU (Kirksville)', 'ATSU (Mesa)': 'ATSU (Mesa)', 'Augusta University (MCG)': 'MCG Augusta', 
                'Baylor': 'Baylor', 'Boston University': 'Boston University', 'Brown University': 'Brown - Alpert', 'Buffalo (Jacobs)': 'Buffalo', 
                'Burrel COM': 'Burrel COM', 'California Northstate': 'California Northstate', 'California University': 'California University', 'Campbell University': 'Campbell University', 
                'Carle Illinois': 'Carle Illinois', 'Case Western Reserve': 'Case Western Reserve', 'CCOM': 'CCOM', 'Central Michigan': 'Central Michigan', 
                'CHSU COM': 'CHSU COM', 'Colorado': 'Colorado', 'Columbia University': 'Columbia', 'Cooper (Rowan)': 'Cooper', 
                'Creighton University': 'Creighton University', 'CUNY School of Medicine': 'CUNY School of Medicine', 'Dartmouth (Geisel)': 'Dartmouth (Geisel)', 'Des Moines University': 'Des Moines University', 
                'Drexel University': 'Drexel', 'Duke University': 'Duke', 'East Carolina University': 'East Carolina (Brody ECU)', 'East Tennessee State': 'East Tennessee', 
                'Eastern Virginia': 'Eastern Virginia Medical School (EVMS)', 'Emory University': 'Emory', 'Florida Atlantic University': 'FAU', 'Florida International University': 'Florida International University', 
                'Florida State University': 'Florida State University', 'Geisinger Commonwealth': 'Geisinger Commonwealth', 'George Washington': 'George Washington Univ', 
                'Georgetown University': 'Georgetown', 'Hackensack Meridian': 'Hackensack Meridian', 'Harvard Medical School': 'Harvard', 'Hofstra': 'Hofstra', 
                'Howard University': 'Howard University', 'Icahn at Mount Sinai': 'Icahn Mt. Sinai', 'Idaho COM': 'Idaho COM', 'Incarnate Word': 'Incarnate Word', 
                'Indiana University': 'Indiana', 'Jefferson (Kimmel)': 'Jefferson (Sidney Kimmel)', 'Johns Hopkins': 'Johns Hopkins', 'Kaiser Permanente (Tyson)': 'Kaiser Permanente (Tyson)', 
                'Kansas City Biosciences': 'Kansas City Biosciences', 'Kansas Health Science': 'Kansas Health Science', 'LECOM': 'LECOM', 'Lincoln Memorial University': 'Lincoln Memorial University', 
                'Loma Linda University': 'Loma Linda University', 'Loyola University (Stritch)': 'Loyola University (Stritch)', 'LSU (New Orleans)': 'LSU (New Orleans)', 'LSU (Shreveport)': 'LSU (Shreveport)', 
                'LUCOM': 'LUCOM', 'Marian University': 'Marian University', 'Marshall University': 'Marshall University', 'Mayo Clinic': 'Mayo (Alix)', 
                'McGovern (Houston)': 'McGovern Medical School at UT Houston', 'Medical College of Wisconsin': 'Medical College of Wisconsin', 'Medical University of South Carolina': 'Medical University of South Carolina', 'Meharry Medical College': 'Meharry Medical College', 
                'Mercer University': 'Mercer University', 'Michigan State COM': 'Michigan State COM', 'Michigan State University': 'Michigan State University', 'Missouri-Columbia': 'Missouri - Columbia', 
                'Missouri-Kansas': 'Missouri - Kansas City', 'Morehouse': 'Morehouse', 'New York Medical College': 'NYMC', 'Noorda COM': 'Noorda COM', 
                'Northeast Ohio': 'Northeast Ohio', 'Northwestern University': 'Northwestern Feinberg', 'Nova Southeastern (Patel)': 'Nova Southeastern (Patel)', 'NYIT-COM': 'NYIT-COM', 
                'NYU Grossman': 'NYU', 'NYU Long Island': 'NYU Long Island', 'Oakland University': 'Oakland University', 'Ohio State University': 'Ohio State', 
                'Ohio University (Heritage)': 'Ohio University (Heritage)', 'Oklahoma State University': 'Oklahoma State University', 'Oregon University': 'Oregon', 'Pacific Northwest': 'Pacific Northwest', 
                'PCOM': 'PCOM', 'Penn State University': 'Penn State University', 'Ponce Health Sciences': 'Ponce Health Sciences', 'Quinnipiac University': 'Frank H Netter Quinnipiac', 
                'Rocky Vista University': 'Rocky Vista University', 'Rosalind Franklin': 'Rosalind Franklin', 'Rowan COM': 'Rowan COM', 'Rush University': 'Rush', 
                'Rutgers (Robert Johnson)': 'Rutgers RWJMS', 'Rutgers New Jersey': 'Rutgers NJMS', 'Saint Louis University': 'Saint Louis University', 'San Juan Bautista': 'San Juan Bautista', 
                'SHSU COM': 'SHSU COM', 'South Carolina (Greenville)': 'U South Carolina', 'Southern Illinois University': 'Southern Illinois University', 'Stanford University': 'Stanford', 
                'Stony Brook University': 'Stony Brook', 'SUNY Downstate': 'SUNY Downstate', 'SUNY Upstate': 'SUNY Upstate', 'Temple University': 'Temple (LKSOM)', 
                'Texas A&M': 'Texas A&M', 'Texas Christian University': 'Texas Christian University', 'Texas Tech (El Paso)': 'Texas Tech (El Paso)', 'Texas Tech University': 'Texas Tech University', 
                'Touro COM': 'Touro COM', 'Touro University California': 'Touro University California', 'Tufts University': 'Tufts', 'Tulane University': 'Tulane University', 
                'UC Davis': 'UC Davis', 'UC Irvine': 'UC Irvine', 'UC Riverside': 'UC Riverside', 'UChicago (Pritzker)': 'University of Chicago Pritzker', 
                'UCLA': 'UCLA', 'UCSD': 'UC San Diego', 'UCSF': 'UC San Franscisco', 'UMass': 'Massachusetts', 
                'UNC': 'University of North Carolina', 'Uniformed Services': 'Uniformed Services', 'Universidad Central del Caribe': 'Universidad Central del Caribe', 'University of Alabama': 'Alabama - Birmingham', 
                'University of Arizona': 'Arizona- Tuscon', 'University of Arizona (Phoenix)': 'University of Arizona (Phoenix)', 'University of Arkansas': 'Arkansas', 'University of Central Florida': 'UCF (Central Florida)', 
                'University of Cincinnati': 'Cincinnati', 'University of Connecticut': 'University of Connecticut', 'University of Florida': 'University of Florida', 'University of Hawaii': 'Hawaii', 
                'University of Houston': 'University of Houston', 'University of Illinois': 'Illinois', 'University of Iowa': 'Iowa', 'University of Kansas': 'Kansas', 
                'University of Kentucky': 'Kentucky', 'University of Louisville': 'Louisville', 'University of Maryland': 'U Maryland', 'University of Miami': 'Miami', 
                'University of Michigan': 'Michigan', 'University of Minnesota': 'Minnesota', 'University of Mississippi': 'University of Mississippi', 'University of Nebraska': 'Nebraska', 
                'University of Nevada (Reno)': 'Nevada Reno', 'University of Nevada (Vegas)': 'University of Nevada (Vegas)', 'University of New England': 'University of New England', 'University of New Mexico': 'New Mexico', 
                'University of North Dakota': 'University of North Dakota', 'University of North Texas': 'University of North Texas', 'University of Oklahoma': 'Oklahoma', 'University of Pikeville': 'University of Pikeville', 
                'University of Pittsburgh': 'University of Pittsburgh', 'University of Puerto Rico': 'University of Puerto Rico', 'University of Rochester': 'Rochester', 'University of South Alabama': 'University of South Alabama', 
                'University of South Carolina': 'U South Carolina', 'University of Tennessee': 'University of Tennessee', 'University of Toledo': 'University of Toledo', 'University of Utah': 'Utah', 
                'University of Vermont': 'University of Vermont (Larner)', 'University of Virginia': 'University of Virginia', 'University of Washington': 'University of Washington', 'University of Wisconsin': 'Wisconsin', 
                'Unviersity of South Dakota': 'Unviersity of South Dakota', 'UPenn (Perelman)': 'University of Pennsylvania (Perelman)', 'USC (Keck)': 'USC - Keck', 'USF (Morsani)': 'USF Health Morsani College of Medicine', 
                'UT Austin (Dell)': 'UT Austin (Dell)', 'UT Medical Branch': 'UT Medical Branch', 'UT Rio Grande Valley': 'UT Rio Grande Valley', 'UT Tyler': 'UT Tyler', 
                'UTSW': 'UT Southwestern', 'Vanderbilt University': 'Vanderbilt', 'VCOM': 'VCOM', 'Virginia Commonwealth': 'Virginia Commonwealth University', 
                'Virginia Tech': 'Virginia Tech', 'Wake Forest': 'Wake Forest', 'Washington State (Floyd)':  'Washington State (Floyd)', 'WashU St. Louis': 'Wash U St. Louis', 
                'Wayne State University': 'Wayne State', 'WCU COM': 'WCU COM', 'Weill Cornell Medicine': 'Cornell (Weill)', 'West Virginia COM': 'West Virginia COM', 
                'West Virginia University': 'West Virginia University', 'Western Michigan': 'Western Michigan', 'Western University': 'Western University', 'Wright State University': 'Wright State University', 
                'Yale School of Medicine': 'Yale'}
## I think admi.org is missing UT San Antonio
# docs_school_list = ['Alabama - Birmingham', 'Albert Einstein', 'Arizona- Tuscon', 'Arkansas', 'Baylor', 'Boston University', 'Brown - Alpert', 'Buffalo', 'Case Western Reserve', 'Cincinnati', 'Colorado', 'Columbia', 'Cooper', 'Cornell (Weill)', 'Dartmouth (Geisel)', 'Drexel', 'Duke', 'East Carolina (Brody ECU)', 'East Tennessee', 'Eastern Virginia Medical School (EVMS)', 'Emory', 'FAU', 'Florida International University', 'Florida State University', 'Frank H Netter Quinnipiac', 'George Washington Univ', 'Georgetown', 'Harvard', 'Hawaii', 'Hofstra', 'Icahn Mt. Sinai', 'Illinois', 'Indiana', 'Iowa', 'Jefferson (Sidney Kimmel)', 'Johns Hopkins', 'Kansas', 'Kentucky', 'Louisville', 'Massachusetts', 'Mayo (Alix)', 'MCG Augusta', 'McGovern Medical School at UT Houston', 'Miami', 'Michigan', 'Minnesota', 'Missouri - Columbia', 'Missouri - Kansas City', 'Nebraska', 'Nevada Reno', 'New Mexico', 'Northwestern Feinberg', 'NYMC', 'NYU', 'Ohio State', 'Oklahoma', 'Oregon', 'Rochester', 'Rush', 'Rutgers NJMS', 'Rutgers RWJMS', 'Saint Louis University', 'Stanford', 'Stony Brook', 'SUNY Upstate', 'Temple (LKSOM)', 'Texas A&M', 'Tufts', 'U Connecticut', 'U Maryland', 'U South Carolina', 'UC Davis', 'UC Irvine', 'UC San Diego', 'UC San Franscisco', 'UCF (Central Florida)', 'UCLA', 'University of Chicago Pritzker', 'University of Florida', 'University of North Carolina', 'University of Pennsylvania (Perelman)', 'University of Pittsburgh', 'University of Vermont (Larner)', 'University of Virginia', 'University of Washington', 'USC - Keck', 'USF Health Morsani College of Medicine', 'UT San Antonio', 'UT Southwestern', 'Utah', 'Vanderbilt', 'Virginia Commonwealth University', 'Virginia Tech', 'Wake Forest', 'Wash U St. Louis', 'Wayne State', 'West Virginia University', 'Wisconsin', 'Yale']
# help = docs_df['School'].tolist()
# print(help)
# help.sort(key = str.lower)
# print(help)

admit_df['School_original'] = admit_df['School']
admit_df = admit_df.replace({'School': mapping_dict})

merge_df = pd.merge(admit_df, docs_df, how = 'left', on = ['School', 'School'])

merge_df.insert(3, 'USNWR Ranking Research', merge_df.pop('USNWR Ranking Research'))
merge_df.insert(4, 'USNWR Primary Care Ranking', merge_df.pop('USNWR Primary Care Ranking'))
merge_df.insert(1, 'School_original', merge_df.pop('School_original'))
merge_df['Rank'] = merge_df['Rank'].str[1:]
merge_df['Rank'] = merge_df['Rank'].astype(float)
merge_df = merge_df.sort_values('Rank')
merge_df = merge_df.drop(merge_df.columns[[0]], axis = 1)
merge_df = merge_df.drop(columns = ['School'])
merge_df = merge_df.rename(columns = {'School_original': 'School'})

## Calculate in-state vs out-of-state acceptance rates using docs data
merge_df['IS_A'] = (merge_df['IS Accepted'].astype(float) / merge_df['Apps IS'].astype(float)) * 100
merge_df['OOS_A'] = (merge_df['OOS Accepted'].astype(float) / merge_df['Apps OOS'].astype(float)) * 100
merge_df['IS_A/OOS_A'] = merge_df['IS_A'] / merge_df['OOS_A']

## discern public vs private and state more easily by parsing data in 'Public/Private' column
merge_df['State'] = merge_df['Public/Private'].str.extract(r'(?:\-|\_)(.*)', expand = False)
merge_df['State'] = merge_df['State'].str.strip()
merge_df['Public/Private'] = merge_df['Public/Private'].str.extract(r'(.*)(?:\-|\_)')
merge_df['Public/Private'] = merge_df['Public/Private'].str.strip()

## fix someone's mistake bc they put the location of UMich as Wisconsin smh
merge_df.loc[merge_df['School'] == 'University of Michigan', 'State'] = 'MI'

## standardize/add classification on if schools are OOS friendly
# print(merge_df['apply OOS to public state school?'].unique())
## i also take out the maybe schools and utah and label them as NA for prediction later
mapping_dict2 = {'YES': 'yes', 'YES but low yield': '', 'YES but check out tuition': 'yes', 'no': 'no', 'Yes': 'yes', 'Maybe if ties': '', 
                 'if u mormon': '', 'NO NO NO': 'no', 'nah check out their OOS tuition': '', 'yes maybe?': '', 'yes if ties to state': '', 
                 'maybe': '', 'YES ': 'yes'}
merge_df = merge_df.replace({'apply OOS to public state school?': mapping_dict2})

merge_df.to_csv('admit_docs_merged.csv', encoding='utf-8', index = False)

## fill in some other schools with concensus on OOS friendliness
## based on https://www.reddit.com/r/premed/wiki/schoollist/
## all TX schools are a no, UW is a no
## thresholds: 25% OOS > = no; 25% OOS - 50% OOS = maybe; 50% OOS < yes
## if doc and reddit disagree, I put it as maybe --> will use ML to predict these later


merge_df.loc[merge_df['Public/Private'] == 'Private', 'apply OOS to public state school?'] = 'yes'

## remove uncertain schools
uncertain_privates_list = ['Baylor', 'Geisinger Commonwealth', 'University of Cincinnati', 'UNC']
merge_df.loc[merge_df['School'].isin(uncertain_privates_list), 'apply OOS to public state school?'] = ''

OOS_yes_list = ['Eastern Virginia', 'Oakland University', 'Ohio State University', 'Penn State University', 'University of Vermont', 'West Virginia University', 
                'University of Michigan', 'Western Michigan']
# OOS_maybe_list = ['Baylor', 'Geisinger Commonwealth', 'Indiana University', 'University of Arizona', 'University of Arizona (Phoenix)', 
#                   'UCLA', 'University of Cincinnati', 'Colorado', 'University of Iowa', 'University of Kentucky', 'University of Maryland',
#                   'University of Nevada (Reno)', 'University of South Carolina', 'South Carolina (Greenville)', 'Unviersity of South Dakota', 
#                   'University of Utah', 'University of Wisconsin', 'USF (Morsani)', 'Virginia Commonwealth', 'Wayne State University', 'Wright State University',
#                   'UMass', 'Stony Brook University', 'University of Illinois', 'University of Central Florida', 'Florida Atlantic University']
OOS_no_list = ['East Carolina University', 'Central Michigan', 'CUNY School of Medicine', 'UTSW', 'McGovern (Houston)', 'Texas A&M', 
               'East Tennessee State', 'Florida State University', 'Buffalo (Jacobs)', 'LSU (New Orleans)', 'LSU (Shreveport)', 'Marshall University', 
               'Augusta University (MCG)', 'Medical College of Wisconsin', 'Mercer University', 'Michigan State University', 'Northeast Ohio', 'Southern Illinois University', 
               'SUNY Downstate', 'SUNY Upstate', 'University of Alabama', 'University of Arkansas', 'UC Davis', 'UC Irvine', 
               'University of Florida', 'University of Hawaii', 'University of Kansas', 'University of Louisville', 'University of Mississippi', 'Missouri-Columbia',
               'University of Nebraska', 'University of New Mexico', 'University of Oklahoma', 'University of South Alabama', 'University of Tennessee']


merge_df.loc[merge_df['School'].isin(OOS_yes_list), 'apply OOS to public state school?'] = 'yes'
merge_df.loc[merge_df['School'].isin(OOS_no_list), 'apply OOS to public state school?'] = 'no'


merge_df.to_csv('admit_docs_merged_ML.csv', encoding='utf-8', index = False)
