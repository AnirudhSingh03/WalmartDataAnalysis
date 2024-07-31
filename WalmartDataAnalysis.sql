create database WalmartSalesData;
use WalmartSalesData;
create table sales(
    invoice_id varchar(40) not null primary key,
    branch varchar(10) not null,
    city varchar(40) not null,
    customer_type varchar(40) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT float(6,4) not null,
    total decimal(12,4) not null,
    date datetime not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs decimal(10,2) not null,
    cogs_margin_pct float(11,9),
    gross_income decimal(12,4) not null,
    rating float(2,1)
);
-- -----------------------------------------------------------------------
-- -----------------------Feature Engineering-----------------------------
select time,(case 
             when time between "00:00:00" and "12:00:00"then "Morning"
             when time between "12:00:01" and "16:00:00"then "Afternoon"
             else "Evening"
             end) as time_of_date
 from sales;
 alter table sales add column time_of_day varchar(20);

update sales set time_of_day=(case 
             when time between "00:00:00" and "12:00:00"then "Morning"
             when time between "12:00:01" and "16:00:00"then "Afternoon"
             else "Evening"
             end
);
-- day name
select date,dayname(date) as day_name from sales;

alter table sales add column day_name varchar(10);

update sales set day_name=dayname(date)

-- Month name

select date ,monthname(date) as month_name from sales;

alter table sales add column month_name varchar(10);

update sales set month_name =monthname(date)
-- -------------------------------------------------- 

-- ------------------ Generic Question-----------------
-- How many unique cities does the data have?

select distinct city from sales;

-- In which city is each branch?
select distinct branch from sales;

select distinct city,branch from sales;
-- ------------------Product Questions---------------------------
-- How many unique product lines does data have?
select count(distinct product_line) from sales;

-- What is the most common payment method?
select payment_method,count(payment_method) as count 
from sales group by payment_method order by count desc;

-- What is the most selling product line?
select product_line,count(product_line) as count from sales 
group by product_line order by count desc;

-- What is the total revenue by month?
select month_name,sum(total) as total_revenue from sales 
group by month_name order by total_revenue desc;

-- What month has largest cogs?
select month_name as month ,sum(cogs) as cogs 
from sales 
group by month_name
order by cogs desc;

-- What product line had the largest revenue?

select product_line,sum(total) as total_revenue 
from sales group by product_line order by total_revenue desc;

-- What is the city with the largest revenue?

select city,sum(total) as total_revenue 
from sales group by city order by total_revenue desc;

-- What product line had largest revenue?
select product_line,avg(vat) as avg_tax
from sales group by product_line order by avg_tax desc; 

-- Fetch each product line and add a column to those product line 
-- showing "Good","Bad".Good if its greater than average sales.
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > ( SELECT 
	AVG(quantity)
FROM sales) THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;
 -- Which branch sold more products than average product sold?
 select branch,sum(quantity) as qty 
 from sales group by branch having(qty)>(
 select avg(quantity) from sales) ; 
 
-- What is the most common line product by gender?
select gender,product_line,count(*) as count 
from sales group by gender,product_line order by count desc;

-- What is the average rating of each product line?

select product_line,avg(rating) as average_rating 
from sales group by product_line order by average_rating desc;
-- -----------------------------------------------------------------------
-- ------------------ Sales Question ---------------------------------

-- Number of sales made in each time of the day per weekday
select time_of_day,count(time_of_day) as count 
from sales where day_name="sunday" group by time_of_day 
order by count desc;

-- Which of the customer types brings the most revenue?

select customer_type,sum(total) as total_revenue 
from sales group by customer_type order by total_revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city,avg(vat) as vat from sales group by city 
order by vat desc;

-- Which customer type pays the most in VAT?

select customer_type,avg(vat) as vat from sales 
group by customer_type order by vat desc;  

-- ---------------------------Customer Question--------------------------
-- How many unique customer types does the data have?

select distinct customer_type from sales;

-- How many unique payment methods does the data have?

select distinct payment_method from sales;

-- What is the most common customer type?

select customer_type,count(customer_type) as count from sales 
group by customer_type order by count desc; 

-- Which customer type buys the most?
select customer_type,avg(quantity) as quantity from sales 
group by customer_type order by quantity desc;

-- What is the gender of most of the customers?

select gender,count(gender) as count 
from sales group by gender order by count desc;

-- What is the gender distribution per branch?

select gender,count(*) as count from sales where branch="A"
group by gender order by count desc; 

-- Which time of the day do customers give most ratings?
 select time_of_day,avg(rating) as rating from sales 
 group by time_of_day order by rating desc;
 
 -- Which time of the day do customers give most ratings per branch?
 
select time_of_day,avg(rating) as rating from sales 
where branch="C" group by time_of_day order by rating desc;

-- Which day of the week has the best avg ratings?
 select day_name,avg(rating) as rating from sales 
 group by day_name order by rating desc;

-- Which day of the week has the best average ratings per branch?
 select day_name,avg(rating) as rating from sales 
 where branch ="A" group by day_name order by rating desc;
 