
CREATE OR REPLACE PROCEDURE silver.create_silver_tables()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time   TIMESTAMP;
    v_duration   INTERVAL;
BEGIN
	-- TRY BLOCK
	BEGIN
	
        v_start_time := clock_timestamp();
		-- create relation data base from table silver.sales 
		-- customers table
		RAISE NOTICE '[DROP] silver.customers Table ...!  ';
		DROP TABLE IF EXISTS silver.customers CASCADE;
		RAISE NOTICE '[CREATE] silver.customers Table ...';
		
		CREATE TABLE silver.customers (
		    customer_id VARCHAR(10) PRIMARY KEY,
		    customer_name VARCHAR(100),
		    email VARCHAR(200),
		    phone VARCHAR(30),
		    city VARCHAR(50),
		    country VARCHAR(100)
		);
		-- products table
		RAISE NOTICE '[DROP] silver.products Table ...!  ';
		DROP TABLE IF EXISTS silver.products CASCADE;
		RAISE NOTICE '[CREATE] silver.products Table ...';
		CREATE TABLE silver.products (
		    product_id VARCHAR(10) PRIMARY KEY,
		    product_name VARCHAR(100),
		    category VARCHAR(100),
		    supplier VARCHAR(100),
		    unit_price DECIMAL(10,2)
		);
		
		-- create Employees table
		RAISE NOTICE '[DROP] silver.employees Table ...!  ';
		DROP TABLE IF EXISTS silver.employees CASCADE;
		RAISE NOTICE '[CREATE] silver.employees Table ...';
		CREATE TABLE silver.employees (
		    employee_id VARCHAR(10) PRIMARY KEY,
		    employee_name VARCHAR(50)
		);
		
		-- create payment_method table
		RAISE NOTICE '[DROP] silver.payment_methods Table ...!  ';
		DROP TABLE IF EXISTS silver.payment_method CASCADE;
		RAISE NOTICE '[CREATE] silver.payment_methods Table ...';
		CREATE TABLE silver.payment_methods (
		    payment_method_id serial PRIMARY KEY,
		    payment_method VARCHAR(20) UNIQUE
		);
		
		-- create orders table
		RAISE NOTICE '[DROP] silver.orders Table ...!  ';
		DROP TABLE IF EXISTS silver.orders CASCADE;
		RAISE NOTICE '[CREATE] silver.orders Table ...';
		CREATE TABLE silver.orders (
		    order_id INT PRIMARY KEY,
		    order_date DATE,
		    customer_id VARCHAR(10),
		    employee_id VARCHAR(10),
		    payment_method_id INT,
		    status VARCHAR(30),
		
		    FOREIGN KEY (customer_id)
		        REFERENCES silver.customers(customer_id),
		
		    FOREIGN KEY (employee_id)
		        REFERENCES silver.employees(employee_id),
		
		    FOREIGN KEY (payment_method_id)
		        REFERENCES silver.payment_methods(payment_method_id)
		);
		
		-- create order_details table
		RAISE NOTICE '[DROP] silver.order-details Table ...!  ';
		DROP TABLE IF EXISTS silver.order_details CASCADE;
		RAISE NOTICE '[CREATE] silver.order_details Table ...';
		CREATE TABLE silver.order_details (
		    order_id INT,
		    product_id VARCHAR(10),
		    quantity INT,
		    unit_price DECIMAL(10,2),
		    discount DECIMAL(8,2),
		
		    PRIMARY KEY (order_id, product_id),
		
		    FOREIGN KEY (order_id)
		        REFERENCES silver.orders(order_id),
		
		    FOREIGN KEY (product_id)
		        REFERENCES silver.products(product_id)
		);
		v_end_time := clock_timestamp(); 
		-- Calculate duration
        v_duration := v_end_time - v_start_time;
		RAISE NOTICE 'Load started at : %', v_start_time;
        RAISE NOTICE 'Load ended at   : %', v_end_time;
        RAISE NOTICE 'Duration        : %', v_duration;
	-- CATCH BLOCK
	 EXCEPTION
	      WHEN OTHERS THEN
	 	     RAISE NOTICE 'Error: Cannot CREATE SLIVER LAYER ...!';
	 END;	 		
END; $$;
CALL silver.create_silver_tables();