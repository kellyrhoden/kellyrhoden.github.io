The following table was created to better understand what each column represents and how they are connected. Assumptions were made in areas where the dataset source did not specify (e.g. sales column calculation).

| Column | Description |
|--------------|----------------------------------------------------------------------|
| UNIQUEID | random number generated for each row of data; same across all tables |
| ADDRESSLINE1 | customer’s address line 1 |
| ADDRESSLINE2 | customer’s address line 2; can be NULL |
| CITY | customer’s address city |
| STATE | customer’s address state; can be NULL |
| POSTALCODE | customer’s address postal code; can be NULL |
| COUNTRY | customer’s address country |
| TERRITORY | customer’s address territory; values: APAC, EMEA, Japan, or NA |
| QUANTITYORDERED | number of products ordered (by product code) in a single order |
| PRICEEACH | price of each product (by product code); ranges from $26.88 to $100 |
| SALES	| calculated by multiplying quantity ordered by price each for a single product code in an order; for products with a price each of $100, sales value will be greater than the calculated value (may be due to taxes, fees, etc.) |
| DEALSIZE | categorized into small, medium, or large based on the sales column |
| ORDERNUMBER | specifies the number of a single order; all products ordered together will share an order number |
| ORDERLINENUMBER | specifies the line that an ordered product code appears on for a single order number |
| PRODUCTLINE | categorizes the product code into a product line; values: classic cars, vintage cars, trucks and buses, trains, ships, planes, motorcycles |
| MSRP | manufacturer’s suggested retail price for a specified product code |
| PRODUCTCODE | specifies a particular product within a product line |
| CUSTOMERNAME | customer’s business name
| PHONE | customer’s phone number |
| CONTACTLASTNAME | customer’s last name |
| CONTACTFIRSTNAME | customer’s first name |
| ORDERDATE | date the order was placed; formatted as M/DD/YY |
| QTR_ID | specifies the quarter of the year in which the order was placed; values: 1 to 4 |
| MONTH_ID | specifies the month number in which the order was placed: values: 1 to 12 |
| YEAR_ID | specifies the year in which the order was placed; ranges from 2003 to 2005 |
| MONTH | specifies the month in which the order was placed |
| STATUS | specifies the status of the order according to the order number; values: cancelled, disputed, resolved, on hold, in process, shipped |
