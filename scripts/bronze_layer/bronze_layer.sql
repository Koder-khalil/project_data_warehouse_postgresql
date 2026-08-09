create table bronze.sales ( order_id int 
					 ,order_date date 
                    ,customer_id varchar(10)
                    ,customer_name varchar(100)
					,email varchar(200)
                    ,phone varchar(30)
                    ,city varchar(50)
                    ,country varchar(100)
                    ,product_id varchar(10)
                    ,product_name varchar(100)
                    ,category varchar(100)
                    ,supplier varchar(100)
                    ,unit_price decimal(10,2)
                    ,quantity int
                    ,employee_id varchar(10)
                    ,employee_name varchar(50)
                    ,payment_method varchar(20)
                    ,discount decimal(8,2)
                    ,status varchar(30)
);

CREATE OR REPLACE PROCEDURE bronze.load_data_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time   TIMESTAMP;
    v_duration   INTERVAL;
BEGIN
     -- try block
	 BEGIN
     	TRUNCATE TABLE bronze.sales;
        v_start_time := clock_timestamp();
     	COPY bronze.sales
     	FROM 'E:\data engineer\project_ETL\sales_dataset.csv' 
    	DELIMITER ',' 
     	CSV HEADER;
		-- End time
        v_end_time := clock_timestamp(); 
		-- Calculate duration
        v_duration := v_end_time - v_start_time;
		RAISE NOTICE 'Load started at : %', v_start_time;
        RAISE NOTICE 'Load ended at   : %', v_end_time;
        RAISE NOTICE 'Duration        : %', v_duration;
	 -- CATCH BLOCK
	 EXCEPTION
	      WHEN OTHERS THEN
	 	     RAISE NOTICE 'Error: Cannot LOAD Data TO BRONZE LAYER ...!';
	 END;	 
END;$$;




call bronze.load_data_bronze();



