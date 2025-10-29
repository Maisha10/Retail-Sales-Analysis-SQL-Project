# Retail-Sales-Analysis-SQL-Project

## Project Overview
This project analyzes retail sales data to uncover business insights using SQL queries. The dataset contains transaction records from an e-commerce or retail business, including customer demographics, product categories, and sales metrics.

## Dataset Information
- **Source**: Kaggle
- **Records**: 1,000 transactions
- **Time Period**: January 2023 - January 2024
- **Columns**: 9 attributes including transaction details, customer demographics, and product information

## Database Schema

### Table: `retail_sales`
| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| transaction_id | INTEGER | Unique identifier for each transaction |
| transaction_date | DATE | Date of the transaction |
| customer_id | VARCHAR | Unique customer identifier |
| gender | VARCHAR | Customer gender (Male/Female) |
| age | INTEGER | Customer age |
| product_category | VARCHAR | Product category (Beauty, Clothing, Electronics) |
| quantity | INTEGER | Number of items purchased |
| price_per_unit | DECIMAL(10,2) | Price of each unit |
| total_amount | DECIMAL(10,2) | Total transaction amount |

## Business Questions & SQL Solutions

### Q1: Sales on Specific Date
```sql
SELECT *
FROM retail_sales
WHERE transaction_date = '2023-11-05';

### Q2: Clothing Category with High Quantity in November 2023
```sql
SELECT *
FROM retail_sales
WHERE product_category = 'Clothing'
  AND quantity > 2
  AND EXTRACT(YEAR FROM transaction_date) = 2023
  AND EXTRACT(MONTH FROM transaction_date) = 11;
### Q3: Total Sales by Category
``` sql
SELECT 
    product_category,
    SUM(total_amount) as total_sales
FROM retail_sales
GROUP BY product_category
ORDER BY total_sales DESC;
### Q4: Average Age of Beauty Category Customers
```sql
SELECT 
    ROUND(AVG(age), 2) as average_age
FROM retail_sales
WHERE product_category = 'Beauty';
### Q5: High-Value Transactions
```sql
SELECT *
FROM retail_sales
WHERE total_amount > 1000
ORDER BY total_amount DESC;
### Q6: Transaction Count by Gender and Category
```sql
SELECT 
    gender,
    product_category,
    COUNT(transaction_id) as transaction_count
FROM retail_sales
GROUP BY gender, product_category
ORDER BY product_category, transaction_count DESC;
### Q7: Monthly Average Sales and Best Selling Month
```sql
-- Monthly average sales
SELECT 
    EXTRACT(YEAR FROM transaction_date) as year,
    EXTRACT(MONTH FROM transaction_date) as month,
    ROUND(AVG(total_amount), 2) as average_sales,
    SUM(total_amount) as total_monthly_sales
FROM retail_sales
GROUP BY year, month
ORDER BY year, month;

-- Best selling month each year
WITH monthly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM transaction_date) as year,
        EXTRACT(MONTH FROM transaction_date) as month,
        SUM(total_amount) as total_sales
    FROM retail_sales
    GROUP BY year, month
),
ranked_months AS (
    SELECT 
        year,
        month,
        total_sales,
        RANK() OVER (PARTITION BY year ORDER BY total_sales DESC) as sales_rank
    FROM monthly_sales
)
SELECT 
    year,
    month,
    total_sales
FROM ranked_months
WHERE sales_rank = 1;
### Q8: Top 5 Customers by Total Sales
```sql
SELECT 
    customer_id,
    SUM(total_amount) as total_spent,
    COUNT(transaction_id) as transaction_count
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;
### Q9: Unique Customers per Category
```sql
SELECT 
    product_category,
    COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY product_category
ORDER BY unique_customers DESC;
### Q10: Seasonal Order Analysis
```sql
SELECT 
    CASE 
        WHEN EXTRACT(MONTH FROM transaction_date) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM transaction_date) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM transaction_date) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM transaction_date) IN (9, 10, 11) THEN 'Autumn'
    END as season,
    COUNT(transaction_id) as order_count,
    SUM(total_amount) as total_sales
FROM retail_sales
GROUP BY season
ORDER BY order_count DESC;

## Key Findings
Based on the dataset analysis:

Product Categories: Beauty, Clothing, and Electronics

Customer Base: Mixed gender distribution across all age groups

Sales Period: Full year 2023 data with some 2024 entries

Price Range: Products priced from $25 to $500 per unit

Tools & Technologies
Database: PostgreSQL

SQL Client: pgAdmin/VS Code

Data Source: Kaggle retail dataset

Setup Instructions
Create the retail_sales table in your database

Import the CSV data

Execute the SQL queries to analyze the data

Review the business insights generated

