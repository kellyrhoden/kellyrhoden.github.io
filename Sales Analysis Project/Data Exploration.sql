/* Created for initial exploration of the dataset using BigQuery. Organized into the following sections: 
Global Numbers, Sales Over Time, Sales By Product, Sales By Location/Customer, Pricing Analysis */

-- GLOBAL NUMBERS
-- Dataset date range
SELECT MIN(ORDERDATE) AS OLDEST_ORDER, MAX(ORDERDATE) AS NEWEST_ORDER
FROM Sales_Tables.TimeData;

-- Total number of orders
SELECT COUNT(DISTINCT ORDERNUMBER) AS TOTAL_ORDERS
FROM Sales_Tables.ProductData;

-- Total number of unique customers
SELECT COUNT(DISTINCT CUSTOMERNAME) AS UNIQUE_CUSTOMERS
FROM Sales_Tables.CustomerData;

-- Total number of products sold
SELECT SUM(QUANTITYORDERED) AS TOTAL_QUANTITY_ORDERED
FROM Sales_Tables.OrderSize;

-- Total sales revenue
SELECT ROUND(SUM(SALES), 2) AS TOTAL_SALES_REVENUE
FROM Sales_Tables.OrderSize
JOIN Sales_Tables.ProductData
	ON OrderSize.UNIQUEID=ProductData.UNIQUEID;

-- Average number of products sold per order
SELECT ROUND(AVG(PRODUCTS_PER_ORDER), 2) AS AVG_PRODUCTS_PER_ORDER
FROM (
  SELECT ORDERNUMBER, COUNT(*) AS PRODUCTS_PER_ORDER
  FROM Sales_Tables.ProductData
  GROUP BY ORDERNUMBER
) AS PRODUCT_COUNT;

-- Average order value
SELECT ROUND(AVG(Sales), 2) AS AVG_ORDER_VALUE
FROM Sales_Tables.OrderSize;

-- Sales revenue per order
SELECT ORDERNUMBER, ROUND(SUM(SALES), 2) AS TOTAL_SALES_REVENUE
FROM Sales_Tables.OrderSize
JOIN Sales_Tables.ProductData
  ON OrderSize.UNIQUEID=ProductData.UNIQUEID
GROUP BY ORDERNUMBER;

-- Number of orders by order status
SELECT STATUS, COUNT(DISTINCT ORDERNUMBER) AS ORDER_COUNT
FROM Sales_Tables.OrderStatus
JOIN Sales_Tables.ProductData
  ON OrderStatus.UNIQUEID = ProductData.UNIQUEID
GROUP BY STATUS;

-- SALES OVER TIME
-- Sales per year
SELECT YEAR_ID, ROUND(SUM(SALES), 2) AS ANNUAL_SALES
FROM Sales_Tables.TimeData
JOIN Sales_Tables.OrderSize
	ON OrderSize.UNIQUEID=TimeData.UNIQUEID
GROUP BY YEAR_ID;

-- Sales per quarter
SELECT QTR_ID, ROUND(SUM(SALES), 2) AS QUARTERLY_SALES
FROM Sales_Tables.TimeData
JOIN Sales_Tables.OrderSize
  ON TimeData.UNIQUEID = OrderSize.UNIQUEID
GROUP BY QTR_ID
ORDER BY QTR_ID;

-- Sales per month
SELECT MONTH, ROUND(SUM(SALES), 2) AS MONTHLY_SALES
FROM Sales_Tables.TimeData
JOIN Sales_Tables.OrderSize
  ON TimeData.UNIQUEID = OrderSize.UNIQUEID
GROUP BY MONTH
ORDER BY MONTHLY_SALES DESC;

-- Sales per day of the week
SELECT FORMAT_DATE('%A', DATE(ORDERDATE)) AS DAY_OF_WEEK, ROUND(SUM(SALES), 2) AS DAILY_SALES
FROM Sales_Tables.TimeData
JOIN Sales_Tables.OrderSize
  ON TimeData.UNIQUEID = OrderSize.UNIQUEID
GROUP BY DAY_OF_WEEK;

-- Looking at the average quantity ordered, minimum sales value, and maximum sales value per deal size category
SELECT DEALSIZE,
  ROUND(AVG(QUANTITYORDERED)) AS AVG_QUANTITY,
  MIN(SALES) AS MIN_SALES,
  MAX(SALES) AS MAX_SALES
FROM Sales_Tables.OrderSize
GROUP BY DEALSIZE;

