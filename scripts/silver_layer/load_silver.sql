CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time   TIMESTAMP;
    v_duration   INTERVAL;
BEGIN

    BEGIN
        

        -- Customers
		v_start_time := clock_timestamp();
        RAISE NOTICE '[TRUNCATE] silver.customers Table ...!';
        TRUNCATE TABLE silver.customers CASCADE;

        RAISE NOTICE '[LOADING] Data to silver.customers Table ...';
        INSERT INTO silver.customers
			SELECT 
				customer_id,
			    Customer_name,
			    email,
			    phone,
			    city,
			    country
			FROM  (
			    SELECT 
				      customer_id,
			          Customer_name,
			          case 
					      when email is null then 'Unknown'
						  else email
					  end as email,
			          phone,
			          city,
			          country,
			           ROW_NUMBER() OVER (
			               PARTITION BY customer_id
			               ORDER BY order_date
			           ) AS rn
			    FROM silver.sales
			) t
			WHERE rn = 1;
		v_end_time := clock_timestamp();
        v_duration := v_end_time - v_start_time;
        RAISE NOTICE '[TIME] silver.customers: %', v_duration;

        -- Products
		v_start_time := clock_timestamp();
        RAISE NOTICE '[TRUNCATE] silver.products Table ...!';
        TRUNCATE TABLE silver.products CASCADE;

        RAISE NOTICE '[LOADING] Data to silver.products Table ...';
		INSERT INTO silver.products
		SELECT 
		    product_id,
		    product_name,
		    category,
		    supplier,
		    unit_price
		FROM  (
		    SELECT *,
		           ROW_NUMBER() OVER (
		               PARTITION BY product_id
		               ORDER BY order_id
		           ) AS rn
		    FROM silver.sales
		) t
		WHERE rn = 1;
        v_end_time := clock_timestamp();
        v_duration := v_end_time - v_start_time;
        RAISE NOTICE '[TIME] silver.customers: %', v_duration;
        -- Employees
		v_start_time := clock_timestamp();
        RAISE NOTICE '[TRUNCATE] silver.employees Table ...!';
        TRUNCATE TABLE silver.employees CASCADE;

        RAISE NOTICE '[LOADING] Data to silver.employees Table ...';
        INSERT INTO silver.employees
		SELECT DISTINCT
		    employee_id,
		    employee_name
		FROM  (
		    SELECT *,
		           ROW_NUMBER() OVER (
		               PARTITION BY employee_id
		               ORDER BY order_id
		           ) AS rn
		    FROM silver.sales
		) t
		WHERE rn = 1;
        v_end_time := clock_timestamp();
        v_duration := v_end_time - v_start_time;
        RAISE NOTICE '[TIME] silver.customers: %', v_duration;
        -- Payment Methods
	    v_start_time := clock_timestamp();
        RAISE NOTICE '[TRUNCATE] silver.payment_methods Table ...!';
        TRUNCATE TABLE silver.payment_methods CASCADE;

        RAISE NOTICE '[LOADING] DATA TO  silver.payment_methods Table ...';
		INSERT INTO silver.payment_methods (payment_method_id, payment_method)
		SELECT
		    ROW_NUMBER() OVER (ORDER BY payment_method),
		    payment_method
		FROM (
		    SELECT DISTINCT payment_method
		    FROM silver.sales
		    WHERE payment_method IS NOT NULL
		) t;
		v_end_time := clock_timestamp();
        v_duration := v_end_time - v_start_time;
        RAISE NOTICE '[TIME] silver.customers: %', v_duration;

        -- Orders
		v_start_time := clock_timestamp();
        RAISE NOTICE '[TRUNCATE] silver.orders Table ...!';
        TRUNCATE TABLE silver.orders CASCADE;

        RAISE NOTICE '[LOADING] DATA TO silver.orders Table ...';
        INSERT INTO silver.orders (
			     order_id,
			    order_date,
			    customer_id,
			    employee_id,
			    payment_method_id,
			    status
			)
			SELECT 
			    order_id,
			    order_date,
			    customer_id,
			    employee_id,
			    payment_method_id,
			    status
			FROM  (
			    SELECT
			        s.order_id,
			        s.order_date,
			        s.customer_id,
			        s.employee_id,
			        pm.payment_method_id,
			        s.status,
			        ROW_NUMBER() OVER (
			            PARTITION BY s.order_id
			            ORDER BY s.order_date
			        ) AS rn
			    FROM silver.sales s
			    JOIN silver.payment_methods pm
			        ON s.payment_method = pm.payment_method
			) x
			WHERE rn = 1;

		v_end_time := clock_timestamp();
        v_duration := v_end_time - v_start_time;
        RAISE NOTICE '[TIME] silver.customers: %', v_duration; 
        -- Order Details
		v_start_time := clock_timestamp();
        RAISE NOTICE '[TRUNCATE] silver.order_details Table ...!';
        TRUNCATE TABLE silver.order_details CASCADE;

        RAISE NOTICE '[LOADING] DATA TO silver.order_details Table ...';
        INSERT INTO silver.order_details
			SELECT
			    order_id,
			    product_id,
			    quantity,
			    unit_price,
			    discount
			FROM (
			    SELECT *,
			           ROW_NUMBER() OVER (
			               PARTITION BY order_id
			               ORDER BY order_date
			           ) AS rn
			    FROM silver.sales
			) t
			WHERE rn = 1;

        v_end_time := clock_timestamp();
        v_duration := v_end_time - v_start_time;
        RAISE NOTICE '[TIME] silver.customers: %', v_duration;


    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error: Cannot LOADING DATA TO SILVER LAYER!';
            RAISE NOTICE 'SQLSTATE: %', SQLSTATE;
            RAISE NOTICE 'Error message: %', SQLERRM;
            RAISE;
    END;

END;
$$;

CALL silver.load_silver();