## GLOBAL NUMBERS
# dataset date range
SELECT MIN(ORDERDATE) AS OLDESTORDER, MAX(ORDERDATE) AS NEWESTORDER
FROM Sales_Tables.TimeData;

# total number of orders
SELECT DISTINCT ORDERNUMBER
FROM Sales_Tables.ProductData;

# total number of unique customers
SELECT COUNT(DISTINCT CUSTOMERNAME) AS UNIQUECUSTOMERS
FROM Sales_Tables.CustomerData;

# total sales revenue
SELECT ROUND(SUM(SALES),2) TOTALSALES
FROM Sales_Tables.OrderSize;

# average number of products sold per order
SELECT ROUND(COUNT(ORDERNUMBER)/COUNT(DISTINCT ORDERNUMBER)) ORDERPRODUCTSAVG
FROM Sales_Tables.ProductData;

# average order value
SELECT ROUND(AVG(Sales),2) AS ORDERSALESAVG
FROM Sales_Tables.OrderSize;

# sales revenue per order
SELECT DISTINCT(ORDERNUMBER), 
  ROUND(SUM(SUM(SALES)) OVER (PARTITION BY ORDERNUMBER),2) AS TOTALSALES
FROM Sales_Tables.OrderSize
JOIN Sales_Tables.ProductData
ON OrderSize.UNIQUEID=ProductData.UNIQUEID
GROUP BY ORDERNUMBER;

# number of orders by order status
SELECT DISTINCT STATUS, COUNT(STATUS) OVER (PARTITION BY STATUS) AS ORDERS
FROM Sales_Tables.OrderStatus;




## SALES OVER TIME
# sales per year
SELECT DISTINCT(YEAR_ID), 
  ROUND(SUM(SUM(SALES)) OVER (PARTITION BY YEAR_ID),2) AS ANNUALSALES
FROM Sales_Tables.TimeData
JOIN Sales_Tables.OrderSize
ON TimeData.UNIQUEID=OrderSize.UNIQUEID
GROUP BY YEAR_ID;

# sales per quarter
SELECT DISTINCT(QTR_ID), 
  ROUND(SUM(SUM(SALES)) OVER (PARTITION BY QTR_ID),2) AS QUARTERLYSALES
FROM Sales_Tables.TimeData
JOIN Sales_Tables.OrderSize
ON TimeData.UNIQUEID=OrderSize.UNIQUEID
GROUP BY QTR_ID
ORDER BY QTR_ID;

# sales per month
SELECT DISTINCT(MONTH), ROUND(SUM(SUM(SALES)) OVER (PARTITION BY MONTH),2) AS MONTHLYSALES
FROM Sales_Tables.TimeData
JOIN Sales_Tables.OrderSize
ON TimeData.UNIQUEID=OrderSize.UNIQUEID
GROUP BY MONTH
ORDER BY MONTHLYSALES DESC;

# sales per day of the week
WITH Weekdays AS (
  SELECT DISTINCT FORMAT_DATE('%A',DATE(ORDERDATE)) AS DAY, TimeData.UNIQUEID
  FROM Sales_Tables.TimeData
  JOIN Sales_Tables.OrderSize
  ON TimeData.UNIQUEID=OrderSize.UNIQUEID
)
SELECT DAY, ROUND(SUM(SUM(SALES)) OVER (PARTITION BY Weekdays.DAY),2) AS DAILYSALES
  FROM Weekdays
  JOIN Sales_Tables.TimeData
  ON Weekdays.UNIQUEID=TimeData.UNIQUEID
  JOIN Sales_Tables.OrderSize
  ON Weekdays.UNIQUEID=OrderSize.UNIQUEID
  GROUP BY Weekdays.DAY;




## SALES BY PRODUCT
# total sales revenue by product line
SELECT PRODUCTLINE, ROUND(SUM(SALES),2) AS TOTALSALES
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
ON ProductData.UNIQUEID=OrderSize.UNIQUEID
GROUP BY PRODUCTLINE;

# total number of products sold by product code
SELECT DISTINCT PRODUCTCODE, SUM(QUANTITYORDERED) OVER (PARTITION BY PRODUCTCODE) AS TOTALQUANTITY
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
ON ProductData.UNIQUEID=OrderSize.UNIQUEID;

# total number of products sold by product line
SELECT DISTINCT PRODUCTLINE, SUM(QUANTITYORDERED) OVER (PARTITION BY PRODUCTLINE) AS TOTALQUANTITY
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
ON ProductData.UNIQUEID=OrderSize.UNIQUEID;

