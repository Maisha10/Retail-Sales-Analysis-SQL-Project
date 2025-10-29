-- SQL Retal Sales Analysis
-- CREATE TABLE
DROP TABLE IF EXISTS sales_data;
CREATE TABLE sales_data (
    "Transaction ID" INT PRIMARY KEY,
    "Date" DATE,
    "Customer ID" VARCHAR(50),
    "Gender" VARCHAR(10),
    "Age" INTEGER,
    "Product Category" VARCHAR(50),
    "Quantity" INTEGER,
    "Price per Unit" FLOAT,
    "Total Amount" FLOAT
);
-- Change all column names from spaced to underscore format
ALTER TABLE sales_data RENAME COLUMN "Transaction ID" TO transaction_id;
ALTER TABLE sales_data RENAME COLUMN "Date" TO transaction_date;
ALTER TABLE sales_data RENAME COLUMN "Customer ID" TO customer_id;
ALTER TABLE sales_data RENAME COLUMN "Gender" TO gender;
ALTER TABLE sales_data RENAME COLUMN "Age" TO age;
ALTER TABLE sales_data RENAME COLUMN "Product Category" TO product_category;
ALTER TABLE sales_data RENAME COLUMN "Quantity" TO quantity;
ALTER TABLE sales_data RENAME COLUMN "Price per Unit" TO price_per_unit;
ALTER TABLE sales_data RENAME COLUMN "Total Amount" TO total_amount;

--Data Cleaning
SELECT *
FROM sales_data 
WHERE transaction_id IS NULL
OR transaction_date IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR product_category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR total_amount IS NULL;

--Data Exploration
--How many sales is made?
SELECT SUM(Quantity) as total_sale FROM sales_data;

--How many unique customers are there?
SELECT COUNT(DISTINCT customer_id) as total_customers FROM sales_data;
--Number of categories
SELECT DISTINCT product_category as category FROM sales_data
--Data Analysis aand Business Key Problem
-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2023-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2023
-- Q.3 Write a SQL query to calculate the total sales for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each season and number of orders (Example Summer, Winter, Autumn)


 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM sales_data
WHERE transaction_date = '2023-11-05';
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2023

SELECT 
  *
FROM sales_data
WHERE 
    product_category = 'Clothing'
    AND 
    TO_CHAR(transaction_date, 'YYYY-MM') = '2023-11'
    AND
    quantity >= 4


-- Q.3 Write a SQL query to calculate the total sales for each category.

SELECT 
    product_category,
    SUM(total_amount) as net_sale,
    COUNT(*) as total_orders
FROM sales_data
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM sales_data
WHERE product_category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM sales_data
WHERE total_amount > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    product_category,
    gender,
    COUNT(*) as total_transaction_made
FROM sales_data
GROUP 
    BY 
    product_category,
    gender
ORDER BY 1


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM transaction_date) as year,
    EXTRACT(MONTH FROM transaction_date) as month,
    AVG(total_amount) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM transaction_date) ORDER BY AVG(total_amount) DESC) as rank
FROM sales_data
GROUP BY 1, 2
) as t1
WHERE rank = 1
    
-- ORDER BY 1, 3 DESC

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_amount) as total_sales
FROM sales_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT 
    product_category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM sales_data
GROUP BY product_category



-- Q.10 Write a SQL query to create each season and number of orders (Example Summer, Winter, Autumn)

WITH yearly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(MONTH FROM transaction_date) BETWEEN 08 AND 12 THEN 'Winter'
        WHEN EXTRACT(MONTH FROM transaction_date) BETWEEN 01 AND 04 THEN 'Summer'
        ELSE 'Autumn'
    END as season
FROM sales_data
)
SELECT 
    season,
    COUNT(*) as total_orders    
FROM yearly_sale
GROUP BY season

-- End of project

