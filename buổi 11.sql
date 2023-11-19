--Practice test
-- Ex1
select b.continent, floor (avg(a.population))
from city as a join country as b on a.countrycode=b.code
group by b.continent
  
--Ex2
SELECT round(1.0 *sum(case when signup_action='Confirmed' then 1 else 0 END) /count(*),2) 
as confirm_rate
FROM emails as a inner join texts as b 
on a.email_id=b.email_id
  
--Ex3 Mình giải được đến thế còn lại vẫn stuck chưa ra hẳn kết quả được
SELECT b.age_bucket, 
case when activity_type = 'open' then time_spent else 0 END as opening_time,
case when activity_type = 'send' then time_spent else 0 end as sending_time,
case when activity_type = 'open' then time_spent else 0 END + case when activity_type = 'send' then time_spent else 0 end as total_time
FROM activities as a inner join age_breakdown as b 
on a.user_id	=b.user_id
  
--Ex4
SELECT customer_id 
FROM customer_contracts as a left join products as b 
on a.product_id=b.product_id
group by customer_id
having count(DISTINCT product_category)>= (select count(DISTINCT product_category) from products) 
  
--Ex5 câu này mình run query thì nó accept nma lúc submit thì báo lỗi, bạn xem do mình sai ở đâu thật hay là do web bị lỗi nhe.
select emp.employee_id as employee_id, emp.name, count(mana.reports_to) as reports_count, 
ceiling(avg(mana.age)) as average_age  
from employees as emp join employees as mana
on emp.employee_id = mana.reports_to 
group by mana.reports_to
order by employee_id
  
--Ex6
select a.product_name, sum(b.unit) as unit 
from products as a join orders as b
on a.product_id=b.product_id    
where extract(year from order_date)='2020' 
and extract(month from order_date)='02'
group by product_name
having sum(b.unit)>=100
  
--Ex7
SELECT a.page_id
FROM pages as a LEFT JOIN page_likes as b 
on a.page_id=b.page_id
where liked_date is null
order by a.page_id

--Mid course test
--Ex1
select distinct replacement_cost from film
order by replacement_cost limit 1
--Ex2
select 
case 
when replacement_cost between 9.99 and 19.99 then 'low'
when replacement_cost between 20.00 and 24.99 then 'medium'
else 'high'
end category,
count (*)from film
group by category
--Ex3
select c.title, a.name, c.length
from category as a join film_category as b
on a.category_id=b.category_id
join film as c on b.film_id=c.film_id
where a.name in ('Drama', 'Sports')
order by length DESC
--Ex4

