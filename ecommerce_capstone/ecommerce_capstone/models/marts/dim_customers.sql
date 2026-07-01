{{config(
    materialized='incremental',
    unique_key='customer_id',
)}}
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.signup_date,
    o.first_order_date,
    o.most_recent_order_date,
    COALESCE(o.total_orders_placed, 0) AS total_orders_placed,
    COALESCE(o.customer_lifetime_value, 0) AS customer_lifetime_value
FROM 
    {{ ref('stg_customers') }} c
LEFT JOIN 
    {{ ref('int_customer_order_summary') }} o

ON c.customer_id = o.customer_id