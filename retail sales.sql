-- SQL RETAIL SALE ANALYSIS-P1
CREATE DATABASE sql_project_p2;

--CREATING A TABLE 
DROP TABLE IF EXISTS retail_sales_tb;
CREATE TABLE retail_sales_tb
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT, 
				cogs FLOAT,
				total_sale FLOAT
			);
			
SELECT * FROM retail_sales_tb
LIMIT 10;

SELECT
	COUNT(*)
FROM retail_sales_tb;

SELECT * FROM retail_sales_tb
WHERE transactions_id IS NULL


SELECT * FROM retail_sales_tb
WHERE sale_date IS NULL

SELECT * FROM retail_sales_tb
WHERE sale_time IS NULL


-- INSTEAD OF WRITING MULTIPLE TIMES CODE WRITE SINGLE CODE TO CHECK THAT NULL VALUE 

SELECT * FROM retail_sales_tb
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR 
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL;
	
	
-- DELETING NULL ROWS 
-- DATA CLEANING
DELETE FROM retail_sales_tb
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR 
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL;
	
-- AFTER DELETING CHECKING THE TABLE 
SELECT
	COUNT(*)
FROM retail_sales_tb;


--DATA EXPLORATION
-- how many sales we have ?
SELECT COUNT(*)AS total_sale FROM retail_sales_tb;


-- HOW MANY UNIQUE CUSTOMERS WE HAVE 
SELECT COUNT(DISTINCT customer_id)AS total_sale FROM retail_sales_tb;

SELECT DISTINCT  category  FROM retail_sales_tb;


-- DATA ANALYSIS & BUSINESS KEY PROBLEN & ANSWERS

--Q1.Write a sql query to retrieve all columns for sales made on "2022-11-5"
SELECT * 
FROM retail_sales_tb
WHERE sale_date = '2022-11-05';

-- Q2 write a sql query to retrieves all transactions where the category is "clothing"  and the quality sold is more thenis the amount of nov-2022
SELECT  *
FROM retail_sales_tb
WHERE category = 'Clothing'
AND
TO_CHAR(sale_date,'YYYY-MM')='2022-11'
AND 
quantiy >= 4

-- Q3.write a SQL query calculate the tota sales for each category
SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) AS total_transactions
FROM retail_sales_tb
GROUP BY 1;

--Q4 write a SQL query to find the average age of customers who purchased items from the beauty category

SELECT
	ROUND(AVG(age),2) AS avg_age
FROM retail_sales_tb
WHERE category = 'Beauty';

-- Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales_tb
WHERE total_sale >1000

-- Q6 Write a SQL query to find the total number of transactions(transaction id) made by each gender in each category.
SELECT 
	category,
	gender,
	COUNT(*) AS total_trans
FROM retail_sales_tb
GROUP BY 
	category,
	gender
ORDER BY 1

-- Q7 Write a SQL query to calculate the average sale for each month find out best selling month in each year

SELECT 
	   YEAR,
	   MONTH,
FROM  
(
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_total_sale,
	RANK() OVER(PARTITION BY  EXTRACT(YEAR FROM sale_date)ORDER BY  AVG(total_sale) DESC)AS RANK
FROM retail_sales_tb
GROUP BY 1, 2
)AS T1
WHERE RANK = 1
--ORDER BY 1, 2, 3 DESC ;

-- write a SQL query to find the top 5 customers based on the highest total sale

SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales_tb
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5;
	
-- Q.9 Write a query to find the number of unique customers who purchased items from each category .


SELECT
	category,
	COUNT(DISTINCT customer_id) AS cs_unique_cs
FROM retail_sales_tb
GROUP BY category

-- 10 Write a query to create each shift and number of orders(example morning <>12)after noon between 12&17,evening >17
WITH hourly_sales
AS
(
SELECT*,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'morning'
		WHEN EXTRACT(HOUR FROM sale_time)BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'evening'
	END AS shift
FROM retail_sales_tb
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sales
GROUP BY shift
	
-- END OF THE PROJECT--