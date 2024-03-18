# State Migration and Housing Price Index Analysis
### Project Status: ***Complete***
* Tools: Excel, SQL, Python (pandas, scipy)
* Data wrangling, data cleaning, data analysis, data visualization

## Project Objective
South Carolina is among the states with the fastest-growing populations, and a large number of people moving to the south are from northern states. The cost of living, which is 13% lower than the national average cost of living, is among the list of reasons that many may choose to move to SC. This project aim's to determine if there is a correlation between northern migration to SC and the SC housing price index (HPI)

## Data Wrangling & Cleaning
**Tool: Excel**

* [Final Table](https://github.com/kellyrhoden/kellyrhoden.github.io/blob/main/State%20Migration%20and%20Housing%20Price%20Index%20Analysis/testdata.csv)

*Data Sources*
* [CDC State-to-State Migration Flows, 2012 -2019, 2021-2022](https://www.census.gov/data/tables/time-series/demo/geographic-mobility/state-to-state-migration.html)
* [Federal Housing Finance Agency Master Housing Price Index](https://www.fhfa.gov/DataTools/Downloads/Pages/House-Price-Index-Datasets.aspx)

*Data Cleaning*

Combining the state-to-state migration flow tables:
* Created a Year column to record which year the data corresponds to
* Deleted the margin of error columns 
* Deleted the extra “Current residence in” columns that were present in the table, leaving just the first one.
* Deleted all columns from “Population 1 year and over” through “Different state of residence 1 year ago – Total”
* Deleted the “Abroad 1 year ago” column and subcolumns
* Replaced missing data values for the 2012 “Different state of residence 1 year ago” KY, ME, MA, and MN columns with the midpoint between the prior and following year for each value
* Replaced missing data values for each non-consecutive zero data point with the midpoint between the prior and following year for each value
* Replaced consecutive zeroes in the WY column from 2014-2021 with the rounded up midpoint between the 2013 and 2022 data points
* Created the column Leaving_SC from the South Carolina column for each U.S. row and made these numbers negative to reflect the change in the SC population
* Classified all state columns and combined them correspondingly into Northern_Migration_to_SC and NonNorthern_Migration_to_SC
* Created a Total_Migration_to_SC column that adds northern and nonnorthern migrations to SC
* Created a Migration_Difference column to subtract Leaving_SC from Migrating_to_SC

Condensing the HPI table:
* Deleted rows for locations that were not needed for analysis
* Deleted every row that had a year value less than 2012 and greater than 2022; also deleted rows with 2020
* Deleted the seasonally adjusted house price index as it was not available for any of the years during this period
* Deleted hpi_type, hpi_flavor, frequency, level, and place_id columns since they are not needed for the analysis
* Deleted the place_name column since all values are now the same (SC)
* Consolidate quarterly data into yearly data by finding the mean of the 4 non-seasonally adjusted index values for each year

The final combined table has 10 rows of data with the following columns:
* Year
* Northern_Migration_to_SC
* NonNorthern_Migration_to_SC
* Total_Migration_to_SC
* Leaving_SC
* Migration_Difference
* NSA_HPI

## Data Analysis
**Tools: SQL, Python**

* [Code](https://github.com/kellyrhoden/kellyrhoden.github.io/blob/main/State%20Migration%20and%20Housing%20Price%20Index%20Analysis/testdata.py)

*Plan*

The Pearson correlation coefficient will be calculated for  state-to-state migration of non-northern migration vs northern migration to SC and the SC HPI. The correlation coefficient will also be calculated for  total migrations to SC and the SC HPI. These calculations will return a correlation value between -1.00 and 1.00. If the value for the northern region is between .85 and 1.00 and higher than the other regions, then the hypothesis will be accepted. It may also result in a positive correlation that is not as strong as 0.85, in which case the hypothesis may be supported but additional factors affecting the relationship between northern migration to SC and the housing price index. If the correlation is negative, the hypothesis will be rejected. 

The annual data for all migrations from SC should be negatively correlated with the number of migrations to SC. The Pearson correlation coefficient will be calculated for the migration to SC and the number of people leaving SC, and the result should be a negative number to further support the hypothesis.


*Analysis*

* The non-northern migration correlation coefficient was 0.95, while the northern migration coefficient was 0.83; these are both positive coefficients, indicating that as one increases, the other increases. 
* The correlation coefficient for total migrations to SC and the SC HPI, which resulted in 0.94; this is a positive coefficient, indicating as one increases, the other increases. 
* The correlation coefficient between migrations to SC and migrations from SC was -0.56; this is a negative coefficient, indicating that as one increases, the other decreases.

## Results & Data Visualization


There has been a greater difference over the past 10 years in the number of migrations to SC than there has been in the number of people migrating from SC. In terms of their effect on the SC population, the negative correlation between total migrations from SC and total migrations to SC indicates that as there is an increase in the population from the number of people moving to SC, there is a relatively smaller decrease in the population due to the number of people moving from SC (Figure 1). The number of people migrating to SC exceeds the number of people migrating from SC during this period, with the differences ranging from 28,000 to 80,000 more people migrating to SC than from SC each year. 

There has generally been an increase over the past 10 years in the number of migrations to SC as well as the SC HPI (Figure 2). The number of people leaving SC has increased over the period at a slower rate than the number of people migrating to SC. The positive correlation between the northern migration to SC and the SC HPI indicates that the increasing northern migration to SC is correlated to an increase in the SC HPI, however, there is a stronger positive correlation between the non-northern migration to SC and the SC HPI. This indicates that an increase in total migration to SC is strongly correlated to an increase in the SC HPI, rather than correlating to northern migrations alone. While northern migrations do have a strong correlation to the HPI, there may be additional factors affecting the relationship between northern migration to SC and the SC housing price index, including migration from other states to SC. It is reasonable to assume that northern migrations to SC may be a factor in the increasing SC HPI.

**Figure 1.**
![Figure1](https://github.com/kellyrhoden/kellyrhoden.github.io/blob/main/State%20Migration%20and%20Housing%20Price%20Index%20Analysis/figure1.png)


**Figure 2.**
![Figure2](https://github.com/kellyrhoden/kellyrhoden.github.io/blob/main/State%20Migration%20and%20Housing%20Price%20Index%20Analysis/figure2.png)
