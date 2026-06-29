SELECT
    id AS customer_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,
    LOWER(TRIM(email)) AS email,
    signup_date
FROM
    {{ref('raw_customers')}}