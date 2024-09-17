select 
o.customer_id,
format(cast(substring(o.order_Delivered_customer_date,1,10)as date),'yyyyMMdd') delivery_day_id,
oi.product_id,
oi.seller_id,
count(distinct o.order_id) nr_orders,
count(oi.product_id) products,
sum(oi.price) product_sales_revenue,
sum(oi.freight_value)shipping_revenue,
count(review_id) nr_of_review_score,
sum(cast(review_score as int))sum_review_score
from olist_orders o
left join olist_order_items oi
on o.order_id=oi.order_id
left join olist_reviews r
on o.order_id=r.order_id
where order_Status='delivered'
group by 
o.customer_id,
format(cast(substring(o.order_Delivered_customer_date,1,10)as date),'yyyyMMdd'),
oi.product_id,
oi.seller_id