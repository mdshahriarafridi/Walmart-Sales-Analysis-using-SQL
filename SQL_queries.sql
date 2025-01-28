create database if not exists salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


-- Feature Engineering --

-- time_of_day
select
	time,
    (case
		when 'time' between "00:00:00" and "12:00:00" then "Morning"
        when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end
    ) as time_of_date
from sales;
    
alter table sales add column time_of_day varchar(20);

UPDATE sales
SET time_of_day = (
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time > '12:00:00' AND time <= '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

-- day_name
select
	date, dayname(date)
from sales;

alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);

-- month name

select date, monthname(date)
from sales;

alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date);

-- ----------------------------------------------

-- Generic Questions --

-- 1. How many unique cities does the data have?

select distinct city
from sales;

-- 2. In which city is each branch?

select distinct city,branch
from sales;

-- Product Questions --

-- 1. How many unique product lines does the data have?

select distinct product_line
from sales;

-- 2. What is the most common payment method?

select payment, count(payment) as cnt
from sales
group by payment
order by cnt desc;


-- 3. What is the most selling product line?

select 
	product_line, 
	count(product_line)
from sales
group by product_line
order by count(product_line) desc;

-- 4. What is the total revenue by month?
select 
	month_name as Month,
    sum(total) as total_Revenue
from sales
group by month_name
order by total_Revenue desc;

-- 5. What month had the largest COGS?

select 
	month_name as month,
    sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

-- 6. What product line had the largest revenue?

SELECT
    product_line, 
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- 7. What is the city with the largest revenue?

select 
	city,
    branch,
    sum(total) as total_revenue
from sales
group by city,branch
order by total_revenue desc;

-- 8. What product line had the largest VAT?

select 
	product_line,
    avg(tax_pct) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- 10. Which branch sold more products than average product sold?

select 
	branch,
    sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- 11. What is the most common product line by gender?

select
	gender,
    product_line,
    count(gender) as Total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

-- 12. What is the average rating of each product line?

select 
	product_line,
    round(avg(rating),2) as Average_Rating
from sales
group by product_line
order by Average_Rating desc;


-- Sales Questions --

-- 1. Number of sales made in each time of the day per weekday

select 
	time_of_day,
    
    count(total) as total_sales
from sales
group by time_of_day
order by total_sales desc;

-- 2. Which of the customer types brings the most revenue?

select 
	customer_type,
    round(sum(total),2) as Total_Revenue
from sales
group by customer_type
order by Total_Revenue desc;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?

select
	city,
    round(avg(tax_pct),2) as Avg_Tax
from sales
group by city
order by Avg_Tax desc;

-- 3. Which customer type pays the most in VAT?

select 
	customer_type,
    round(avg(tax_pct),2) as Avg_Tax
from sales
group by customer_type
order by Avg_Tax desc;


-- Customer Questions --

-- 1. How many unique customer types does the data have?

select distinct
	customer_type,
    count(customer_type) as Unique_Customers
from sales
group by customer_type
order by Unique_Customers desc;

-- 2. How many unique payment methods does the data have?

select distinct	
	payment,
    count(payment) as No_of_Payments
from sales
group by payment
order by No_of_Payments desc;

-- 3. What is the most common customer type?
-- 4. Which customer type buys the most?

select 
	customer_type as Most_common_customer_type,
    count(customer_type) as No_of_customers
from sales
group by customer_type
order by No_of_customers desc;

-- 5. What is the gender of most of the customers?

select 
	gender,
    count(customer_type) as No_of_customers
from sales
group by gender
order by No_of_customers desc;

-- 6. What is the gender distribution of branch A ?

select 
	gender,
    count(customer_type) as No_of_customers
from sales
where branch = "A"
group by gender
order by No_of_customers desc;

-- 7. Which time of the day do customers give most ratings?

select 
	time_of_day,
    round(avg(rating),2) as Most_Rating
from sales
group by time_of_day
order by Most_Rating desc;

-- 8. Which time of the day do customers give most ratings per branch?

select 
	time_of_day,
    round(avg(rating),2) as Most_Rating
from sales
group by time_of_day
order by Most_Rating desc;


-- 9. Which day fo the week has the best avg ratings?

select 
	day_name,
    round(avg(rating),2) as Most_Rating
from sales
group by day_name
order by Most_Rating desc;

-- 10. Which day of the week has the best average ratings for branch A?

select 
	day_name,
    round(avg(rating),2) as Average_Rating
from sales
where branch = "A"
group by day_name
order by Average_Rating;
























































