SELECT
    order_id,
    user_id AS customer_id,
    order_timestamp
    status,
    amount
FROM
    {{ref('raw_orders')}}

