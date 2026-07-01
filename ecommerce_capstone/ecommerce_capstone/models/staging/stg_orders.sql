SELECT
    order_id,
    user_id AS customer_id,
    TO_TIMESTAMP(
        REGEXP_REPLACE(
            order_timestamp,
            '(st|nd|rd|th)',
            ''
        ),
        'DD MMMM YYYY HH24:MI:SS'
    ) AS order_timestamp,

    CASE
        WHEN status = 1 THEN 'Completed'
        WHEN status = 2 THEN 'Returned'
        ELSE 'Cancelled'
    END AS status,

    amount
FROM
    {{source('raw', 'raw_orders')}}

WHERE user_id IS NOT NULL