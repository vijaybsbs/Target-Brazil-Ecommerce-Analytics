-- ========================================================================================================================
-- PHASE 7 - CUSTOMER EXPERIENCE
-- ========================================================================================================================

-- ========================================================================================================================
-- Q17 — Customer Satisfaction / Review Analysis
-- How satisfied are customers based on their review scores?
-- ========================================================================================================================

WITH review_metrics as
(
select 
review_score, 
count(*) total_reviews
from `target-508623.target_brazil_ecommerce.order_reviews`
group by 1
)
select 
rm.review_score,
rm.total_reviews,
round(rm.total_reviews *100 / sum(rm.total_reviews) over(), 2) as share_pct
from review_metrics rm
order by 3 desc

-- ========================================================================================================================
-- Q18 — Delivery Performance vs Customer Review Score
-- Is delivery performance associated with customer review scores?
-- ========================================================================================================================

WITH delivery_performance AS (
  SELECT
    o.order_id,
    CASE
      WHEN DATE(o.order_delivered_customer_date)
           < DATE(o.order_estimated_delivery_date)
        THEN 'early'

      WHEN DATE(o.order_delivered_customer_date)
           = DATE(o.order_estimated_delivery_date)
        THEN 'on_time'

      WHEN DATE(o.order_delivered_customer_date)
           > DATE(o.order_estimated_delivery_date)
        THEN 'late'
    END AS delivery_performance
  FROM `target-508623.target_brazil_ecommerce.orders` o
  WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
    AND o.order_estimated_delivery_date IS NOT NULL
),

review_data AS (
  SELECT
    dp.order_id,
    dp.delivery_performance,
    CASE
      WHEN r.review_score BETWEEN 1 AND 2 THEN 'bad'
      WHEN r.review_score BETWEEN 3 AND 4 THEN 'good'
      WHEN r.review_score = 5 THEN 'excellent'
    END AS review_category
  FROM delivery_performance dp
  JOIN `target-508623.target_brazil_ecommerce.order_reviews` r
    ON dp.order_id = r.order_id
),

category_counts AS (
  SELECT
    delivery_performance,
    review_category,
    COUNT(DISTINCT order_id) AS order_count
  FROM review_data
  GROUP BY
    delivery_performance,
    review_category
),

delivery_totals AS (
  SELECT
    delivery_performance,
    COUNT(DISTINCT order_id) AS total_reviewed_orders
  FROM review_data
  GROUP BY delivery_performance
)

SELECT
  cc.delivery_performance,
  cc.review_category,
  cc.order_count,
  dt.total_reviewed_orders,
  ROUND(
    cc.order_count * 100.0 / dt.total_reviewed_orders,
    2
  ) AS review_share_pct
FROM category_counts cc
JOIN delivery_totals dt
  ON cc.delivery_performance = dt.delivery_performance
ORDER BY
  CASE cc.delivery_performance
    WHEN 'early' THEN 1
    WHEN 'on_time' THEN 2
    WHEN 'late' THEN 3
  END,
  CASE cc.review_category
    WHEN 'bad' THEN 1
    WHEN 'good' THEN 2
    WHEN 'excellent' THEN 3
  END;