-- SALES BY PRODUCT
-- Total sales revenue by product line
SELECT PRODUCTLINE, ROUND(SUM(SALES), 2) AS TOTAL_SALES_REVENUE
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
  ON ProductData.UNIQUEID = OrderSize.UNIQUEID
GROUP BY PRODUCTLINE;

-- Total number of products sold by product code
SELECT PRODUCTCODE, SUM(QUANTITYORDERED) AS TOTAL_QUANTITY_SOLD
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
	ON ProductData.UNIQUEID=OrderSize.UNIQUEID
GROUP BY PRODUCTCODE;

-- Total number of products sold by product line
SELECT PRODUCTLINE, SUM(QUANTITYORDERED) AS TOTAL_QUANTITY_SOLD
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
	ON ProductData.UNIQUEID=OrderSize.UNIQUEID
GROUP BY PRODUCTLINE;

-- Spread of products across all orders by product line
SELECT PRODUCTLINE, COUNT(DISTINCT ORDERNUMBER) AS NUMBER_OF_ORDERS
FROM Sales_Tables.ProductData
GROUP BY PRODUCTLINE;

-- Deal size by product line
SELECT PRODUCTLINE, DEALSIZE, COUNT(OrderSize.UNIQUEID) AS NUMBER_OF_DEALS
FROM Sales_Tables.OrderSize
JOIN Sales_Tables.ProductData
  ON OrderSize.UNIQUEID = ProductData.UNIQUEID
GROUP BY PRODUCTLINE, DEALSIZE;

-- Summary table of the number of products, the order quantity, and the total sales revenue of all orders
SELECT ORDERNUMBER, COUNT(PRODUCTCODE) AS PRODUCT_COUNT, SUM(QUANTITYORDERED) AS QUANTITY_COUNT,
  ROUND(SUM(SALES), 2) AS TOTAL_SALES_REVENUE, STATUS
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
  ON ProductData.UNIQUEID = OrderSize.UNIQUEID
JOIN Sales_Tables.OrderStatus
  ON ProductData.UNIQUEID = OrderStatus.UNIQUEID
GROUP BY ORDERNUMBER, STATUS;

-- SALES BY LOCATION/CUSTOMER
-- Average order value by country
SELECT Country, ROUND(AVG(Sales), 2) AS AVG_ORDER_VALUE
FROM Sales_Tables.OrderSize
JOIN Sales_Tables.LocationData
  ON OrderSize.UNIQUEID = LocationData.UNIQUEID
GROUP BY Country
ORDER BY AVG_ORDER_VALUE DESC;

-- Total sales by country
SELECT Country, ROUND(SUM(SALES), 2) AS TOTAL_SALES
FROM Sales_Tables.OrderSize
JOIN Sales_Tables.LocationData
  ON OrderSize.UNIQUEID = LocationData.UNIQUEID
GROUP BY Country
ORDER BY TOTAL_SALES DESC;

-- Number of orders by country
SELECT Country, COUNT(DISTINCT ORDERNUMBER) AS NUMBER_OF_ORDERS
FROM Sales_Tables.ProductData
JOIN Sales_Tables.LocationData
  ON ProductData.UNIQUEID = LocationData.UNIQUEID
GROUP BY Country
ORDER BY NUMBER_OF_ORDERS DESC;

-- Number of products sold by country
SELECT Country, SUM(QUANTITYORDERED) AS QUANTITY_OF_PRODUCTS
FROM Sales_Tables.OrderSize
JOIN Sales_Tables.LocationData
  ON OrderSize.UNIQUEID = LocationData.UNIQUEID
GROUP BY Country
ORDER BY QUANTITY_OF_PRODUCTS DESC;

-- Number of customers by territory
SELECT TERRITORY, COUNT(DISTINCT CUSTOMERNAME) AS CUSTOMERS
FROM Sales_Tables.LocationData
JOIN Sales_Tables.CustomerData
  ON LocationData.UNIQUEID = CustomerData.UNIQUEID
GROUP BY TERRITORY;

-- Number of customers by country
SELECT COUNTRY, COUNT(DISTINCT CUSTOMERNAME) AS CUSTOMERS
FROM Sales_Tables.LocationData
JOIN Sales_Tables.CustomerData
  ON LocationData.UNIQUEID = CustomerData.UNIQUEID
GROUP BY COUNTRY;

