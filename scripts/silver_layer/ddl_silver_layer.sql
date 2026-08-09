-- create schema silver layer
CREATE SCHEMA silver;

-- create table sales to transform data from bronze schems to silver schema 

create table if not exists silver.sales ( order_id int 
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

