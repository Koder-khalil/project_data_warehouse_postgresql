-- Exploratory Data Analysis EDA

select * from gold.fact_sales;

-- Profile metric distributions
SELECT 
    MIN(sales_amount) AS min_sale,
    MAX(sales_amount) AS max_sale,
    ROUND(AVG(sales_amount),2) AS avg_sale_value,
    ROUND(STDDEV(sales_amount),2) AS revenue_variability,
    SUM(sales_amount) AS total_historical_revenue
FROM gold.fact_sales;



    -- Analyze performance metrics grouped by category
SELECT 
    gdp.category,
    COUNT(gfs.order_id) AS order_volume,
    SUM(gfs.quantity) AS units_sold,
    SUM(gfs.sales_amount) AS total_revenue,
    ROUND(AVG(gfs.sales_amount),2) AS average_order_value
FROM gold.dim_products as gdp
left join gold.fact_sales as gfs
on gdp.product_key = gfs.product_key
GROUP BY gdp.category
ORDER BY total_revenue DESC;


-- Extract monthly trend performance parameters

SELECT 
    gdd.year AS sales_year,
    gdd.month AS sales_month,
    COUNT(gfs.order_id) AS order_count,
    SUM(gfs.sales_amount) AS monthly_revenue
FROM gold.fact_sales as gfs
left join gold.dim_dates as gdd
on gfs.date_key = gdd.date_key
GROUP BY 1, 2
ORDER BY sales_year DESC, sales_month ASC;

-- Identify highest spending customer groups

SELECT 
    gdc.customer_id,
	gdc.city,
	gdc.country,
    COUNT(gfs.order_id) AS visit_frequency,
    SUM(sales_amount) AS total_customer_spend,
    ROUND(AVG(sales_amount),2) AS average_basket_spend
FROM gold.fact_sales as gfs
left join gold.dim_customers as gdc
on gfs.customer_key = gdc.customer_key
GROUP BY 1,2,3
ORDER BY total_customer_spend DESC
LIMIT 10;





  

