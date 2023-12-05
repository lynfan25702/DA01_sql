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
)

select  c.first_name, c.last_name, c.gender, c.age
from bigquery-public-data.thelook_ecommerce.users as c join female_group as a
on a.oldest=c.age or a.youngest=c.age
where gender ='F' and created_at between '2019-01-01 00:00:00' and '2022-05-01 00:00:00'
Union all 
select  c.first_name, c.last_name, c.gender, c.age
from bigquery-public-data.thelook_ecommerce.users as c join male_group as b
on b.oldest=c.age or b.youngest=c.age
where gender ='M' and created_at between '2019-01-01 00:00:00' and '2022-05-01 00:00:00'


 





