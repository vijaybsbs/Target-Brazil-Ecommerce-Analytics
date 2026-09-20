-- ========================================================================================================================
-- PHASE 4 - ORDER VALULE & UNIT ECONOMICS
-- ========================================================================================================================

-- ========================================================================================================================
-- Q8 — Order Value Evolution
-- ========================================================================================================================

select 
  c.customer_state,
  count(distinct p.order_id) as total_orders,
  round(sum(p.payment_value),2) as total_payment,
  round(sum(p.payment_value) / count(distinct o.order_id),2) as AOV
from `target-508623.target_brazil_ecommerce.payments` p
join `target-508623.target_brazil_ecommerce.orders` o
on p.order_id = o.order_id
join `target-508623.target_brazil_ecommerce.customers` c
on o.customer_id = c.customer_id
group by c.customer_state
order by total_payment desc;

-- ========================================================================================================================
-- Q9 — State-Level Order Value
-- How does monetary value vary across states, and how does average order value differ?
-- ========================================================================================================================

select 
  c.customer_state,
  count(distinct p.order_id) as total_orders,
  round(sum(p.payment_value),2) as total_payment,
  round(sum(p.payment_value) / count(distinct o.order_id),2) as AOV
from `target-508623.target_brazil_ecommerce.payments` p
join `target-508623.target_brazil_ecommerce.orders` o
on p.order_id = o.order_id
join `target-508623.target_brazil_ecommerce.customers` c
on o.customer_id = c.customer_id
group by c.customer_state
order by total_payment desc;

-- ========================================================================================================================
-- Q10 — Freight Cost Burden
-- How significant is freight cost relative to order value across Brazilian states?
-- ========================================================================================================================

WITH payment_values AS 
(

select
o.customer_id,
o.order_id,
count(o.order_id) as order_count,
sum(p.payment_value) as total_order_value,

from `target-508623.target_brazil_ecommerce.orders` as o 
join `target-508623.target_brazil_ecommerce.payments` p 
on o.order_id = p.order_id

group by o.customer_id, o.order_id
),
freight_values AS
(
  select order_id,
  sum(freight_value) as freight_cost
from `target-508623.target_brazil_ecommerce.order_items`
group by order_id
)
select 
c.customer_state as state,
round(sum(pv.total_order_value),2) as total_order_value,
round(sum(fv.freight_cost),2) as total_freight_cost,
round(sum(fv.freight_cost)*100 / sum(pv.total_order_value),2) as freight_to_order_value_pct
from payment_values pv

join freight_values fv
  on pv.order_id = fv.order_id

join `target-508623.target_brazil_ecommerce.customers` c
on pv.customer_id = c.customer_id


group by c.customer_state
order by freight_to_order_value_pct desc

