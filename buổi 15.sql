--Ex2
SELECT DISTINCT card_name,
first_value (issued_amount) over (partition by card_name order by issue_year) as issued_amount 
FROM monthly_cards_issued
order by issued_amount DESC
--Ex3
select user_id, spend, transaction_date from (SELECT user_id, spend, transaction_date,
row_number() over (partition by user_id order by transaction_date) as stt
FROM transactions) as D
where stt=3
--Ex4
with twt_so_luong as (select transaction_date, user_id
from (SELECT transaction_date,user_id,
dense_rank () over (partition by user_id order by transaction_date DESC ) as stt
FROM user_transactions) as b
where stt=1)

select transaction_date, user_id, count (user_id) as purchase_count
from twt_so_luong
group by transaction_date, user_id
--Ex5
SELECT user_id, tweet_date, 
round (avg(tweet_count) over (partition by user_id order by tweet_date
rows between 2 preceding and current row),2) as rolling_avg_3d
FROM tweets;

--Ex7
select category, product, total_spend
from(select category, product, sum (spend) as total_spend,
rank() over (partition by category order by sum(spend) DESC ) as stt
from product_spend
where extract (year from transaction_date)='2022'
group by category,product) as a
where stt<3

--Ex8
with cte as (SELECT a.artist_name, c.rank, c.song_id FROM artists as a  
join songs as b on a.artist_id=b.artist_id
join global_song_rank as c on b.song_id=c.song_id
where rank<=10),

a as (select cte.artist_name, count(cte.rank) as total_rank
from cte 
group by artist_name order by total_rank DESC)

select artist_name, artist_rank from (select artist_name,
dense_rank () over (order by total_rank DESC)
as artist_rank
from a) as b 
where artist_rank<6 
