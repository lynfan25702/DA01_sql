-- Project 3
-- 1. Doanh thu theo từng ProductLine, Year  và DealSize?
-- a. Doanh thu theo từng ProductLine
select productline, sum (quantityordered * priceeach) as revenue
from public.sales_dataset_rfm_prj_clean
group by productline

--b.  Doanh thu theo từng Year
select year_id, sum (quantityordered * priceeach) as revenue
from public.sales_dataset_rfm_prj_clean
group by year_id

--c. Doanh thu theo từng Dealsize
select dealsize, sum (quantityordered * priceeach) as revenue
from public.sales_dataset_rfm_prj_clean
group by dealsize

--3. Product line nào được bán nhiều ở tháng 11?
select year_id, sum (quantityordered * priceeach) as revenue,
rank () over (partition by year_id order by sum (quantityordered * priceeach))
from public.sales_dataset_rfm_prj_clean
group by year_id

