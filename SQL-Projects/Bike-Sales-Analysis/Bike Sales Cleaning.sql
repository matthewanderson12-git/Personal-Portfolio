-- Fictional Global Bike Sales data set
-- This sheet will walk through the extent of my data cleaning, I have created a secondary table as a backup in case of errors

-- Quick Reference
SELECT * 
FROM bike_sales.bike_sales;

-- Changing Column Name To Be More Readible
alter table bike_sales
rename column `ï»¿Sales_Order #` to `Sales_Order`;

-- identify Duplicates bassed off Sales Order Number
select sales_order, count(sales_order)
from bike_sales
group by sales_order
having count(sales_order) > 1;

-- Using the previous query I've identified the following duplicates:'000261695', '000261701'
select * 
from bike_sales
where sales_order in('000261701');

-- After looking at the data itself '000261695' is a failure to index the id 
-- This is proven by unique values in all columns excpet 'Sales_Order'
-- Update the corresponding row to correct the indexing error
update bike_sales
set sales_order = '000261696'
where sales_order = '000261695' and customer_age = '44';

-- assigning as row number to the duplicate, in preparation for deletion
select *
from (select sales_order, date,
row_number() over(partition by sales_order order by date desc) as rn
from bike_sales) as row_table
where rn > 1;

-- With no real primary key between these two rows, i can't use a typical delete statement
# delete from bike_sales
# where sales_order in (select sales_order
# from (select sales_order, 
# row_number() over(partition by sales_order order by Date desc) as rn
# from bike_sales) as row_table
# where rn > 1);

-- I will implement a new 'id' column to auto increment the specfic sales orders in order to delete
-- This implements a new primary key column making deleting duplicates easy
alter table bike_sales add column id int auto_increment Primary Key;

-- Now we can utilze the row number logic we've outlined with our new column
delete from bike_sales
where id in(
select id
from (select id,
row_number() over(partition by sales_order order by date desc) as rn
from bike_sales) as row_table
where rn > 1);


-- Standardizing Data/Addressing Null Values
-- Going column by column to ensure consistent data formatting
select distinct age_group 
from bike_sales;

-- case statement  logic to replace null values in age_group column
select customer_age, age_group,
case
	when customer_age < 25 then 'Youth (<25)'
    when customer_age between 25 and 34 then 'Young Adults (25-34)'
    when customer_age between 35 and 64 then 'Adults (35-64)'
	else 'Senior (65+)'
end as age_new
from bike_sales;

-- implementing the case statement within Update statement
update bike_sales
set age_group = case
	when customer_age < 25 then 'Youth (<25)'
    when customer_age between 25 and 34 then 'Young Adults (25-34)'
    when customer_age between 35 and 64 then 'Adults (35-64)'
	else 'Senior (65+)'
end;

-- Saw that countries had leading spaces
select distinct country
from bike_sales;

select country, trim(country)
from bike_sales;

-- Utilized trim() function to remove space
update bike_sales
set country = trim(country);

select distinct Product_Description
from bike_sales;

-- case statement logic to replace null product_description
select product_description, unit_cost,
case
	when product_description = '' then 'Mountain-200 Black, 46'
    else product_description
end as new_desc
from bike_sales;

-- implemented logic within update statement
update bike_sales
set product_description = case
	when product_description = '' then 'Mountain-200 Black, 46'
    else product_description
end;

-- Notice there are zero values for unit_cost which need to be replaced
select distinct Unit_Cost
from bike_sales; 

-- Based on this query we can determine the only row with a blank value
-- Based on the Product_Description the unit cost is $1252
select *
from bike_sales
where unit_cost = '$0.00 ';

-- Before we can replace the null value and ultimatley preform calculations, 
-- we must convert the current string values: '$0.00 ' to a decimal value
select unit_cost, cast(replace(replace(unit_cost, "$", ''),',','') as decimal(10,2)) as unit_c,
cast(replace(replace(unit_price, "$", ''),',','') as decimal(10,2)) as unit_p
from bike_sales;

-- Creating those conversions within the table
update bike_sales
set unit_cost = cast(replace(replace(unit_cost, "$", ''),',','') as decimal(10,2));

update bike_sales 
set Unit_Price = cast(replace(replace(Unit_Price, "$", ''),',','') as decimal(10,2));

-- Now that the conversions have taken place we will address remaining null values that could impact calculations
select * 
from bike_sales
where Unit_Cost = '0.00';

-- Case statement logic to replace null values
select product_description,unit_cost,
case
	when unit_cost = '0.00' and Product_Description = 'Mountain-200 Black, 46' then '1252.00'
	else unit_cost
end as new_cost
from bike_sales;

-- Implementing logic in update statement
update bike_sales
set unit_cost = case
	when unit_cost = '0.00' and Product_Description = 'Mountain-200 Black, 46' then '1252.00'
	else unit_cost
end;

-- Identify null unit_price values
-- based off product description I can identify the unit price as 
select * 
from bike_sales
where Unit_Price = '0.00';

-- Case statement logic to address null unit price values
select product_description,unit_price,
case
	when unit_price = '0.00' and Product_Description = 'Mountain-400-W Silver, 42' then '769.00'
	else unit_price
end as new_price
from bike_sales;

-- Implementing logic in update statement
update bike_sales
set unit_price = case
	when unit_price = '0.00' and Product_Description = 'Mountain-400-W Silver, 42' then '769.00'
	else unit_price
end;

-- Reference Point
select * 
from bike_sales;

-- calculations
update bike_sales
set cost = cast(Order_Quantity*Unit_Cost as decimal(10,2));

update bike_sales
set Revenue = cast(Order_Quantity*Unit_Price as decimal(10,2));

update bike_sales
set Profit = cast(Revenue-cost as decimal(10,2));

-- Deleting columns that hold unnecessary information
-- the following columns and their respective information can be returned more effectively
-- by using functions like Day(), Month() and Year() we can utilze the date column to pull 
-- the correspnding information without having to store it
alter table bike_sales
drop column Day;

alter table bike_sales
drop column Month;

alter table bike_sales
drop column Year;

-- Reference Point
select * 
from bike_sales;