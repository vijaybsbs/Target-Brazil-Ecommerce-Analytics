-- ========================================================================================================================
-- PHASE 2 - DEMAND, GROWTH & SEASONALITY
-- ========================================================================================================================

-- ========================================================================================================================
-- Q3. Monthly Order Trend
-- ========================================================================================================================

select 
  extract(year from order_purchase_timestamp) as year,
  extract(month from order_purchase_timestamp) as month,
  count(*) as total_orders,
  min(date (order_purchase_timestamp)) as first_order_date,
  max(date (order_purchase_timestamp)) as last_order_date
 from `target-508623.target_brazil_ecommerce.orders`
 group by 1,2
 order by 1,2 

-- ========================================================================================================================
-- Q4. Seasonality
-- ========================================================================================================================

SELECT
  extract(year from order_purchase_timestamp) as year_,
  extract(month from order_purchase_timestamp) as month_,
  count(*) as total_orders,
  count(distinct order_id) as total_unique_orders
from `target-508623.target_brazil_ecommerce.orders`
group by 1,2
order by 1,2

-- ========================================================================================================================
-- Q5. Order Time-of-Day Analysis
-- 0-6 hrs : Dawn
-- 7-12 hrs : Mornings
-- 13-18 hrs : Afternoon
-- 19-23 hrs : Night
-- ========================================================================================================================

select 
case 
  when extract(hour from order_purchase_timestamp) between 0 and 6 then 'Dawn'
  when extract(hour from order_purchase_timestamp) between 7 and 12 then 'Morning'
  when extract(hour from order_purchase_timestamp) between 13 and 18 then 'Afternoon'
  else 'Night'
  end as time_of_order,
count(*) as order_count,
sum(count(*)) over() as total_orders, 
round(count(*) * 100 / sum(count(*)) over(), 2) as percentage_of_total
from `target-508623.target_brazil_ecommerce.orders`
group by time_of_order
order by order_count desc
