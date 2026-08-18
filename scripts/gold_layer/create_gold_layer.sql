CREATE OR REPLACE PROCEDURE gold.load_gold()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time   TIMESTAMP;
    v_duration   INTERVAL;
BEGIN

    BEGIN
            v_start_time := clock_timestamp();
			-- Create Gold schema
			RAISE NOTICE '[CREATE] SCHEMA gold layer ...!';
			CREATE SCHEMA IF NOT EXISTS gold;
			
			RAISE NOTICE '[DROP] gold.dim_customers ...!';
			DROP VIEW IF EXISTS gold.dim_customers CASCADE;
			RAISE NOTICE '[CREATE] VIEW gold.dim_customers';
			
			CREATE VIEW gold.dim_customers AS
			SELECT 
				ROW_NUMBER() OVER(ORDER BY customer_id) as customer_key,
				customer_id,
				customer_name,
				email,
				phone,
				city,
				country
			FROM silver.customers;
			
			RAISE NOTICE '[DROP] gold.dim_products ...!';
			DROP VIEW IF EXISTS gold.dim_products CASCADE;
			RAISE NOTICE '[CREATE] VIEW gold.dim_products';
			
			CREATE VIEW gold.dim_products AS
			SELECT
				ROW_NUMBER() OVER(ORDER BY product_id) as product_key,
				product_id,
				product_name,
				category,
				supplier,
				unit_price
			FROM silver.products;
			
			RAISE NOTICE '[DROP] gold.dim_employees ...!';
			DROP VIEW IF EXISTS gold.dim_employees CASCADE;
			RAISE NOTICE '[CREATE] VIEW gold.dim_employees';
			
			CREATE VIEW gold.dim_employees AS
			SELECT
				ROW_NUMBER() OVER(ORDER BY employee_id) as employee_key,
				employee_id,
				employee_name
			FROM silver.employees;
			
			RAISE NOTICE '[DROP] gold.dim_payment_methods ...!';
			DROP VIEW IF EXISTS gold.dim_payment_methods CASCADE;
			RAISE NOTICE '[CREATE] VIEW gold.dim_payment_methods';
			
			CREATE VIEW gold.dim_payment_methods AS
			SELECT 
			    ROW_NUMBER() OVER(ORDER BY payment_method_id) as payment_method_key,
				payment_method_id,
				payment_method
			FROM silver.payment_methods;

			RAISE NOTICE '[DROP] gold.dim_dates ...!';
			DROP VIEW IF EXISTS gold.dim_dates CASCADE;
			RAISE NOTICE '[CREATE] VIEW gold.dim_dates';
			
			CREATE VIEW gold.dim_dates AS
			SELECT
			    TO_CHAR(d, 'YYYYMMDD')::INT AS date_key,
			    d::DATE AS full_date,
			    EXTRACT(DAY FROM d)::INT AS day,
			    EXTRACT(MONTH FROM d)::INT AS month,
			    TO_CHAR(d, 'Month') AS month_name,
			    EXTRACT(QUARTER FROM d)::INT AS quarter,
			    EXTRACT(YEAR FROM d)::INT AS year,
			    EXTRACT(ISODOW FROM d)::INT AS day_of_week,
			    TO_CHAR(d, 'Day') AS day_name,
			    EXTRACT(WEEK FROM d)::INT AS week_of_year,
			    EXTRACT(ISODOW FROM d) IN (6, 7) AS is_weekend
			FROM generate_series(
			    '2020-01-01'::DATE,
			    '2030-12-31'::DATE,
			    INTERVAL '1 day'
			) AS d;
			
			
			
			RAISE NOTICE '[DROP] gold.dim_orders...!';
			DROP VIEW IF EXISTS gold.fact_sales CASCADE;
			RAISE NOTICE '[CREATE] VIEW gold.fact_sales';
			
			CREATE VIEW gold.fact_sales AS
			SELECT
			    o.order_id,
			
			    TO_CHAR(o.order_date, 'YYYYMMDD')::INT AS date_key,
			
			    c.customer_key,
			    p.product_key,
			    e.employee_key,
			    pm.payment_method_key,
			
			    od.quantity,
			    od.unit_price,
			    od.discount,
			
			    (od.quantity * od.unit_price) - od.discount AS sales_amount
			
			FROM silver.orders AS o
			
			INNER JOIN silver.order_details AS od
			    ON o.order_id = od.order_id
			
			INNER JOIN gold.dim_customers AS c
			    ON o.customer_id = c.customer_id
			
			INNER JOIN gold.dim_products AS p
			    ON od.product_id = p.product_id
			
			INNER JOIN gold.dim_employees AS e
			    ON o.employee_id = e.employee_id
			
			INNER JOIN gold.dim_payment_methods AS pm
			    ON o.payment_method_id = pm.payment_method_id;
        v_end_time := clock_timestamp();
        v_duration := v_end_time - v_start_time;
        RAISE NOTICE '[TIME] silver.order_details: %', v_duration;
    EXCEPTION
		        WHEN OTHERS THEN
		            RAISE NOTICE 'Error: Cannot LOADING DATA TO SILVER LAYER!';
		            RAISE NOTICE 'SQLSTATE: %', SQLSTATE;
		            RAISE NOTICE 'Error message: %', SQLERRM;
		            RAISE;
		    END;

END;
$$;

call gold.load_gold();