-- Number of customers by U.S. state
SELECT STATE, COUNT(DISTINCT CUSTOMERNAME) AS CUSTOMERS
FROM Sales_Tables.LocationData
JOIN Sales_Tables.CustomerData
  ON LocationData.UNIQUEID = CustomerData.UNIQUEID
WHERE COUNTRY = 'USA'
GROUP BY STATE;

-- Looking at purchasing dates of top two customers
WITH CUSTOMERORDERS AS (
    SELECT CUSTOMERNAME, ORDERDATE,
      COUNT(DISTINCT ORDERNUMBER) OVER (PARTITION BY CUSTOMERNAME) AS ORDERCOUNT
    FROM Sales_Tables.CustomerData
    JOIN Sales_Tables.ProductData
      ON CustomerData.UNIQUEID = ProductData.UNIQUEID
    JOIN Sales_Tables.TimeData
      ON CustomerData.UNIQUEID = TimeData.UNIQUEID
)
SELECT DISTINCT CUSTOMERNAME, ORDERDATE
FROM CUSTOMERORDERS
WHERE ORDERCOUNT > 10
ORDER BY CUSTOMERNAME, ORDERDATE;

-- Number of orders and total sales by customer
SELECT DISTINCT(CUSTOMERNAME), 
  COUNT(DISTINCT ORDERNUMBER) AS NUMBER_OF_ORDERS, 
  ROUND(SUM(SALES), 2) AS TOTAL_SALES
FROM Sales_Tables.CustomerData
JOIN Sales_Tables.ProductData
  ON CustomerData.UNIQUEID = ProductData.UNIQUEID
JOIN Sales_Tables.OrderSize
  ON CustomerData.UNIQUEID = OrderSize.UNIQUEID
GROUP BY CUSTOMERNAME
ORDER BY TOTAL_SALES DESC;

-- PRICING ANALYSIS
-- MSRP per product code
SELECT DISTINCT PRODUCTCODE, MSRP
FROM Sales_Tables.ProductData;

-- MSRP per product line
SELECT DISTINCT PRODUCTLINE, MSRP
FROM Sales_Tables.ProductData;

-- Price per product code
SELECT DISTINCT PRODUCTCODE, PRICEEACH
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
  ON ProductData.UNIQUEID = OrderSize.UNIQUEID;

-- Price per product line
SELECT DISTINCT PRODUCTLINE, PRICEEACH
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
  ON ProductData.UNIQUEID = OrderSize.UNIQUEID;

-- Total quantity ordered per each price point
SELECT PRICEEACH, SUM(QUANTITYORDERED) AS TOTAL_QUANTITY_ORDERED
FROM Sales_Tables.OrderSize
GROUP BY PRICEEACH;

-- Comparing estimated revenue based on price and quantity or MSRP and quantity to actual sales revenue
SELECT PRODUCTCODE, QUANTITYORDERED, PRICEEACH, 
  (PRICEEACH - MSRP) AS PRICE_MSRP_DIFF,
  (QUANTITYORDERED * PRICEEACH) AS SALES_EST, SALES,
  ROUND((SALES - (QUANTITYORDERED * PRICEEACH)), 2) AS SALES_DIFF,
  MSRP, (QUANTITYORDERED * MSRP) AS MSRP_SALES_EST,
  ROUND((SALES - (QUANTITYORDERED * MSRP)), 2) AS MSRP_SALES_DIFF
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
  ON ProductData.UNIQUEID = OrderSize.UNIQUEID
ORDER BY SALES DESC;

-- Comparing estimated sales revenue to actual sales revenue for highest priced products
SELECT PRODUCTCODE, PRICEEACH, QUANTITYORDERED, SALES,
  (QUANTITYORDERED * PRICEEACH) AS SALES_EST,
  ROUND((SALES - (QUANTITYORDERED * PRICEEACH)), 2) AS SALES_DIFF
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
  ON ProductData.UNIQUEID = OrderSize.UNIQUEID
WHERE PRICEEACH = 100;

-- Total sales revenue less total estimated sales revenue
SELECT ROUND(SUM(SALES) - SUM(QUANTITYORDERED * PRICEEACH))
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
  ON ProductData.UNIQUEID = OrderSize.UNIQUEID;

-- Total sales revenue less total MSRP estimated sales revenue
SELECT ROUND(SUM(SALES) - SUM(QUANTITYORDERED * MSRP))
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
  ON ProductData.UNIQUEID = OrderSize.UNIQUEID;
