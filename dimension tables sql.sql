select customer_id,customer_city,customer_state from olist_customers;
select p.product_id,
p.product_category_name product_category_name_PT,
pc.product_category_name product_category_name_EN,
product_weight_g,
product_length_cm,
product_height_cm,
product_width_cm
from olist_products p
left join olist_prod_catalog_name_tr pc
on p.product_category_name=pc.product_category_name;
select seller_id,seller_city,seller_state from olist_sellers