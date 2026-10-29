-- Anadolu Home - KPI analysis queries (SQLite).
-- Each block starts with "-- name: <id> | <title>" and is run by scripts/run_analysis.py.

-- name: q1_monthly_kpis | Q1. Monthly revenue, orders and average order value (AOV)
WITH order_value AS (
    SELECT o.order_id, o.order_date, o.status,
           SUM(oi.quantity * oi.unit_price) AS value
    FROM orders o JOIN order_items oi USING (order_id)
    GROUP BY o.order_id
)
SELECT substr(order_date, 1, 7)                         AS month,
       COUNT(*)                                         AS orders,
       ROUND(SUM(CASE WHEN status = 'delivered' THEN value END)) AS net_revenue_try,
       ROUND(AVG(value))                                AS aov_try
FROM order_value
GROUP BY 1 ORDER BY 1;

-- name: q2_funnel | Q2. Conversion funnel (full year) and step-to-step drop-off
SELECT SUM(sessions)                                              AS sessions,
       SUM(product_views)                                         AS product_views,
       SUM(add_to_cart)                                           AS add_to_cart,
       SUM(checkout_started)                                      AS checkout_started,
       SUM(orders_placed)                                         AS orders_placed,
       ROUND(100.0 * SUM(orders_placed) / SUM(sessions), 2)       AS session_to_order_pct,
       ROUND(100.0 * (1 - SUM(orders_placed) * 1.0 / SUM(checkout_started)), 1) AS checkout_abandon_pct
FROM web_funnel;

-- name: q3_delay_vs_rating | Q3. Delivery delay vs. customer rating
SELECT CASE WHEN o.delivered_days - o.promised_days <= 0 THEN '1. On time / early'
            WHEN o.delivered_days - o.promised_days <= 2 THEN '2. 1-2 days late'
            ELSE '3. 3+ days late' END                    AS delivery_bucket,
       COUNT(*)                                           AS reviewed_orders,
       ROUND(AVG(r.rating), 2)                            AS avg_rating,
       ROUND(100.0 * SUM(r.rating <= 2) / COUNT(*), 1)    AS pct_1_2_stars
FROM orders o JOIN reviews r USING (order_id)
WHERE o.delivered_days IS NOT NULL
GROUP BY 1 ORDER BY 1;

-- name: q4_repeat_by_first_delivery | Q4. Repeat purchase rate by the delivery experience of the FIRST order
WITH first_order AS (
    SELECT o.customer_id, o.order_id, o.status,
           o.delivered_days - o.promised_days AS delay
    FROM orders o
    WHERE o.order_id = (SELECT MIN(order_id) FROM orders x WHERE x.customer_id = o.customer_id)
), n AS (
    SELECT customer_id, COUNT(*) AS n_orders FROM orders GROUP BY customer_id
)
SELECT CASE WHEN f.status = 'cancelled' THEN '0. First order cancelled'
            WHEN f.delay <= 0 THEN '1. On time / early'
            WHEN f.delay <= 2 THEN '2. 1-2 days late'
            ELSE '3. 3+ days late' END                    AS first_order_experience,
       COUNT(*)                                           AS customers,
       ROUND(100.0 * SUM(n.n_orders > 1) / COUNT(*), 1)   AS repeat_rate_pct
FROM first_order f JOIN n USING (customer_id)
GROUP BY 1 ORDER BY 1;

-- name: q5_returns_by_category | Q5. Return and cancellation rate by category (order lines)
SELECT p.category,
       COUNT(*)                                                       AS order_lines,
       ROUND(100.0 * SUM(o.status = 'returned')  / COUNT(*), 1)       AS return_rate_pct,
       ROUND(100.0 * SUM(o.status = 'cancelled') / COUNT(*), 1)       AS cancel_rate_pct,
       ROUND(100.0 * SUM(oi.quantity * (oi.unit_price - p.unit_cost))
             / SUM(oi.quantity * oi.unit_price), 1)                   AS gross_margin_pct
FROM order_items oi
JOIN orders   o USING (order_id)
JOIN products p USING (product_id)
GROUP BY p.category ORDER BY return_rate_pct DESC;

-- name: q6_city_delay | Q6. Average delay by city (top 6 worst) - logistics hotspots
SELECT c.city,
       COUNT(*)                                                 AS delivered_orders,
       ROUND(AVG(o.delivered_days - o.promised_days), 2)        AS avg_delay_days,
       ROUND(100.0 * SUM(o.delivered_days > o.promised_days) / COUNT(*), 1) AS pct_late
FROM orders o JOIN customers c USING (customer_id)
WHERE o.delivered_days IS NOT NULL
GROUP BY c.city ORDER BY avg_delay_days DESC LIMIT 6;

-- name: q7_channel | Q7. Acquisition channel quality: orders per customer and share of repeat buyers
WITH n AS (SELECT customer_id, COUNT(*) AS n_orders FROM orders GROUP BY customer_id)
SELECT c.acquisition_channel,
       COUNT(*)                                         AS customers,
       ROUND(AVG(n.n_orders), 2)                        AS orders_per_customer,
       ROUND(100.0 * SUM(n.n_orders > 1) / COUNT(*), 1) AS repeat_rate_pct
FROM customers c JOIN n USING (customer_id)
GROUP BY 1 ORDER BY repeat_rate_pct DESC;

-- name: q8_rfm | Q8. Simple RFM-style customer segments (as of 2025-12-31)
WITH cust AS (
    SELECT o.customer_id,
           CAST(julianday('2025-12-31') - julianday(MAX(o.order_date)) AS INT) AS recency_days,
           COUNT(DISTINCT o.order_id)                                          AS frequency,
           SUM(oi.quantity * oi.unit_price)                                    AS monetary
    FROM orders o JOIN order_items oi USING (order_id)
    WHERE o.status = 'delivered'
    GROUP BY o.customer_id
)
SELECT CASE WHEN frequency >= 3                          THEN 'Champions (3+ orders)'
            WHEN frequency = 2 AND recency_days <= 120   THEN 'Loyal (2 orders, recent)'
            WHEN frequency = 2                           THEN 'At risk (2 orders, lapsed)'
            WHEN recency_days <= 90                      THEN 'New (1 order, recent)'
            ELSE 'One-time, lapsed' END                  AS segment,
       COUNT(*)                                          AS customers,
       ROUND(SUM(monetary))                              AS revenue_try,
       ROUND(100.0 * SUM(monetary) / (SELECT SUM(monetary) FROM cust), 1) AS revenue_share_pct
FROM cust GROUP BY 1 ORDER BY revenue_try DESC;
