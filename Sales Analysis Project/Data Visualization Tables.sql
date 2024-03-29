/* Created for data visualization using Tableau */

--TABLE 1
-- Total sales revenue, unique customers, average order value, and average number of products sold per order
SELECT 
  ROUND(SUM(SALES), 2) AS TOTAL_SALES_REVENUE, 
  COUNT(DISTINCT CUSTOMERNAME) AS UNIQUE_CUSTOMERS,
  ROUND(AVG(Sales), 2) AS AVG_ORDER_VALUE,
  (SELECT ROUND(AVG(PRODUCTS_PER_ORDER), 2)
  FROM
    (SELECT ORDERNUMBER, COUNT(*) AS PRODUCTS_PER_ORDER
    FROM Sales_Tables.ProductData
    GROUP BY ORDERNUMBER)
  ) AS AVG_PRODUCTS_PER_ORDER
FROM Sales_Tables.OrderSize
JOIN Sales_Tables.CustomerData
  ON OrderSize.UNIQUEID = CustomerData.UNIQUEID
JOIN Sales_Tables.ProductData
  ON Ordersize.UNIQUEID = ProductData.UNIQUEID;

--TABLE 2
-- Sales and orders bought per month and year
SELECT DISTINCT YEAR, ANNUAL_ORDERS, ANNUAL_SALES, MONTH, MONTHLY_ORDERS, MONTHLY_SALES
FROM (SELECT YEAR_ID YEAR, 
        COUNT(DISTINCT ORDERNUMBER) AS ANNUAL_ORDERS, 
        ROUND(SUM(SALES), 2) AS ANNUAL_SALES
      FROM Sales_Tables.OrderSize
      JOIN Sales_Tables.TimeData
        ON OrderSize.UNIQUEID = TimeData.UNIQUEID
      JOIN Sales_Tables.ProductData
        ON OrderSize.UNIQUEID = ProductData.UNIQUEID
      GROUP BY YEAR_ID) AS YEARLY
JOIN (SELECT MONTH, YEAR_ID, 
        COUNT(DISTINCT ORDERNUMBER) AS MONTHLY_ORDERS, 
        ROUND(SUM(SALES), 2) AS MONTHLY_SALES
      FROM Sales_Tables.OrderSize
      JOIN Sales_Tables.TimeData
        ON OrderSize.UNIQUEID = TimeData.UNIQUEID
      JOIN Sales_Tables.ProductData
        ON OrderSize.UNIQUEID = ProductData.UNIQUEID
      GROUP BY YEAR_ID, MONTH) AS MONTHLY
  ON YEARLY.YEAR = MONTHLY.YEAR_ID
GROUP BY MONTH, MONTHLY_SALES, MONTHLY_ORDERS, YEAR, ANNUAL_SALES, ANNUAL_ORDERS;

-- TABLE 3
-- Sales, orders, a quantity of products ordered per day of the week
SELECT FORMAT_DATE('%A', DATE(ORDERDATE)) AS DAY_OF_WEEK, 
  ROUND(SUM(SALES), 2) AS TOTAL_SALES,
  COUNT(DISTINCT ORDERNUMBER) AS TOTAL_ORDERS,
  SUM(QUANTITYORDERED) AS TOTAL_QUANTITY
FROM Sales_Tables.TimeData
JOIN Sales_Tables.OrderSize
  ON TimeData.UNIQUEID = OrderSize.UNIQUEID
JOIN Sales_Tables.ProductData
  ON TimeData.UNIQUEID = ProductData.UNIQUEID
GROUP BY DAY_OF_WEEK;

-- TABLE 4
-- Looking at the average product quantity, number of deals, minimum sales value, maximum sales value, average sales value, and total sales per deal size
SELECT DEALSIZE DEAL_SIZE,
  ROUND(AVG(QUANTITYORDERED)) AS AVG_QUANTITY,
  COUNT(DISTINCT ProductData.UNIQUEID) AS TOTAL_DEALS,
  MIN(SALES) AS SALES_MIN,
  MAX(SALES) AS SALES_MAX,
  ROUND(AVG(SALES), 2) AS AVG_SALES,
  ROUND(SUM(SALES), 2) AS TOTAL_SALES
