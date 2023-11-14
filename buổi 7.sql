--Ex1
select name from students
where marks > 75
order by right (name,3), ID
--Ex2
Select user_id,
Concat (Upper(Left (name,1)), Lower (right(name, length(name)-1))) as name
from Users
order by user_id
--Ex3
SELECT manufacturer,
'$'|| round ((sum (total_sales))/1000000,0)||' '||'million' as sale
FROM pharmacy_sales
group by manufacturer
order by sum (total_sales) DESC, manufacturer 
--Ex4
SELECT EXTRACT(month from submit_date) as mth, product_id, 
round (avg (stars),2) as avg_stars
FROM reviews
group by product_id, EXTRACT(month from submit_date)
order by mth, product_id
--Ex5
SELECT sender_id,
count (content) as message_count
FROM messages
where extract (month from sent_date) = 08 
and extract (year from sent_date)= 2022
group by sender_id
order by message_count DESC
limit 2
--Ex6
Select tweet_id 
from tweets
where length (content) >15
--Ex7
select activity_date as day, 
count(distinct user_id) as active_users
from Activity
where activity_date between '2019-06-28' and '2019-07-27'
group by activity_date
--Ex8
select 
count (id)
from employees
where joining_date between '2022-01-01' and '2022-07-31'
--Ex9
select first_name,
position ('a' in first_name)
from worker
where first_name = 'Amitah'
--Ex10
select title, substring(title, length (winery)+2, 4) as year
from winemag_p2
where country = 'Macedonia';
