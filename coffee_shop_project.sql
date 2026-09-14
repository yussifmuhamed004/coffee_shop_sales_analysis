use coffee_sales;
select * from customer;
select * from dates;
select * from generations;
select * from product;
select * from `pastry_ inventory`;
select * from sales_outlet;
select * from staff;
select * from sales_targets;
select * from sales_reciepts;

CREATE view coffee as
SELECT 
sr.transaction_id, sr.transaction_date, sr.staff_id, sr.transaction_time, sr.sales_outlet_id, sr.quantity,
sr.line_item_amount, sr.unit_price, sr.promo_item_yn, sr.`order`, sr.instore_yn, sr.product_id, sr.customer_id,
c.customer_name, c.gender, c.customer_since,  c.customer_email, c.home_store, c.loyalty_card_number, c.birth_year,
p.product_category, p.product,
s.first_name, s.last_name, s.position,
so.sales_outlet_type, so.store_city
FROM sales_reciepts sr
join product p on sr.product_id=p.product_id
JOIN customer c on sr.customer_id= c.customer_id
join staff s on sr.staff_id= s.staff_id
join sales_outlet so on so.sales_outlet_id= sr.sales_outlet_id
;
SELECT* from coffee;


 #        ___________________________________________________

# اجمالي المبيعات وعدد الفواتير

select sum(`line_item_amount`)
AS Total_Revenue,
count(*) As Total_orders
 from coffee;

 
 #        ___________________________________________________


 #اجمالي المبيعات حسب النوع\الجنس
select gender,sum(line_item_amount)as total_amount  from coffee
group by gender;


 #        ___________________________________________________

# اكثر المنتجات مبيعاوطلبا

select product_category, sum(`line_item_amount`)As Total_revenue,
count(*) as total_orders
  from coffee
group by product_category
order by Total_revenue desc;


 #        ___________________________________________________


# اداء المببعات حسب الشهر مع عمود التاريخ من نص الي تاريخ

select month(STR_TO_DATE(`transaction_date`,'%m/%d/%y')) as 'month',
sum(`line_item_amount`) as total_amount from coffee
group by month(STR_TO_DATE(`transaction_date`,'%m/%d/%y'))
order by 'month' desc;


 #        ___________________________________________________

# اداء المبيعات حسب اليوم

select day(STR_TO_DATE(`transaction_date`,'%m/%d/%y')) as 'day',
sum(`line_item_amount`) as total_amount from coffee
group by day(STR_TO_DATE(`transaction_date`,'%m/%d/%y'))
order by day(STR_TO_DATE(`transaction_date`,'%m/%d/%y')) asc;


 #        ___________________________________________________

# اكثر ساعات اليوم مبيعا

select hour(`transaction_time`) as 'HOUR',
sum(line_item_amount)as total_sales
from coffee
GROUP BY hour(`transaction_time`)
order by total_sales desc
limit 5;


 #        ___________________________________________________

#اقل ساعات اليوم مبيعا

select hour(`transaction_time`) as 'HOUR',
sum(line_item_amount)as total_sales
from coffee
GROUP BY hour(`transaction_time`)
order by total_sales Asc
limit 5;


 #        ___________________________________________________

# افضل ايام الاسبوع


select 
DAYNAME(STR_TO_DATE(transaction_date, '%m/%d/%y')) as day_number,
sum(line_item_amount)as total_sales
from coffee
GROUP BY 
DAYNAME(STR_TO_DATE(transaction_date, '%m/%d/%y'))
order by total_sales desc;



 #        ___________________________________________________
use coffee_sales;
select * from coffee;

# اجمالي المبيعات بالنسبه للمدينه والفرع

select home_store, store_city,
sum(line_item_amount)as total_sales
from coffee
GROUP BY 1,2
ORDER BY total_sales desc;


 #        ___________________________________________________

# 10 منتجات ضعيفه

select product, sum(line_item_amount)as total_sales from coffee
GROUP BY product
order by total_sales ASC
limit 10;

 #        ___________________________________________________
# نسبه مساهمه كل categoryفي اجمالي المبيعات 

select product_category,
count(*)as total_orders,
sum(line_item_amount) as category_sales,
round(
sum(line_item_amount) / (select sum(line_item_amount) from coffee)*100
)as sales_percentage
from coffee
 GROUP BY product_category
 order by category_sales DESC
 limit 5;
 
 #   _________________________________________________________________________________________________