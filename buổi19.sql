--Câu 1
alter table public.sales_dataset_rfm_prj
alter column phone type varchar (50) USING (trim(phone)::varchar),
alter column productcode type varchar (50) USING (trim(productcode)::varchar),
alter column customername type varchar (250) USING (trim(customername)::varchar),
alter column addressline1 type varchar (250) USING (trim(addressline1)::varchar),
alter column addressline2 type varchar (250) USING (trim(addressline2)::varchar),
alter column city type varchar (50) USING (trim(city)::varchar),
alter column state type varchar (50) USING (trim(state)::varchar),
alter column postalcode type varchar (50) USING (trim(postalcode)::varchar),
alter column country type varchar (50) USING (trim(country)::varchar),
alter column territory type varchar (50) USING (trim(territory)::varchar),
alter column contactfullname type varchar (250) USING (trim(contactfullname)::varchar),
alter column dealsize type varchar (50) USING (trim(dealsize)::varchar),
alter column status type varchar (50) USING (trim(status)::varchar),
alter column productline type varchar (50) USING (trim(productline)::varchar),
alter column msrp type int USING (trim(msrp)::integer),
alter column sales type float USING (trim(sales)::decimal),
alter column orderdate type datetime USING (trim(orderdate)::datetime),
alter column ordernumber type int USING (trim(ordernumber)::integer),
alter column quantityordered type int USING (trim(quantityordered)::integer),
alter column priceeach type numeric using (trim(priceeach):: numeric),
alter column orderlinenumber type int USING (trim(orderlinenumber)::integer)

--Câu 2
SELECT ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE 
FROM public.sales_dataset_rfm_prj 
WHERE ORDERNUMBER IS NULL OR QUANTITYORDERED IS NULL OR
PRICEEACH IS NULL OR ORDERLINENUMBER IS NULL or
SALES IS NULL OR ORDERDATE IS NULL

--Câu 3
Alter table public.sales_dataset_rfm_prj
Add column contactlastname varchar (50),
Add column contactfirstname varchar (50)

Update public.sales_dataset_rfm_prj
set contactlastname = initcap(substring (contactfullname from 1 for (position ('-' in contactfullname)-1))) 
Update public.sales_dataset_rfm_prj
set contactfirstname = initcap(substring (contactfullname, (position ('-' in contactfullname)+1))) 

--Câu 4
Alter table public.sales_dataset_rfm_prj
Add column QTR_ID int,
Add column MONTH_ID int,
Add column YEAR_ID int

Update public.sales_dataset_rfm_prj
set month_id = extract (month from orderdate)
Update public.sales_dataset_rfm_prj
set year_id = extract (year from orderdate)
Update public.sales_dataset_rfm_prj
set qtr_id = 1 where month_id in (1,2,3)
Update public.sales_dataset_rfm_prj
set qtr_id = 2 where month_id in (4,5,6)
Update public.sales_dataset_rfm_prj
set qtr_id = 3 where month_id in (7,8,9)
Update public.sales_dataset_rfm_prj
set qtr_id = 4 where month_id in (10,11,12)

--Câu 5
with cte as (select Q1 - 1.5*IQR as min_value,
Q3 + 1.5 * IQR as max_value from 
(select 
percentile_cont (0.25) within group(order by QUANTITYORDERED) as Q1,
percentile_cont (0.75) within group (order by QUANTITYORDERED) as Q3,
percentile_cont (0.75) within group (order by QUANTITYORDERED) - percentile_cont (0.25) within group (order by QUANTITYORDERED) as IQR
from public.sales_dataset_rfm_prj) as a)

with twt_outliers as (select * from public.sales_dataset_rfm_prj
where QUANTITYORDERED < (select min_value from cte)
or QUANTITYORDERED > (select max_value from cte))
  
  --Cách 1 để xử lí outliers
delete from public.sales_dataset_rfm_prj where QUANTITYORDERED in (select QUANTITYORDERED from twt_outliers)
  -- Cách 2 để xử lí outliers
update public.sales_dataset_rfm_prj
set QUANTITYORDERED = (select avg (QUANTITYORDERED) from public.sales_dataset_rfm_prj)
where QUANTITYORDERED in (select QUANTITYORDERED from twt_outliers)

--Câu 6 Bạn xem cách làm như này đúng chưa nhé
Create table SALES_DATASET_RFM_PRJ_CLEAN
(ORDERNUMBER int, QUANTITYORDERED int , PRICEEACH numeric, 
ORDERLINENUMBER int , SALES decimal, ORDERDATE date,
status varchar (50), productline varchar (50), msrp int, productcode varchar (50)
customername varchar (250), phone varchar (50), addressline1 varchar (250),
addressline2 varchar (250), city varchar (50), state varchar (50), postalcode varchar (50),
country varchar (50), territory varchar (50), contactfullname varchar (250), dealsize varchar (50),
contactlastname varchar (50), contactfirstname varchar (50), qtr_id int, month_id int, year_id int)
insert into SALES_DATASET_RFM_PRJ_CLEAN 
select * from public.sales_dataset_rfm_prj


