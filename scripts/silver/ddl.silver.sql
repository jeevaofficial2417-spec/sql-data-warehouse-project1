-- silver data transformation and cleansing


	create or alter procedure silver.load_silver as

	begin

		Declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;

	begin try

	set @batch_start_time = getdate();

	set @start_time = getdate();
	print '--------------------------------------------';

-- truncating data from silver.crm_customer_info

print '>> truncating data from silver.crm_customer_info'
print '------------------------------------------------'
	truncate table silver.crm_customer_info;

-- inserting data to silver.crm_customer_info

	insert into silver.crm_customer_info (
	cust_id,
	cust_key,
	cust_firstname,
	cust_lastname,
	cust_marital_status,
	cust_gndr,
	cust_create_date
	)

	select 
		cust_id,
		cust_key,
		trim(cust_firstname) as cust_firstname,
		trim(cust_lastname) as cust_lastname,
		case when trim(cust_marital_status) = 'S'then 'Single'
			 when trim(cust_marital_status) = 'M'then 'Married'
		else 'unkown'
		end cust_marital_status,
		case when trim(cust_gndr) = 'M'then 'Male'
			 when trim(cust_gndr) = 'F'then 'Female'
		else 'Unkown'
		end cust_gndr,
		cust_create_date
	 from (
		select *,
		row_number() over (partition by cust_id order by cust_create_date desc) as flag_last
		from bronze.crm_customer_info
	 )t where flag_last = 1
	 and cust_id is not null;

	 set @end_time = getdate();
	print '>>>Load duration' + cast (datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
	print '--------------------------------------------';

	set @start_time = getdate();
	print '--------------------------------------------';

-- truncating data from silver.crm_prd_info

print '>> truncating data from silver.crm_prd_info'
print '------------------------------------------------'
	truncate table silver.crm_prd_info;

-- inserting data to silver.crm_prd_info

insert into silver.crm_prd_info(
   prd_id,
   cat_id,
   prd_key,
   prd_nm,
   prd_cost,
   prd_line,
   prd_start_dt,
   prd_end_dt
   )
select 
	prd_id,
	replace(substring(prd_key, 1, 5), '-', '_')  as cat_id,
	substring(prd_key, 7, len(prd_key)) as prd_key,
	prd_nm,
	isnull(prd_cost, 0) as prd_cost,
	case when upper(trim(prd_line)) = 'R' then 'Road'
		 when upper(trim(prd_line)) = 'S' then 'Other Sales'
		 when upper(trim(prd_line)) = 'M' then 'Mountain'
		 when upper(trim(prd_line)) = 'T' then 'Transport'
	else 'unknown'
	end prd_line,
	cast(prd_start_dt as date) as prd_start_dt,
	cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt
	from bronze.crm_prd_info;

	set @end_time = getdate();
	print '>>>Load duration' + cast (datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
	print '--------------------------------------------';

	set @start_time = getdate();
	print '--------------------------------------------';

-- truncating data from silver.crm_sales_details

print '>> truncating data from silver.crm_sales_details'
print '------------------------------------------------'
	truncate table silver.crm_sales_details;

-- inserting data to silver.crm_sales_details

insert into silver.crm_sales_details(
   sls_ord_num,
   sls_prd_key,
   sls_cust_id,
   sls_order_dt,
   sls_ship_dt,
   sls_due_dt,
   sls_sales,
   sls_quantity,
   sls_price
   )
   select 
   sls_ord_num,
   sls_prd_key,
   sls_cust_id,
   case when sls_order_dt = 0 or len(sls_order_dt) != 8 then null
		else cast(cast(sls_order_dt as varchar) as date)
   end sls_order_dt,
   case when sls_ship_dt = 0 or len(sls_ship_dt) != 8 then null
		else cast(cast(sls_ship_dt as varchar) as date)
   end sls_ship_dt,
   case when sls_due_dt = 0 or len(sls_due_dt) != 8 then null
		else cast(cast(sls_due_dt as varchar) as date)
   end sls_due_dt,
   case when sls_sales <= 0 or sls_sales is null or sls_sales = sls_quantity * abs(sls_price)
		then sls_quantity * abs(sls_price)
	else sls_price
   end sls_price,
   sls_quantity,
   case when sls_price is null or sls_price <= 0
		then sls_sales / nullif(sls_quantity, 0)
	 else sls_price
	end sls_price
from bronze.crm_sales_details;
  
set @end_time = getdate();
print '>>>Load duration' + cast (datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
print '--------------------------------------------';

set @batch_end_time = getdate();
print '--------------------------------------------------';
print 'Loading silver crm layer is completed';
print '>>>Load duration' + cast (datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + 'seconds';
print '--------------------------------------------------';

set @batch_start_time = getdate();

	set @start_time = getdate();
	print '--------------------------------------------';

-- truncating data from silver.erp_cust_dtls

print '>> truncating data from silver.erp_cust_dtls'
print '------------------------------------------------'
	truncate table silver.erp_cust_dtls;

-- inserting into silver.erp_cust_dtls

insert into silver.erp_cust_dtls(
	CID,
	BDATE,
	GEN
	)
select
	substring(CID, 4, len(CID)) as CID,
	case when BDATE > getdate() then null
	else BDATE
	end as BDATE,
	case when upper(trim(gen)) in ('F', 'Female') then 'Female'
		 when upper(trim(gen)) in ('M', 'Male') then 'Male'
		else 'Unkown'
		end as GEN
	from Bronze.erp_cust_dtls;

	set @end_time = getdate();
	print '>>>Load duration' + cast (datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
	print '--------------------------------------------';

	set @start_time = getdate();
	print '--------------------------------------------';

-- truncating data from silver.erp_locl_a1

print '>> truncating data from silver.erp_locl_a1'
print '------------------------------------------------'
	truncate table silver.erp_locl_a1;

-- inserting into silver.erp_locl_a1

insert into silver.erp_locl_a1(
	cid,
	centry
)
select 
		replace (cid, '-', '') as cid,
		case when upper(trim(centry)) in ('USA', 'US', 'United States') then 'United States of America'
			 when upper(trim(centry)) in ('DE', 'Germany') then 'Germany'
			 when upper(trim(centry)) in (' ', 'NUll') then NULL
			 else centry
			 end as centry
	from bronze.erp_locl_a1;

	set @end_time = getdate();
	print '>>>Load duration' + cast (datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
	print '--------------------------------------------';

	set @start_time = getdate();
	print '--------------------------------------------';

-- truncating data from silver.erp_px_cat

print '>> truncating data from silver.erp_px_cat'
print '------------------------------------------------'
	truncate table silver.erp_px_cat;

-- inerting data into silver.erp_px_cat

insert into silver.erp_px_cat(
	    ID,
		CAT,
		SUBCAT,
		MAINTENANCE
)
select
		ID,
		CAT,
		SUBCAT,
		MAINTENANCE
	from bronze.erp_px_cat;

	set @end_time = getdate();
	print '>>>Load duration' + cast (datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
	print '--------------------------------------------';

	set @batch_end_time = getdate();
	print '--------------------------------------------------';
	print 'Loading silver erp layer is completed';
	print '>>>Load duration' + cast (datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + 'seconds';
	print '--------------------------------------------------';

end try

	 begin catch

print '==================================================';
print 'Error occured during the silver layer';
print 'Error message' + ERROR_MESSAGE();
print 'Error message' + cast (ERROR_NUMBER() as varchar);
print 'Error message' + cast (ERROR_STATE() as varchar);
print '==================================================';

     end catch

end
