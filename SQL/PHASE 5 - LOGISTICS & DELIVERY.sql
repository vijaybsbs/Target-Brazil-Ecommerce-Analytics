-- ========================================================================================================================
-- PHASE 5 - LOGISTICS & DELIVERY
-- ========================================================================================================================

-- ========================================================================================================================
-- Q11A — Delivery Duration 
-- How long does it take for orders to reach customers, and how does delivery duration vary across states?
-- ========================================================================================================================

WITH delivery_dur as
(
select
customer_id,
order_id,
timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, hour)/24 as delivery_days
from `target-508623.target_brazil_ecommerce.orders` 
where order_status = 'delivered' and order_delivered_customer_date is not null
)
select 
COUNT(*) AS delivered_orders,
round(avg(delivery_days),2) as avg_delivery_days
from delivery_dur dd
order by avg_delivery_days desc

-- ========================================================================================================================
-- Q11B — Delivery Duration across states
-- How long does it take for orders to reach customers, and how does delivery duration vary across states?
-- ========================================================================================================================

WITH delivery_dur as
(
select
customer_id,
order_id,
timestamp_diff(order_delivered_customer_date, order_purchase_timestamp, hour)/24 as delivery_days
from `target-508623.target_brazil_ecommerce.orders` 
where order_status = 'delivered' and order_delivered_customer_date is not null
)
select 
c.customer_state,
COUNT(*) AS delivered_orders,
round(avg(delivery_days),2) as avg_delivery_days
from delivery_dur dd
join `target-508623.target_brazil_ecommerce.customers` c
on dd.customer_id = c.customer_id
group by c.customer_state
order by avg_delivery_days desc

-- ========================================================================================================================
-- Q12 — Actual vs Estimated Delivery Performance
-- How accurately did Target Brazil deliver orders compared with the estimated delivery date?
-- ========================================================================================================================

WITH delivery_performance AS (
  SELECT
    order_id,
    TIMESTAMP_DIFF(
      order_delivered_customer_date,
      order_estimated_delivery_date,
      hour
    )/24 AS delivery_variance_days
  FROM `target-508623.target_brazil_ecommerce.orders`
  WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
)

SELECT
  COUNT(*) AS delivered_orders,

  COUNTIF(delivery_variance_days < 0) AS early_orders,

  COUNTIF(delivery_variance_days = 0) AS on_time_orders,

  COUNTIF(delivery_variance_days > 0) AS late_orders,

  ROUND(
    COUNTIF(delivery_variance_days < 0) * 100.0 / COUNT(*),
    2
  ) AS early_percentage,

  ROUND(
    COUNTIF(delivery_variance_days = 0) * 100.0 / COUNT(*),
    2
  ) AS on_time_percentage,

  ROUND(
    COUNTIF(delivery_variance_days > 0) * 100.0 / COUNT(*),
    2
  ) AS late_percentage,

  ROUND(AVG(delivery_variance_days), 2) AS avg_delivery_variance_days

FROM delivery_performance;

-- ========================================================================================================================
-- Q13 — State-Level Logistics Performance
-- How does logistics performance vary across Brazilian states in terms of freight cost, delivery speed, and ETA accuracy?
-- Do states with higher freight costs also experience longer delivery times or larger ETA deviations?
-- ========================================================================================================================

WITH payment_values AS (
  SELECT
    o.customer_id,
    o.order_id,
    SUM(p.payment_value) AS total_order_value
  FROM `target-508623.target_brazil_ecommerce.orders` o
  JOIN `target-508623.target_brazil_ecommerce.payments` p
    ON o.order_id = p.order_id
  GROUP BY
    o.customer_id,
    o.order_id
),

freight_values AS (
  SELECT
    order_id,
    SUM(freight_value) AS total_freight_cost
  FROM `target-508623.target_brazil_ecommerce.order_items`
  GROUP BY order_id
),

delivery_dur AS (
  SELECT
    order_id,

    TIMESTAMP_DIFF(
      order_delivered_customer_date,
      order_purchase_timestamp,
      HOUR
    ) / 24.0 AS delivery_days,

    TIMESTAMP_DIFF(
      order_delivered_customer_date,
      order_estimated_delivery_date,
      HOUR
    ) / 24.0 AS delivery_variance_days

  FROM `target-508623.target_brazil_ecommerce.orders`
  WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
)

SELECT
  c.customer_state AS state,

  COUNT(DISTINCT dd.order_id) AS order_count,

  ROUND(SUM(pv.total_order_value), 2) AS total_order_value,

  ROUND(SUM(fv.total_freight_cost), 2) AS total_freight_cost,

  ROUND(
    SUM(fv.total_freight_cost) * 100.0
    / SUM(pv.total_order_value),
    2
  ) AS freight_to_order_value_pct,

  ROUND(AVG(dd.delivery_days), 2) AS avg_delivery_days,

  ROUND(AVG(dd.delivery_variance_days), 2)
    AS avg_delivery_variance_days

FROM payment_values pv

JOIN freight_values fv
  ON pv.order_id = fv.order_id

JOIN `target-508623.target_brazil_ecommerce.customers` c
  ON pv.customer_id = c.customer_id

LEFT JOIN delivery_dur dd
  ON pv.order_id = dd.order_id

GROUP BY c.customer_state

ORDER BY freight_to_order_value_pct DESC;

-- ========================================================================================================================
-- Q14 — Freight Cost vs Delivery Time
-- Is there an association between freight cost and delivery time across Brazilian states?
-- ========================================================================================================================

WITH freight_per_order AS (
  SELECT
    order_id,
    SUM(freight_value) AS total_freight
  FROM `target-508623.target_brazil_ecommerce.order_items`
  GROUP BY order_id
),

delivery_per_order AS (
  SELECT
    order_id,
    TIMESTAMP_DIFF(
      order_delivered_customer_date,
      order_purchase_timestamp,
      HOUR
    ) / 24.0 AS delivery_days
  FROM `target-508623.target_brazil_ecommerce.orders`
  WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
),

state_metrics AS (
  SELECT
    c.customer_state AS state,
    COUNT(*) AS order_count,
    AVG(fp.total_freight) AS avg_freight_per_order,
    AVG(dp.delivery_days) AS avg_delivery_days

  FROM `target-508623.target_brazil_ecommerce.orders` o

  JOIN freight_per_order fp
    ON o.order_id = fp.order_id

  JOIN delivery_per_order dp
    ON o.order_id = dp.order_id

  JOIN `target-508623.target_brazil_ecommerce.customers` c
    ON o.customer_id = c.customer_id

  GROUP BY c.customer_state
)

SELECT
  ROUND(
    CORR(
      avg_freight_per_order,
      avg_delivery_days
    ),
    3
  ) AS freight_delivery_correlation
FROM state_metrics;




