/*
======================================================================
                     CREATE STORED PROCEDURE FOR THR LOAD
======================================================================

Script Purpose:
---------------
This script load the data to the bronze layer.

- creating the database stored procedure for bronze
/*

create or alter procedure bronze.load_bronze as

begin

   Declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
  
  begin try

  set @batch_start_time = getdate();

print '============================================';
print 'Loading data to bronze';
print '============================================';

print '>>LOADING CRM TABLES';
set @start_time = getdate();
print '--------------------------------------------';

print 'truncating table: Bronze.crm_customer_info';
print '--------------------------------------------';
   truncate table Bronze.crm_customer_info;
print 'inserting data to : Bronze.crm_customer_info'; 
   bulk insert Bronze.crm_customer_info
   from 'C:\temp\cust_info.csv'
   with (
       firstrow = 2,
       fieldterminator = ',' ,
       tablock
);
set @end_time = getdate();
print '>>>Load duration' + cast (datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
print '--------------------------------------------';

set @start_time = getdate();

print 'truncating table: Bronze.crm_prd_info';
print '--------------------------------------------';
   truncate table Bronze.crm_prd_info;
print 'inserting data to : Bronze.crm_prd_info';
   bulk insert Bronze.crm_prd_info
   from 'C:\temp\prd_info.csv'
   with (
       firstrow = 2,
       fieldterminator = ',' ,
       tablock
);
set @end_time = getdate();
print '>>>Load duration' + cast (datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
print '--------------------------------------------';

set @start_time = getdate();

print 'truncating table: Bronze.crm_sales_details';
print '--------------------------------------------';
   truncate table Bronze.crm_sales_details;
print 'inserting data to : Bronze.crm_sales_details';
   bulk insert Bronze.crm_sales_details
   from 'C:\temp\sales_details.csv'
   with (
       firstrow = 2,
       fieldterminator = ',' ,
       tablock
);
set @end_time = getdate();
print '>>>Load duration' + cast (datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';

print '>>LOADING ERP TABLES';
print '--------------------------------------------';

set @start_time = getdate();

print 'truncating table: Bronze.erp_cust_dtls';
print '--------------------------------------------';
   truncate table Bronze.erp_cust_dtls;
print 'inserting data to : Bronze.erp_cust_dtls';
   bulk insert Bronze.erp_cust_dtls
   from 'C:\temp\erp\CUST_AZ12.csv'
   with (
       firstrow = 2,
       fieldterminator = ',' ,
       tablock
);
set @end_time = getdate();
print '>>>Load duration' + cast (datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
print '--------------------------------------------';

set @start_time = getdate();

print 'truncating table: Bronze.erp_locl_a1';
print '--------------------------------------------';
   truncate table Bronze.erp_locl_a1;
print 'inserting data to : Bronze.erp_locl_a1';
   bulk insert Bronze.erp_locl_a1
   from 'C:\temp\erp\LOC_A101.csv'
   with (
       firstrow = 2,
       fieldterminator = ',' ,
       tablock
);
set @end_time = getdate();
print '>>>Load duration' + cast (datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
print '--------------------------------------------';

set @start_time = getdate();

print 'truncating table: Bronze.erp_px_cat';
print '--------------------------------------------';
   truncate table Bronze.erp_px_cat;
print 'inserting data to : Bronze.erp_px_cat';
   bulk insert Bronze.erp_px_cat
   from 'C:\temp\erp\PX_CAT_G1V2.csv'
   with (
       firstrow = 2,
       fieldterminator = ',' ,
       tablock
);
set @end_time = getdate();
print '>>>Load duration' + cast (datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';

set @batch_end_time = getdate();
print '--------------------------------------------------';
print 'Loading bronze layer is completed';
print '>>>Load duration' + cast (datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + 'seconds';
print '--------------------------------------------------';

end try

   begin catch

print '==================================================';
print 'Error occured during the bronze layer';
print 'Error message' + ERROR_MESSAGE();
print 'Error message' + cast (ERROR_NUMBER() as varchar);
print 'Error message' + cast (ERROR_STATE() as varchar);
print '==================================================';

   end catch

end
