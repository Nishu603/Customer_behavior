use customer_behaviour;
select * from customer limit 20;

-- what isthe total revenue gendearted by male and female?----

select gender, sum(purchase_amount) as revenue
from customer
group by gender;

----which customer used a discount but still spent more than the average purchase amount?---

select customer_id, purchase_amount from customer
where discount_applied = "Yes" and purchase_amount >= (select avg(purchase_amount) from customer);

--which are the top 5 products with the highest average review rating?--
select item_purchased, avg(review_rating) as avg_product_rating
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

---compare the avergae purchase amount between standard and express shipping?-
select shipping_type, avg(purchase_amount) from customer
where shipping_type in ('Standard' ,'Express')
group by shipping_type;

--Do subsribed customers spend more?compare average spend and total revenue between subsribers and non-subsribers?--
select count(customer_id)as total_customers ,avg(purchase_amount),sum(purchase_amount), subscription_status from customer
group by  subscription_status;

--which five products have the highest percentage of purchases with discount applied?
select item_purchased,
(sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*)) *100 as discount_rate
from customer group by item_purchased
order by discount_rate desc
limit 5;

---segment customers into new , returning and loyal on their total?--
---number of previous purchases and show the count of each segment

with customer_type as (
select customer_id, previous_purchases,
case 
    when previous_purchases = 1 then "New"
    when previous_purchases between 2 and 10 then "returning"
    else "loyal"
    end as customer_segment
from customer
)
select customer_segment, count(*) as "Number_of_customer"
from customer_type
group by customer_segment;

---what are the 3 most purchased products within each category?--
with item_count as(
select category, item_purchased, count(customer_id)as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank 
from customer
 group by category, item_purchased)
 select item_rank, category,item_purchased, total_orders
 from item_count
 where item_rank <= 3;

-- are customers who are repeat buyers (mlore than 5 previous purchases) also likely to subscribe?----
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases >5
group by subscription_status;

---what is the rwvenue contribution of each age_group?--

select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;









