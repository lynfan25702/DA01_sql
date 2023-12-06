--Project 2
-- Ad-hoc tacks
/* 1. Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
      Output: month_year ( yyyy-mm) , total_user, total_order */

select format_date ('%Y-%m', b.delivered_at) as month_year,
count( distinct a.user_id) as total_user, count (a.order_id) as total_order,
from bigquery-public-data.thelook_ecommerce.order_items as a 
join bigquery-public-data.thelook_ecommerce.orders as b
on a.order_id=b.order_id  
where b.delivered_at between '2019-01-01 00:00:00' and '2022-05-01 00:00:00'
group by month_year
order by month_year

/* Insights:
- Nhìn chung tổng số lượng người mua và số lượng đơn hàng có xu hướng tăng mạnh trong khoảng thời gian từ 1/2019 đến 4/2022, 
từ 4 khách với 6 đơn hàng tăng trưởng thành 716 khách với 1056 đơn hàng. 
- Kể từ tháng 10/2020 - 2/2021, số lượng khách hàng và đơn hàng có sự dao động lên xuống nhất định. Từ tháng 12/2021 đến 4/2022,
pattern này lại lặp lại thêm lần nữa. Chứng tỏ cty nên xem xét khoảng thời gian từ cuối năm đến đầu năm sau vì đó là lúc số lượng
người mua và đơn hàng có sự lên xuống không ổn định */

/* 2. Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng ( Từ 1/2019-4/2022)
     Output: month_year ( yyyy-mm), distinct_users, average_order_value */
select format_date ('%Y-%m', created_at) as month_year, count (distinct user_id) as distinct_users,
round (sum (sale_price)/count (sale_price),2) as  average_order_value 
from bigquery-public-data.thelook_ecommerce.order_items
where created_at between '2019-01-01 00:00:00' and '2022-05-01 00:00:00'
group by month_year order by month_year

/* Insights:
- Tháng đầu tiên ghi nhận giá trị đơn hàng trung bình cao nhất dù tổng số người dùng thấp nhất. 
- Từ tháng 1 - 9/2019 bước vào giai đoạn ổn định lượng khách hàng nên giá trị đơn hàng trung bình có sự dao động không ổn định.
- Từ đó về sau số lượng khách hàng vẫn có xu hướng tăng trưởng đều và giá trị đơn hàng trung bình luôn duy trì ở ngưỡng trên dưới 60 */

/* 3. Tìm các khách hàng trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
      Output: first_name, last_name, gender, age, tag (hiển thị youngest nếu trẻ tuổi nhất, oldest nếu lớn tuổi nhất) */

with female_group as (select  min (age) as youngest, max (age) as oldest
from bigquery-public-data.thelook_ecommerce.users
where gender ='F' and created_at between '2019-01-01 00:00:00' and '2022-05-01 00:00:00'
),

male_group as (select min (age) as youngest, max (age) as oldest
from bigquery-public-data.thelook_ecommerce.users
where gender ='M' and created_at between '2019-01-01 00:00:00' and '2022-05-01 00:00:00'
),

age_group as (select  c.first_name, c.last_name, c.gender, c.age
from bigquery-public-data.thelook_ecommerce.users as c join female_group as a
on a.oldest=c.age or a.youngest=c.age
where gender ='F' and created_at between '2019-01-01 00:00:00' and '2022-05-01 00:00:00'
Union all 
select  c.first_name, c.last_name, c.gender, c.age
from bigquery-public-data.thelook_ecommerce.users as c join male_group as b
on b.oldest=c.age or b.youngest=c.age
where gender ='M' and created_at between '2019-01-01 00:00:00' and '2022-05-01 00:00:00'),

age_tag as (select *,
case
when age in (select min (age) from bigquery-public-data.thelook_ecommerce.users
where gender ='M' and created_at between '2019-01-01 00:00:00' and '2022-05-01 00:00:00') then 'youngest'
when age in (select  min (age) from bigquery-public-data.thelook_ecommerce.users
where gender ='F' and created_at between '2019-01-01 00:00:00' and '2022-05-01 00:00:00' ) then 'youngest'
else 'oldest'
end as tag
from age_group)

select gender, tag, count (*) as customer_count
from age_tag
group by gender, tag

/* Insights: 
-Từ 1/2019-4/2022, ở mỗi nhóm nam lẫn nữ, số tuổi khách hàng lớn nhất đều là 70 và thấp nhất là 12.
- So sánh giữa hai giới thì số lượng khách nam trẻ tuổi ít hơn số khách nữ trẻ tuổi và ngược lại nếu xét trong hạng mục độ tuổi lớn nhất của khách khi mua hàng. */

/* 4. Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
      Output: month_year ( yyyy-mm), product_id, product_name, sales, cost, profit, rank_per_month */

with all_product as (select format_date ('%Y-%m', a.delivered_at) as month_year,
a.product_id, b.name as product_name,
round ((b.retail_price), 2) as sales,
round ((b.cost),2) as cost,
round ((b.retail_price - b.cost),2) as profit
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b
on a.id=b.id),

