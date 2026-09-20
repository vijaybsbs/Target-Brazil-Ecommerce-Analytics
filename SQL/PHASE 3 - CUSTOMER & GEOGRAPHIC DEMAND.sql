-- ========================================================================================================================
-- PHASE 3 - CUSTOMER & GEOGRAPHIC DEMAND
-- ========================================================================================================================

-- ========================================================================================================================
-- Q6A — Geographic Order Concentration by State
-- ========================================================================================================================

select *, round(sum(state_perc) over(rows between unbounded preceding and current row),2) as cum_per
from
(
select 
  c.customer_state,
  count(distinct o.order_id) as order_count,
  sum(count(distinct c.customer_id)) over() as total_orders,
  round (count(distinct o.order_id) *100 / sum(count(distinct c.customer_id)) over(),2) as state_perc
from `target-508623.target_brazil_ecommerce.customers` c
join `target-508623.target_brazil_ecommerce.orders` o
on c.customer_id = o.customer_id
 group by c.customer_state
 order by count(distinct c.customer_id) desc
)

-- ========================================================================================================================
-- Q6B — Geographic coverage
-- ========================================================================================================================

select *, round(sum(city_perc) over(rows between unbounded preceding and current row),2) as cum_perc,
from
(
select 
  c.customer_state,
  c.customer_city,
  count(distinct o.order_id) as order_count,
  sum(count(distinct c.customer_id)) over() as total_orders,
  round (count(distinct o.order_id) *100 / sum(count(distinct c.customer_id)) over(),2) as city_perc,
from `target-508623.target_brazil_ecommerce.customers` c
join `target-508623.target_brazil_ecommerce.orders` o
on c.customer_id = o.customer_id
 group by c.customer_state,c.customer_city
 order by city_perc desc, customer_state, customer_city
)

-- ========================================================================================================================
-- Q7 — State-Level Order Fulfillment Performance
-- ========================================================================================================================

select 
  c.customer_state,

  count(distinct o.order_id) as total_orders,
  
  count(distinct case when o.order_status = 'delivered' then o.order_id end) as delivered_orders,

  count(distinct case when o.order_status <> 'delivered' then o.order_id end) as non_delivered_orders,

  round(count(distinct case when o.order_status = 'delivered' then o.order_id end) *100 / count(distinct o.order_id), 2) as delivery_rate

from `target-508623.target_brazil_ecommerce.customers` c
join `target-508623.target_brazil_ecommerce.orders` o

on c.customer_id = o.customer_id
  
  group by c.customer_state
  order by total_orders desc;
