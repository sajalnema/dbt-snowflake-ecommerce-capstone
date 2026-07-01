{% snapshot dim_customers_snapshot %}

{{
    config(
        target_schema='MART',
        unique_key='customer_id',

        strategy='check',

        check_cols=[
            'row_hash'
        ]
    )
}}

SELECT *
FROM {{ ref('dim_customers') }}

{% endsnapshot %}