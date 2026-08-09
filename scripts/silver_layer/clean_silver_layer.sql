select * from silver.sales limit 100;

-- Check data in sales table 
-- check duplicates order_id
SELECT order_id,
       count(*)
FROM silver.sales
GROUP BY order_id
HAVING count(*)>1 ;
select count(order_id) 
from silver.sales 
where order_id is null
-- No duplicates and no nulls
-- check customer_name 
select count(*)
from silver.sales 
where length(customer_name) != length(trim(customer_name));
-- check email 
select count(*) 
from silver.sales 
where email is null;
-- email is null = 3016
-- Correct email is null to 'Unknown'
update silver.sales 
set email= 'Unknown'
where email is null ;

-- check phone remove non numric character
UPDATE silver.sales 
SET phone = regexp_replace(phone, '[^0-9]', '', 'g');

-- ceck city column 
select count(*)
from silver.sales
where city is null;
-- city is null 1530 
-- replace null use country in same table with max country 
UPDATE silver.sales ss
SET city = m.max_city
FROM (
    SELECT country, MAX(city) AS max_city
    FROM silver.sales
    WHERE city IS NOT NULL
    GROUP BY country
) m
WHERE ss.country = m.country
  AND ss.city IS NULL;

--   check country 
select count(*)
from silver.sales 
where country is null; 

select count(*)
from silver.sales 
where country != trim(country); 

-- check product_name 

select count(*)
from silver.sales 
where product_name is null; 

select count(*)
from silver.sales 
where product_name != trim(product_name); 

select  distinct(product_name)
from silver.sales;

-- check category 
select distinct(category)
from silver.sales; 
-- same name electronics and Electronics
update silver.sales
set category = initcap(category)


select count(*)
from silver.sales 
where category != trim(category);

-- 
select * from silver.sales limit 100;

select quantity from silver.sales where quantity<0; 

select unit_price from silver.sales where unit_price <0;

update silver.sales
set unit_price = -(unit_price) where unit_price <0;

-- supplier
select distinct supplier from silver.sales;
-- payment method 
select distinct payment_method from silver.sales;

-- status 
select distinct status from silver.sales;

