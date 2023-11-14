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
