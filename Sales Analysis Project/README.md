# Sales Analysis Project
### Project Status: *Complete*
* Tools: Excel, SQL, BigQuery, Tableau
* Data cleaning, data exploration, data analysis, and data visualization

### Table of Contents
* [Data Cleaning](https://github.com/kellyrhoden/kellyrhoden.github.io/blob/main/Sales%20Analysis%20Project/README.md#data-cleaning)
* [Data Exploration](https://github.com/kellyrhoden/kellyrhoden.github.io/blob/main/Sales%20Analysis%20Project/README.md#data-exploration)
* [Data Analysis](https://github.com/kellyrhoden/kellyrhoden.github.io/blob/main/Sales%20Analysis%20Project/README.md#data-analysis)
* [Data Visualization](https://github.com/kellyrhoden/kellyrhoden.github.io/blob/main/Sales%20Analysis%20Project/README.md#data-visualization)
* [Data Source](https://github.com/kellyrhoden/kellyrhoden.github.io/blob/main/Sales%20Analysis%20Project/README.md#data-source)

## Data Cleaning
**Tool: Excel**
* Checked for duplicates (none found)
* Converted PRICEEACH, SALES, and MSRP columns from General to Currency
* Converted ORDERDATE from Custom to Date
* Created new column, UNIQUEID, using INDEX, UNIQUE, RANDARRAY, and SEQUENCE functions to create a primary key
* Created new column, MONTH, using TEXT function based on MONTHID column

## Data Exploration
**Tool: SQL, BigQuery, Excel**

*[Description of Columns](https://github.com/kellyrhoden/kellyrhoden.github.io/blob/main/Sales%20Analysis%20Project/Description%20of%20Columns.md)*

#### <ins>*Tables Created*</ins>

LocationData
* UNIQUEID
* ADDRESSLINE1
* ADDRESSLINE2
* CITY
* STATE
* POSTALCODE
* COUNTRY
* TERRITORY

OrderSize
* UNIQUEID
* QUANTITYORDERED
* PRICEEACH
* SALES	
* DEALSIZE

ProductData
* UNIQUEID
* ORDERNUMBER
* ORDERLINENUMBER
* PRODUCTLINE
* MSRP
* PRODUCTCODE

CustomerData
* UNIQUEID
* CUSTOMERNAME
* PHONE
* CONTACTLASTNAME
* CONTACTFIRSTNAME

TimeData
* UNIQUEID
* ORDERDATE
* QTR_ID
* MONTH_ID
* YEAR_ID
* MONTH

OrderStatus
* UNIQUEID
* STATUS

## Data Analysis

**Tool: SQL, BigQuery, Excel**

Part 1: Answering exploratory questions created to guide SQL queries.

| Descriptive Statistics | |
| --- | --- |
| What is the date range of the dataset? | 01/06/2003 to 05/31/2005 |
| How many orders have been placed? | 307 orders |
| How many unique customers have placed orders?     | 92 unique customers |
| How many total products have been ordered? | 99,067 products |
| How much total revenue has been made? | $10,032,628.85 |
| What is the average order value? | $3,553.89 |
| On average, how many products are sold per order? | 9 products per order on average |
| What is the price range of the products? | $26.88 to $100 |
| What is the MSRP range of the products? | $33 to $214 |

|Sales Trends and Patterns||
| --- | --- |
| What is the annual sales revenue? | Y1: $3,516,979.54 |
| | Y2: $4,724,162.60
| | Y3: $1,791486.71* 
| | Y3 only accounts for the first 5 months of the year |
| What are the most profitable times of the year? | Most profitable quarter: Q4 |
| | Most profitable months: November, October, and May |
| Are there any patterns in sales based on the day of the week? | Most profitable day: Friday
| | Least profitable day: Monday |
| What is the average quantity ordered per deal size? | Small: 31, Medium: 38, Large: 47 |
| What is the range of sales for small deals? | $482.13 to $2,999.97 |
| What is the range of sales for medium deals? | $3,002.40 to $6,996.42 |
| What is the range of sales for large deals? | $7,016.31 to $14,082.80 |
| What price point has had the greatest quantities ordered? | 45,963 products have been ordered at the $100 price point |

| Product Analysis | |
| --- | --- |
| Which product line generates the highest revenue? | Classic Cars: $3,919,615.66|
| What is the distribution of sales revenue by product line? | Classic Cars: $3,919,615.66 |
| | Vintage Cars: $1,903,150.84 |
| | Motorcycles: $1,166,388.34 |
| | Trucks and Buses: $1,127,789.84 |
| | Planes: $975,003.57 |
| | Ships: $714,437.13 |
| | Trains: $226,243.47 |
| What are the most commonly ordered products? | Classic Cars are included in 65% of orders |
| What is the distribution of sales quantities for different products? | Classic Cars have been sold the most (33,992 sold) |
| Are there any outliers in terms of sales revenue or quantity ordered? | The highest value order is $7.8k more than the second highest value order. |
| How does the deal size vary across different product lines? | For all product lines, the most common deal size is medium, followed by small and large. |

| Location/Customer Analysis | |
| --- | --- |
| What countries have the greatest and least average order values? | Greatest: Denmark has an average order value of $3,899 |
| | Least: Canada has an average order value of $3201.12 |
| What countries have the greatest and least total sales revenue? | Greatest: USA has $3,627,982.83 in total sales revenue |
| | Least: Ireland has $57,756.43 in total sales revenue |
| What countries have the greatest and least number of orders? | Most: USA has 112 orders |
| | Least: Ireland and Switzerland both have 2 orders
| What countries have ordered the greatest and least number of products? | Greatest: USA has ordered 35,659 products |
| | Least: Ireland has orderest 490 products |
| Are there any outliers in customer purchase behavior? | Euro Shopping Channel has made the most orders (26 orders) with sales totaling $912,294.11. |
| | Mini Gifts Distributors Ltd has made the second most orders (17 orders) with sales totaling $654,858.06. |
| | The remaining 90 customers have made 1-5 orders with sales totaling between $9,129.35 and $200,995.41. |
| Where are most customers from by territory and location? | Territory: 44 from EMEA, 38 from NA |
| | Country: 35 from USA, 12 from France |
| What US states have sales? | CA, MA, NY, PA, CT, NH, NV, NJ |

## Data Visualization
* [Tableau Data Visualization](https://public.tableau.com/app/profile/kelly.rhoden1559/viz/SalesAnalysis_17113372139830/Dashboard1)

## Data Source
https://www.kaggle.com/datasets/kyanyoga/sample-sales-data
