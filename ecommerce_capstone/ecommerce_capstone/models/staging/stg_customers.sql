SELECT
    id AS customer_id,
    INITCAP(TRIM(first_name)) AS first_name,
    INITCAP(TRIM(last_name)) AS last_name,
    LOWER(TRIM(email)) AS email,
    CAST(signup_date AS DATE) AS signup_date
FROM
    {{source('raw', 'raw_customers')}}
WHERE
    email IS NOT NULL