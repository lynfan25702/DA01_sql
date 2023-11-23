--Ex1
with CTE as (select company_id, title, description, count (job_id) as job_count
FROM job_listings
group by company_id , title, description)
select count (distinct company_id) as duplicate_companies 
from CTE 
where job_count >=2
--Ex3
select count(policy_holder_id) as member_count FROM
(SELECT policy_holder_id, COUNT(case_id) AS call_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3) as call_records
--Ex6
SELECT
Date_format(trans_date, '%Y-%m') AS month,
country AS country,
count(id) AS trans_count,
SUM(case WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
SUM(amount) AS trans_total_amount,
SUM(case WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM
transactions
GROUP BY
Date_format(trans_date, '%Y-%m') ,
country;
--Ex7
select product_id, min(year) as first_year, quantity, price
from sales
group by product_id
--Ex8
Select customer_id from customer 
Group by customer_id
having count(distinct product_key)=(select count(distinct product_key)
from product)
--Ex9
select employee_id from employees
where salary < 30000 and manager_id not in (select employee_id from Employees)
group by employee_id
--Ex10
with CTE as (select company_id, title, description, count (job_id) as job_count
FROM job_listings
group by company_id , title, description)
select count (distinct company_id) as duplicate_companies 
from CTE 
where job_count >=2
--Ex12
with A as(select requester_id as id from RequestAccepted
union all select accepter_id as id from RequestAccepted)
select id, count(*) as num  from A 
group by id 
order by num desc 
limit 1
--Mấy câu còn lại mình bị stuck nên chưa rõ cách làm