FROM Sales_Tables.OrderSize
JOIN Sales_Tables.ProductData
  ON OrderSize.UNIQUEID = ProductData.UNIQUEID
GROUP BY DEALSIZE;

-- TABLE 5
-- Total sales revenue, orders, and quantities sold by product line
SELECT PRODUCTLINE, 
  ROUND(SUM(SALES), 2) AS TOTAL_SALES_REVENUE,
  SUM(QUANTITYORDERED) AS TOTAL_QUANTITY_SOLD,
  COUNT(DISTINCT ORDERNUMBER) AS NUMBER_OF_ORDERS,
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
  ON ProductData.UNIQUEID = OrderSize.UNIQUEID
GROUP BY PRODUCTLINE;

-- TABLE 6
-- Total sales, average order value, number of orders, and total products sold by country
SELECT Country, 
  ROUND(AVG(Sales), 2) AS AVG_ORDER_VALUE,
  ROUND(SUM(SALES), 2) AS TOTAL_SALES,
  COUNT(DISTINCT ORDERNUMBER) AS NUMBER_OF_ORDERS,
  SUM(QUANTITYORDERED) AS QUANTITY_OF_PRODUCTS,
  COUNT(DISTINCT CUSTOMERNAME) AS CUSTOMERS
FROM Sales_Tables.OrderSize
JOIN Sales_Tables.LocationData
  ON OrderSize.UNIQUEID = LocationData.UNIQUEID
JOIN Sales_Tables.ProductData
  ON OrderSize.UNIQUEID = ProductData.UNIQUEID
JOIN Sales_Tables.CustomerData
  ON OrderSize.uNIQUEID = CustomerData.UNIQUEID
GROUP BY Country;


-- TABLE 7
-- Sales by country and order date
SELECT ORDERDATE, COUNTRY, 
  ROUND(SUM(SALES), 2) AS TOTAL_SALES,
  SUM(QUANTITYORDERED) AS QUANTITY_OF_PRODUCTS,
FROM Sales_Tables.OrderSize
JOIN Sales_Tables.LocationData
  ON OrderSize.UNIQUEID = LocationData.UNIQUEID
JOIN Sales_Tables.ProductData
  ON OrderSize.UNIQUEID = ProductData.UNIQUEID
JOIN Sales_Tables.CustomerData
  ON OrderSize.uNIQUEID = CustomerData.UNIQUEID
JOIN Sales_Tables.TimeData
  ON OrderSize.UNIQUEID = TimeData.UNIQUEID
GROUP BY ORDERDATE, Country;

-- TABLE 8
-- Looking at purchasing dates of all customers
WITH CUSTOMERORDERS AS (
    SELECT COUNTRY, CUSTOMERNAME, ORDERDATE, ORDERNUMBER,
      COUNT(DISTINCT ORDERNUMBER) OVER (PARTITION BY CUSTOMERNAME) AS ORDERCOUNT,
      ROUND(SUM(SALES), 2) AS TOTAL_SALES
    FROM Sales_Tables.CustomerData
    JOIN Sales_Tables.ProductData
      ON CustomerData.UNIQUEID = ProductData.UNIQUEID
    JOIN Sales_Tables.TimeData
      ON CustomerData.UNIQUEID = TimeData.UNIQUEID
    JOIN Sales_Tables.OrderSize
      ON CustomerData.UNIQUEID = OrderSize.UNIQUEID
    JOIN Sales_Tables.LocationData
      ON CustomerData.UNIQUEID = LocationData.UNIQUEID
    GROUP BY COUNTRY, CUSTOMERNAME, ORDERDATE, ORDERNUMBER)
SELECT DISTINCT COUNTRY, ORDERNUMBER, CUSTOMERNAME, ORDERDATE, TOTAL_SALES
FROM CUSTOMERORDERS
ORDER BY COUNTRY, ORDERNUMBER, CUSTOMERNAME, ORDERDATE;
