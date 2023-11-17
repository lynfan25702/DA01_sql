-- Ex1
SELECT 
sum (case 
when device_type in ('tablet', 'phone') then 1 else 0 
end) as mobile_views,
sum (case 
when device_type = 'laptop' then 1 else 0 
end) as laptop_views
FROM viewership;
--Ex2
select x,y,z, 
case 
when x+y>z and x+z>y and z+y>x then 'Yes'
else 'No'
end as triangle
from triangle
--Ex3 câu 3 mình không sure lắm vì chạy k ra kết quả nhưng kbik sai ở đâu
SELECT round (100 * count(CASE
when call_category is null or call_category = 'n/a' then 1 else 0
end)/ count(*),1) as call_percentage
from callers;
--Ex4
select name from customer
where referee_id <> 2 or referee_id is null
--Ex5
select  
case 
when pclass =1 then 'first_class'
when pclass=2 then 'second_class'
when pclass=3 then 'third_class'
end as class,
sum (case
when survived = 1 then 1 else 0
end) as survivors,
sum (case
when survived = 0 then 1 else 0
end) as non_survivors
from titanic
group by class
