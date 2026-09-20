-- ========================================================================================================================
-- PHASE 1 - DATA QUALITY & INTEGRITY
-- ========================================================================================================================

-- ========================================================================================================================
-- Q1. Table Profiling
-- Find row counts and identify the primary/key columns.
-- ========================================================================================================================

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM `target_brazil_ecommerce.customers`
UNION ALL
SELECT 'geolocation' AS table_name, COUNT(*) AS row_count
FROM `target_brazil_ecommerce.geolocation`
UNION ALL
SELECT 'order_items' AS table_name, COUNT(*) AS row_count
FROM `target_brazil_ecommerce.order_items`
UNION ALL
SELECT 'order_reviews' AS table_name, COUNT(*) AS row_count
FROM `target_brazil_ecommerce.order_reviews`
UNION ALL
SELECT 'orders' AS table_name, COUNT(*) AS row_count
FROM `target_brazil_ecommerce.orders`
UNION ALL
SELECT 'payments' AS table_name, COUNT(*) AS row_count
FROM `target_brazil_ecommerce.payments`
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS row_count
FROM `target_brazil_ecommerce.products`
UNION ALL
SELECT 'sellers' AS table_name, COUNT(*) AS row_count
FROM `target_brazil_ecommerce.sellers`

-- ========================================================================================================================
-- Q2A. NULL / Missing-value audit
-- ========================================================================================================================
SELECT
  COUNT(*) AS row_count,
  countif(order_id IS NULL) AS null_order_id,
  countif(customer_id IS NULL) AS null_customer_id,
  countif(order_status IS NULL) AS null_order_status,
  countif(order_purchase_timestamp IS NULL) AS null_order_pur,
  countif(order_approved_at IS NULL) AS null_order_approved,
  countif(order_delivered_carrier_date IS NULL) AS null_order_del_date,
  countif(order_delivered_customer_date is NULL) as null_del_cust_date,
  countif(order_estimated_delivery_date IS NULL) AS null_order_est_date
FROM `target_brazil_ecommerce.orders`

-- ========================================================================================================================
-- Q2B. NULL Value Investigation
-- ========================================================================================================================

SELECT
  order_status,
  COUNT(*) AS total_orders,
  countif(order_approved_at IS NULL) AS null_order_approved,
  countif(order_delivered_carrier_date IS NULL) AS null_order_del_date,
  countif(order_delivered_customer_date is NULL) as null_del_cust_date
FROM `target_brazil_ecommerce.orders`
GROUP BY order_status

