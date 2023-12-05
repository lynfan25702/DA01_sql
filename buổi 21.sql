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
- Kể từ tháng 10/2020 - 2/2021, số lượng khách hàng và đơn hàng có sự dao động lên xuống nhất định.
