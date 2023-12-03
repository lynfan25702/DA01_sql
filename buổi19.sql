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