top_product as (select * , dense_rank () over (partition by month_year order by profit DESC) as rank_per_month
from all_product)

select * from top_product
where rank_per_month <6 and month_year is not null
order by month_year
--------------
with all_product as (select format_date ('%Y-%m', a.delivered_at) as month_year,
a.product_id, b.name as product_name,
round (sum(b.retail_price), 2) as sales,
round (sum(b.cost),2) as cost,
round(sum(b.retail_price) - sum(b.cost),2) as profit
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b
on a.id=b.id
group by month_year, a.product_id, b.name),

top_product as (select * , dense_rank () over (partition by month_year order by profit DESC) as rank_per_month
from all_product)

select * from top_product
where rank_per_month <6 and month_year is not null
order by month_year
/* 5. Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
      Output: dates (yyyy-mm-dd), product_categories, revenue */

select format_date ('%Y-%m-%d', a.delivered_at) as dates,
b.category as product_categories,
round (sum(b.retail_price),2) as revenue
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b
on a.id=b.id
where a.delivered_at between '2022-01-15' and '2022-04-15'
group by b.category, dates 
order by dates

-- Tạo metrics
/* 1. Tạo dashboard*/
With vw_ecommerce_analyst as
(
with cpn_info as (select format_date ('%Y-%m', a.delivered_at) as month,
format_date ('%Y', a.delivered_at) as year,
b.category as product_category, 
round (sum(c.sale_price),2) as TPV, round(sum (c.order_id),2) as TPO, round (sum(b.cost),2) as total_cost
from bigquery-public-data.thelook_ecommerce.orders as a 
join bigquery-public-data.thelook_ecommerce.order_items as c
on a.order_id=c.order_id
join bigquery-public-data.thelook_ecommerce.products as b on b.id=c.id
where format_date ('%Y-%m', a.delivered_at) is not null and format_date ('%Y', a.delivered_at) is not null
group by month, year, product_category
order by month, year)

select month, year, product_category, TPV, TPO, total_cost,
round ((TPV - lag(TPV) over (partition by product_category order by year,month))/(lag(TPV) over (partition by product_category order by year,month)),2) as revenue_growth,
round ((TPO - lag(TPO) over (partition by product_category order by year,month))/(lag(TPO) over (partition by product_category order by year,month)),2) as order_growth,
round ((TPV-total_cost),2) as total_profit, round (((round ((TPV-total_cost),2))/total_cost),2) as profit_to_cost_ratio
from cpn_info
order by month, year, product_category
)


/*2. Tạo cohort table */

with retail_index as (select user_id,format_date ('%Y-%m', first_purchase_date) as cohort_date,
created_at, amount, 
(extract (year from created_at) - extract (year from first_purchase_date))*12 +
(extract (month from created_at) - extract (month from first_purchase_date))+1 as index
from 
(select user_id,min (created_at) over (partition by user_id) as first_purchase_date, created_at,
round (sale_price,2) as amount
from bigquery-public-data.thelook_ecommerce.order_items) as a)

, retail_cohort as (select cohort_date, index, 
count (distinct user_id) as total_users, round (sum (amount),2) as revenue
from retail_index
group by cohort_date, index)

--Customer cohort
, customer_cohort as (select cohort_date,
sum (case when index = 1 then total_users else 0 end) as m1,
sum (case when index = 2 then total_users else 0 end) as m2,
sum (case when index = 3 then total_users else 0 end) as m3,
sum (case when index = 4 then total_users else 0 end) as m4
from retail_cohort group by cohort_date order by cohort_date)

--Retention cohort
, retention_cohort as (select cohort_date,
(round (100.00 * m1/m1,2)) || '%' as m1,
(round (100.00 * m2/m1,2)) || '%' as m2,
(round (100.00 * m3/m1,2)) || '%' as m3,
(round (100.00 * m4/m1,2)) || '%' as m4
from customer_cohort)

--Churn cohort
select cohort_date,
(100-(round (100.00 * m1/m1,2))) || '%' as m1,
(100-(round (100.00 * m2/m1,2))) || '%' as m2,
(100-(round (100.00 * m3/m1,2))) || '%' as m3,
(100-(round (100.00 * m4/m1,2))) || '%' as m4
from customer_cohort

--Cohort chart
https://docs.google.com/spreadsheets/d/1D_lzrh42ZRvR2QrUv1mjsqA6WRLp3nOwg86faEO0kGw/edit#gid=218286079 

/* Insights:
- Nhìn chung sản phẩm có sự cải thiện theo thời gian vì với từng đợt cohort mới thì lượng khách trung thành cũng tăng theo.
- Tuy nhiên, sự duy trì của lượng khách trung thành của từng cohort rất kém, chứng tỏ công ty nên xem lại chiến lược giữ chân khách hàng vì 
theo thời gian số lượng khách hàng sử dụng lại sản phẩm không cao, dưới mức 10% */

























 





