/* This project is aimed to analyse Maven Roasters Coffee Shop sales in three of its NYC locations in the US.*/
/* The project, having understood the stakeholders' perspectives and interests sets out to answer four questions 
related to the sales of the business. These questions are as follows */
/*
1. How have Maven Roasters sales trended over time?
2. Which days of the week tend to be busiest, and why is that the case?
3. What are the top 10 products and least 10 products sold?
4. Which products drive the most revenue for the business?
*/

/* To start with, a database is created on MySQL database engine to query the company's dataset download from Kaggle
using the query below*/
CREATE	database Maven_Roasters_CoffeeShop;
USE Maven_Roasters_CoffeeShop;

/* The downloaded dataset was imported into the database for exploration and creation of KPIs */
/* Now lets convert the transaction_date and transaction_time to proper date and time format */
SELECT * FROM coffee_shop_sales
LIMIT 5;

UPDATE coffee_shop_sales
SET transaction_date = STR_TO_DATE(transaction_date, '%d/%m/%Y')
;

ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_date DATE;

/* This process is repeated for transaction_time */

UPDATE coffee_shop_sales
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');

ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_time TIME;

/* Lets check the details of various fields in the dataset */
describe coffee_shop_sales;

----------------------------------------------------------------------------
-- 1. How have Maven Roasters sales trended over time?  -- Sales Trend Over Time
SELECT
	transaction_date,
    ROUND(SUM(transaction_qty * unit_price), 0) AS total_revenue
FROM
	coffee_shop_sales
GROUP BY
	transaction_date
ORDER BY 
	transaction_date;

-- trend by month
SELECT
	MONTHNAME(transaction_date) AS month,
    ROUND(SUM(transaction_qty * unit_price), 0) AS total_revenue
FROM
	coffee_shop_sales
GROUP BY 
	month 
ORDER BY
    total_revenue DESC;

----------------------------------------------------------------------------
-- 2. Which days of the week tend to be busiest, and why is that the case? -- Busiest Days of the Week
SELECT
	DAYNAME(transaction_date) AS day_of_week,
    SUM(transaction_qty) AS total_items_sold
FROM
	coffee_shop_sales
GROUP BY
	day_of_week
ORDER BY
	total_items_sold DESC;

-- Breakdown by month
SELECT
	MONTHNAME(transaction_date) AS month,
    DAYNAME(transaction_date) AS day_of_week,
    SUM(transaction_qty) AS total_items_sold
FROM
	coffee_shop_sales
GROUP BY
	month,
    day_of_week
ORDER BY
    month,
    total_items_sold DESC;

-- Coffee sales peak period 
SELECT 
	TIME(transaction_time) AS time_of_day,
    SUM(transaction_qty) AS total_items_sold
FROM
	coffee_shop_sales
WHERE 
	MONTH(transaction_date)=1
GROUP BY 
	time_of_day
ORDER BY
	total_items_sold DESC;
    
-------------------------------------------------------------------    
-- 3. What are the top 10 products and least 10 products sold? -- Top and Least 10 products sold
SELECT
	product_id,
    product_detail,
    SUM(transaction_qty) AS total_items_sold
FROM
	coffee_shop_sales
GROUP BY
	product_id,
    product_detail
ORDER BY 
	total_items_sold DESC
LIMIT 10;

SELECT
	product_id,
    product_detail,
    SUM(transaction_qty) AS total_items_sold
FROM
    coffee_shop_sales
GROUP BY
	product_id,
    product_detail
ORDER BY
	total_items_sold
LIMIT 10;

--------------------------------------------------------------------    
-- 4. Which products drive the most revenue for the business? - PRODUCTS DRIVING THE MOST REVENUE
SELECT
	product_id,
    product_detail,
    product_category,
    ROUND(SUM(transaction_qty * unit_price), 0) AS total_revenue
FROM
	coffee_shop_sales
GROUP BY
	product_id,
    product_detail,
    product_category
ORDER BY
	total_revenue DESC;

-- 5. Revenue by store location
SELECT
	store_location,
    ROUND(SUM(unit_price * transaction_qty),0) AS total_revenue
FROM
	coffee_shop_sales
GROUP BY 
	store_location
ORDER BY
	total_revenue DESC;

-- % revenue contribution by store
SELECT 
	MONTHNAME(transaction_date) AS month,
    store_location,
    ROUND(SUM(unit_price * transaction_qty),0) AS store_revenue,
    ROUND(SUM(unit_price * transaction_qty),0) *100 / SUM(SUM(unit_price * transaction_qty)) 
    OVER (PARTITION BY MONTHNAME(transaction_date)) AS percent_contribution
FROM 
	coffee_shop_sales
GROUP BY
	month,
    store_location
ORDER BY
	month,
    store_location;

-- 6. Overall top performing products across stores
SELECT 
	store_location, 
    product_id,
    product_detail,
    ROUND(SUM(unit_price * transaction_qty),0) AS total_revenue
FROM
	coffee_shop_sales
GROUP BY
	store_location,
	product_id,
    product_detail
ORDER BY
	total_revenue DESC;