# spread of products across all orders by product code
SELECT DISTINCT PRODUCTCODE, COUNT(QUANTITYORDERED) OVER (PARTITION BY PRODUCTCODE) AS TOTALORDERS
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
ON ProductData.UNIQUEID=OrderSize.UNIQUEID;

# spread of products across all orders by product line
SELECT DISTINCT PRODUCTLINE, COUNT(QUANTITYORDERED) OVER (PARTITION BY PRODUCTLINE) AS TOTALORDERS
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
ON ProductData.UNIQUEID=OrderSize.UNIQUEID;

# summary table of the number of products, the order quantity, and the total sales revenue of all orders 
SELECT DISTINCT ORDERNUMBER, 
  COUNT(PRODUCTCODE) OVER (PARTITION BY ORDERNUMBER) AS PRODUCTCOUNT, 
  SUM(QUANTITYORDERED) OVER (PARTITION BY ORDERNUMBER) AS QUANTITYCOUNT,
  ROUND(SUM(SALES) OVER (PARTITION BY ORDERNUMBER),2) AS TOTALSALES,
  STATUS
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
  ON ProductData.UNIQUEID=OrderSize.UNIQUEID
JOIN Sales_Tables.OrderStatus
  ON ProductData.UNIQUEID=OrderStatus.UNIQUEID;




## SALES BY COUNTRY
# average order value by country
SELECT Country, ROUND(AVG(Sales),2) AS AVGSALES
FROM Sales_Tables.OrderSize
LEFT JOIN Sales_Tables.LocationData
ON OrderSize.UNIQUEID=LocationData.UNIQUEID
GROUP BY Country
ORDER BY AVGSALES DESC;

# average number of sales by country
SELECT Country, ROUND(AVG(Sales),2) AS AVGSALES
FROM Sales_Tables.OrderSize
LEFT JOIN Sales_Tables.LocationData
ON OrderSize.UNIQUEID=LocationData.UNIQUEID
GROUP BY Country
ORDER BY AVGSALES DESC;




## PRICING ANALYSIS
# MSRP per product code
SELECT DISTINCT PRODUCTCODE, MSRP
FROM Sales_Tables.ProductData;

# MSRP per product line
# may pull a lower number of rows than MSRP per product code because some product lines have products with the same MSRP
SELECT DISTINCT PRODUCTLINE, MSRP
FROM Sales_Tables.ProductData;


# price per product code
# may pull a lower number of rows than price per product line because some product codes have products with the same price
SELECT DISTINCT PRODUCTCODE, PRICEEACH
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
ON ProductData.UNIQUEID=OrderSize.UNIQUEID;

# price per product line
SELECT DISTINCT PRODUCTLINE, PRICEEACH
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
ON ProductData.UNIQUEID=OrderSize.UNIQUEID;

# comparing estimated revenue based on price and quantity or MSRP and quantity to actual sales revenue
# there is a discrepancy between estimated sales revenue and actual sales revenue only for products priced at $100, which may indicate an additional fee or tax
SELECT DISTINCT PRODUCTCODE, QUANTITYORDERED, PRICEEACH, (PRICEEACH - MSRP) AS PRICEMSRPDIFF,
  (QUANTITYORDERED * PRICEEACH) AS SALESEST,
  SALES, 
  ROUND((SALES - (QUANTITYORDERED * PRICEEACH)),2) AS SALESDIFF,
  MSRP,
  (QUANTITYORDERED * MSRP) AS MSRPSALESEST,
  ROUND((SALES - (QUANTITYORDERED * MSRP)),2) AS MSRPSALESDIFF
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
ON ProductData.UNIQUEID=OrderSize.UNIQUEID
ORDER BY SALES DESC;

# comparing estimated sales revenue to actual sales revenue for highest priced products
SELECT DISTINCT PRODUCTCODE, PRICEEACH, QUANTITYORDERED, SALES,
  (QUANTITYORDERED * PRICEEACH) AS SALESEST, 
  ROUND((SALES - (QUANTITYORDERED * PRICEEACH)),2) AS SALESDIFF
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
ON ProductData.UNIQUEID=OrderSize.UNIQUEID
WHERE PRICEEACH = 100;

# total sales revenue less total estimated sales revenue
SELECT ROUND(SUM(SALES) - SUM(QUANTITYORDERED * PRICEEACH))
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
ON ProductData.UNIQUEID=OrderSize.UNIQUEID;

# total sales revenue less total MSRP estimated sales revenue
SELECT ROUND(SUM(SALES) - SUM(QUANTITYORDERED * MSRP))
FROM Sales_Tables.ProductData
JOIN Sales_Tables.OrderSize
ON ProductData.UNIQUEID=OrderSize.UNIQUEID;