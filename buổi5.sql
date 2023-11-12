--Ex1 
select distinct city from station where ID%2=0
--Ex2
select count (city) - count (distinct city) from station
--Ex3
--Ex4
SELECT round(cast(sum(item_count*order_occurrences)/sum(order_occurrences) as decimal),1) FROM items_per_order;
--Ex5
SELECT distinct candidate_id FROM candidates where skill in ('Python','Tableau','PostgreSQL')
group by candidate_id having count (skill)=3
--Ex6
SELECT user_id,
date(max(post_date))-date(min(post_date)) as days_between
FROM posts
where post_date>='01/01/2021' and post_date<= '01/01/2022'
group by user_id
having count (post_id)>1
--Ex7
SELECT card_name,
max(issued_amount)-min(issued_amount) as difference
FROM monthly_cards_issued
group by card_name
order by difference DESC
--Ex8
SELECT manufacturer,
count (drug) as drug_count, 
abs(Sum(cogs-total_sales)) as total_loss
FROM pharmacy_sales
where cogs>total_sales
group by manufacturer
order by total_loss DESC
--Ex9
Select *
from cinema
where id%2<>0  and description<>'boring'
order by rating DESC
--Ex10
Select teacher_id,
count (distinct subject_id) as cnt from teacher
group by teacher_id
--Ex11
Select user_id, count(follower_id) as followers_count from followers
group by user_id
order by user_id ASC
--Ex12
Select class from courses
group by class
having count(student)>=5
