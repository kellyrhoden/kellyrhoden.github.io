# Sales Analysis Project
### Project Status: ***In Progress***
* Tools: Excel, SQL, Tableau
* Data

## Data Cleaning
**Tool: Excel**
* Checked for duplicates (none found)
* Converted PRICEEACH, SALES, and MSRP columns from General to Currency
* Converted ORDERDATE from Custom to Date
* Created new column, UNIQUEID, using INDEX, UNIQUE, RANDARRAY, and SEQUENCE functions to create a primary key
* Created new column, MONTH, using TEXT function based on MONTHID column

## Data Exploration
**Tool: SQL**

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

#### <ins>*Exploratory Questions*</ins>
Descriptive Statistics:
* What is the date range of the dataset?
* How many orders have been placed?
* How many unique customers have placed orders?
* How much total revenue has been made?
* What is the average order value?
* On average, how many products are sold per order?
* What is the price range of the products?
* What is the MSRP range of the products?

Sales Trends and Patterns:
* What is the annual sales revenue?
* Can we identify any patterns in quarterly sales?
* What are the most profitable times of the year?
* Are there any patterns in sales based on the day of the week?
* How many orders have been cancelled or disputed?
* What is the current status of all orders?
* How does the MSRP compare to the actual price?

Product Analysis:
* Which product line generates the highest revenue?
* What is the distribution of sales revenue by product line?
* What are the most commonly ordered products?
* What is the distribution of sales quantities for different products?
* What is the spread of products across orders by product line?
* Are there any outliers in terms of sales revenue or quantity ordered?
* How does the deal size vary across different product lines?

Customer Analysis:
* Does the number of items ordered vary across different cities or states?
* Are there any trends in customer purchase behavior over time?
* What is the distribution of customer locations by country and territory?
* How do sales vary across different customer segments (e.g., new vs. returning customers)?
* Is there any relationship between sales and discounts offered?
* What is the distribution of order statuses?

## Data Source
https://www.kaggle.com/datasets/kyanyoga/sample-sales-data
