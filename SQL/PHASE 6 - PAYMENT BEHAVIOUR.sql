-- ========================================================================================================================
-- PHASE 6 - PAYMENT BEHAVIOUR
-- ========================================================================================================================

-- ========================================================================================================================
-- Q15 — Payment Methods & Monthly Payment Trends.
-- How did payment methods and payment value evolve month by month, and which payment methods were most commonly used?
-- ========================================================================================================================

select p.payment_type,
extract (year from o.order_purchase_timestamp) as year,
extract (month from o.order_purchase_timestamp) as month,
round(sum(p.payment_value),2) as order_value, 
count(distinct o.order_id) as orders_using_payment_type
from `target-508623.target_brazil_ecommerce.payments` p
join `target-508623.target_brazil_ecommerce.orders` o
on p.order_id = o.order_id
group by p.payment_type, year, month
order by year, month, order_value desc;

-- ========================================================================================================================
-- Q16 — Installment Behaviour
-- How are orders distributed across different numbers of payment installments?
-- ========================================================================================================================

SELECT
CASE
    WHEN payment_installments = 0 THEN 'zero_installment'
    WHEN payment_installments = 1 THEN 'single_term'
    WHEN payment_installments BETWEEN 2 AND 3 THEN 'short_term'
    WHEN payment_installments BETWEEN 4 AND 6 THEN 'medium_term'
    WHEN payment_installments BETWEEN 7 AND 12 THEN 'long_term'
    WHEN payment_installments BETWEEN 13 AND 24 THEN 'very_long_term'
    ELSE 'other'
END AS payment_term,
  count(distinct order_id) as orders_using_installment_term,
  round(sum(payment_value),2) as total_value

FROM `target-508623.target_brazil_ecommerce.payments`

where payment_type = 'credit_card'
group by 1
order by 3 desc

