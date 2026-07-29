/*
======================================================================
                     CREATING THE TABLES
======================================================================

Script Purpose:
---------------
This script creates all the tables that needed for this project with declaring the data type.

- creating the tables for bronze layer:
*/

create table bronze.crm_customer_info (
   cust_id int,
   cust_key NVARCHAR(50),
   cust_firstname NVARCHAR(50),
   cust_lastname NVARCHAR(50),
   cust_marital_status NVARCHAR(50),
   cust_gndr NVARCHAR(50),
   cust_create_date NVARCHAR(50)
);

create table bronze.crm_prd_info (
   prd_id int,
   prd_key NVARCHAR(50),
   prd_nm NVARCHAR(50),
   prd_cost int,
   prd_line NVARCHAR(50),
   prd_start_dt datetime,
   prd_end_dt datetime
)

create table bronze.crm_sales_details (
   sls_ord_num NVARCHAR(50),
   sls_prd_key NVARCHAR(50),
   sls_cust_id int,
   sls_order_dt int,
   sls_ship_dt int,
   sls_due_dt int,
   sls_sales int,
   sls_quantity int,
   sls_price int
)

create table bronze.erp_cust_dtls (
   CID NVARCHAR(50),
   BDATE date,
   GEN NVARCHAR(50)
)

create table bronze.erp_locl_a1 (
   cid NVARCHAR(50),
   centry NVARCHAR(50)
)

create table bronze.erp_px_cat (
   ID NVARCHAR(50),
   CAT NVARCHAR(50),
   SUBCAT NVARCHAR(50),
   MAINTENANCE NVARCHAR(50)
)
