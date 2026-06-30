SELECT
    customer_id,
    MIN(order_timestamp) AS first_order_date,
    MAX(order_timestamp) AS most_recent_order_date,
    COUNT(order_id) AS total_orders_placed,
    SUM(amount) AS customer_lifetime_value

FROM {{ ref('stg_orders') }}
GROUP BY customer_id