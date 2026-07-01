# DBT Fundamentals

## What is dbt?

dbt (Data Build Tool) is a transformation framework used in modern ELT pipelines. It enables Analytics Engineers to transform raw data already present in a data warehouse into clean, business-ready datasets using SQL.

dbt is **not** a data ingestion tool. It assumes that the data already exists inside the warehouse and focuses only on transformations.

---

## Why dbt?

* Version controlled SQL
* Modular transformations
* Dependency management
* Data testing
* Documentation generation
* Data lineage
* Reusable SQL using Jinja and Macros

---

## ELT Architecture

```
Source Systems
        │
        ▼
Snowflake (RAW)
        │
        ▼
dbt
        │
        ▼
STAGING
        │
        ▼
TRANSFORM
        │
        ▼
MART
```

---

## dbt Seed

Seeds are small static CSV files stored inside the `seeds/` directory.

Running:

```
dbt seed
```

loads the CSV files into Snowflake as tables.

Seeds are intended for:

* Reference data
* Lookup tables
* Small static datasets
* Demo projects
* Development environments

Seeds should **not** be used for large production datasets.

## Materializations

Materialization defines how dbt stores the result of a SQL model inside the data warehouse.

### View
- Stores only the SQL definition.
- Data is not physically stored.
- Always reflects the latest underlying data.
- Suitable for lightweight staging models.

### Table
- Stores the query result physically.
- Faster to query.
- Requires rebuilding when source data changes.
- Suitable for business-ready models and marts.

## ref()

The `ref()` function is used to reference another dbt model or seed.

Benefits:
- Builds dependencies between models
- Avoids hardcoded object names
- Enables lineage generation
- Determines model execution order

## REGEXP_REPLACE()

Used to clean strings using Regular Expressions.

Syntax:

REGEXP_REPLACE(
    subject,
    pattern,
    replacement,
    position,
    occurrence,
    parameters
)

Example:

REGEXP_REPLACE(
    order_timestamp,
    '(st|nd|rd|th)',
    '',
    1,
    0,
    'i'
)

Explanation:

- subject → string to modify
- pattern → regex to match
- replacement → replacement text
- position → starting character position
- occurrence → 0 means replace all matches
- parameters → 'i' enables case-insensitive matching

## Intermediate Models

Purpose:
- Store reusable business logic.
- Avoid duplicating SQL.
- Serve as a bridge between staging and marts.

Examples:
- Customer order summary
- Sales aggregations
- Product performance metrics
## Incremental Materialization

Purpose:
Avoid rebuilding the complete table on every execution.

Configuration:

{{ config(
    materialized='incremental',
    unique_key='customer_id'
) }}

Key Points:
- First run creates the table.
- Later runs merge new or changed records.
- `unique_key` identifies existing rows that should be updated.

Current Project:

```jinja
{{ config(
    materialized='incremental',
    unique_key='customer_id'
) }}

Key Learnings:

First execution behaves like a full table creation.
Later executions perform merge operations.
unique_key identifies existing records for updates.

### Schema Changes in Incremental Models

When new columns are added to an incremental model, the existing target table may not automatically include them.

During development, use:

dbt run --full-refresh

This forces dbt to recreate the table with the updated schema.

In production, schema changes should be planned carefully because incremental models prioritize updating data rather than rebuilding the entire table.

## Production Enhancements

### Incremental Materialization

```jinja
{{ config(
    materialized='incremental',
    unique_key='customer_id'
) }}
```

Purpose:
- Avoid rebuilding the complete table.
- Merge new or modified records using the configured unique key.

---

### Audit Metadata

`updated_at`

Stores the timestamp when the customer profile was generated.

Uses:

- Data freshness
- Pipeline auditing
- Incremental processing

---

### Active Customer

Business Definition:

A customer having at least one completed order.

Implementation:

```sql
CASE
WHEN total_orders_placed > 0
THEN TRUE
ELSE FALSE
END
```

---

### Row Hash

Purpose:

Generate a deterministic fingerprint of the business columns.

Benefits:

- Detect row-level changes
- Useful for Incremental Models
- Common in CDC pipelines
- Similar concept to ETag comparison used in metadata ingestion

---

### Incremental Model Development Tip

When adding new columns to an Incremental Model, use:

```bash
dbt run --full-refresh
```

Reason:

Existing Incremental tables are merged rather than recreated, so schema changes require a full rebuild.