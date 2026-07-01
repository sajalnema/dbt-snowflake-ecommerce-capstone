{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='customer_id',
        on_schema_change='sync_all_columns'
    )
}}

WITH customer_profile AS (

    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.signup_date,
        o.first_order_date,
        o.most_recent_order_date,
        COALESCE(o.total_orders_placed, 0) AS total_orders_placed,
        COALESCE(o.customer_lifetime_value, 0) AS customer_lifetime_value,
        CASE
            WHEN COALESCE(o.total_orders_placed, 0) > 0
            THEN TRUE
            ELSE FALSE
        END AS active_customer,

        CURRENT_TIMESTAMP() AS updated_at

    FROM {{ ref('stg_customers') }} c

    LEFT JOIN {{ ref('int_customer_order_summary') }} o
        ON c.customer_id = o.customer_id

)

SELECT
    *,
    MD5(
        CONCAT_WS(
            '|',
            COALESCE(customer_id::VARCHAR, ''),
            COALESCE(first_name, ''),
            COALESCE(last_name, ''),
            COALESCE(email, ''),
            COALESCE(signup_date::VARCHAR, ''),
            COALESCE(first_order_date::VARCHAR, ''),
            COALESCE(most_recent_order_date::VARCHAR, ''),
            COALESCE(total_orders_placed::VARCHAR, '0'),
            COALESCE(customer_lifetime_value::VARCHAR, '0'),
            COALESCE(active_customer::VARCHAR, '')
        )
    ) AS row_hash

FROM customer_profile