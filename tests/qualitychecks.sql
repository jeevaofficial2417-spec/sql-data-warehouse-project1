 -- checking for the duplicates in the primary key

 select prd_id, count(*) as duplicates from bronze.crm_prd_info
 group by prd_id
 having count (*) > 1 or prd_id is null;

 -- data cleansing for silver layer

select *
 from (
	select *,
	row_number() over (partition by cust_id order by cust_create_date desc) as flag_last
	from bronze.crm_customer_info
 )t where flag_last = 1


-- checking for the unwanted spaces in the coloumn


select cust_firstname from bronze.crm_customer_info
where cust_firstname != trim(cust_firstname);

select cust_lastname from bronze.crm_customer_info
where cust_lastname != trim(cust_lastname);

--check for a invalid date orders

select * from bronze.crm_prd_info
where prd_start_dt > prd_end_dt
