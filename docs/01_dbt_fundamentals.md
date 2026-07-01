# DBT Fundamentals

## What is dbt?

dbt (Data Build Tool) is a transformation framework used in modern ELT pipelines. It enables Analytics Engineers to transform raw data already present in a data warehouse into clean, business-ready datasets using SQL.

dbt is **not** a data ingestion tool. It assumes that the data already exists inside the warehouse and focuses only on transformations.

---

## Why dbt?

- Version controlled SQL
- Modular transformations
- Dependency management
- Data testing
- Documentation generation
- Data lineage
- Reusable SQL using Jinja and Macros

---

## ELT Architecture

```text
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

# dbt Seed

Seeds are small static CSV files stored inside the `seeds/` directory.

Running:

```bash
dbt seed
```

loads the CSV files into Snowflake as tables.

Seeds are intended for:

- Reference data
- Lookup tables
- Small static datasets
- Demo projects
- Development environments

Seeds should **not** be used for large production datasets.

---

# Materializations

Materialization defines how dbt stores the result of a SQL model inside the data warehouse.

## View

- Stores only the SQL definition.
- Data is not physically stored.
- Always reflects the latest underlying data.
- Suitable for lightweight staging models.

## Table

- Stores the query result physically.
- Faster to query.
- Requires rebuilding when source data changes.
- Suitable for business-ready models and marts.

---

# ref()

The `ref()` function is used to reference another dbt model or seed.

Benefits:

- Builds dependencies between models
- Avoids hardcoded object names
- Enables lineage generation
- Determines model execution order

---

# REGEXP_REPLACE()

Used to clean strings using Regular Expressions.

Syntax:

```sql
REGEXP_REPLACE(
    subject,
    pattern,
    replacement,
    position,
    occurrence,
    parameters
)
```

Example:

```sql
REGEXP_REPLACE(
    order_timestamp,
    '(st|nd|rd|th)',
    '',
    1,
    0,
    'i'
)
```

Explanation:

- **subject** → string to modify
- **pattern** → regex to match
- **replacement** → replacement text
- **position** → starting character position
- **occurrence** → `0` means replace all matches
- **parameters** → `'i'` enables case-insensitive matching

---

# Intermediate Models

Purpose:

- Store reusable business logic.
- Avoid duplicating SQL.
- Serve as a bridge between staging and marts.

Examples:

- Customer order summary
- Sales aggregations
- Product performance metrics

---

# Incremental Materialization

Purpose:

Avoid rebuilding the complete table on every execution.

Basic Configuration:

```jinja
{{ config(
    materialized='incremental',
    unique_key='customer_id'
) }}
```

Key Learnings:

- First execution behaves like a full table creation.
- Later executions perform merge operations.
- `unique_key` identifies existing records for updates.

---

## Schema Changes in Incremental Models

When new columns are added to an incremental model, the existing target table may not automatically include them.

During development, use:

```bash
dbt run --full-refresh
```

This forces dbt to recreate the table with the updated schema.

In production, schema changes should be planned carefully because incremental models prioritize updating data rather than rebuilding the entire table.

---

# Production Enhancements

## Incremental Materialization

```jinja
{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='customer_id',
        on_schema_change='sync_all_columns'
    )
}}
```

### `materialized='incremental'`

Stores the model as a physical table and updates existing records instead of rebuilding the table.

### `incremental_strategy='merge'`

Uses Snowflake's `MERGE` statement to:

- Update existing customers
- Insert new customers

### `unique_key='customer_id'`

Identifies which existing row should be updated during merge operations.

### `on_schema_change='sync_all_columns'`

Synchronizes schema changes when columns are added or removed, reducing manual intervention during development and production deployments.

---

## Audit Metadata

### `updated_at`

Stores the timestamp when the customer profile was generated.

Uses:

- Auditability
- Freshness Tracking
- Operational Monitoring
- Data freshness
- Pipeline auditing
- Incremental processing

---

## Active Customer

### Business Rule

A customer is considered active if they have placed at least one completed order.

Implementation:

```sql
CASE
    WHEN total_orders_placed > 0
    THEN TRUE
    ELSE FALSE
END
```

Purpose:

Makes downstream reporting simpler by exposing a reusable business flag.

---

## Row Hash

Purpose:

Generate a deterministic fingerprint of the business state of a customer.

Implementation:

- Uses `MD5()`
- Uses `CONCAT_WS('|', ...)`
- Handles NULL values using `COALESCE()`

Benefits:

- Efficient row-level change detection
- Detect row-level changes
- Useful for Incremental Models
- Useful for dbt Snapshots
- Commonly used in CDC pipelines
- Similar concept to ETag comparison used in metadata ingestion
- Avoids comparing every column individually

---

## Incremental Model Development Tip

When adding new columns to an Incremental Model, use:

```bash
dbt run --full-refresh
```

Reason:

Existing Incremental tables are merged rather than recreated, so schema changes require a full rebuild.

---

# Understanding `is_incremental()`

## Important Learning

Incremental Materialization and `is_incremental()` solve different problems.

### Incremental Materialization

- Controls how dbt stores model results.
- Updates existing rows using the configured `unique_key`.

### `is_incremental()`

- Controls which source rows are read.
- Requires a reliable source-side change indicator such as:
  - `last_modified_at`
  - `updated_at`
  - CDC stream

### Current Project

The provided dataset does not contain a source-side modification timestamp.

Therefore, an additional `is_incremental()` filter would risk missing valid business updates (for example, changes to Customer Lifetime Value).

The project intentionally demonstrates Incremental Materialization without source filtering.

## Data Quality Testing

dbt provides Generic Tests that validate data quality after models are built.

These tests are implemented as SQL queries. A test passes when the generated query returns **zero rows**.

### Tests Used

#### unique

Ensures duplicate business keys do not exist.

Example:

```yaml
tests:
  - unique
```

---

#### not_null

Ensures mandatory fields always contain a value.

Example:

```yaml
tests:
  - not_null
```

---

#### relationships

Ensures referential integrity between related models.

Example:

```yaml
tests:
  - relationships:
      to: ref('stg_customers')
      field: customer_id
```

---

### Execution Flow

dbt build

↓

Seeds

↓

Models

↓

Tests

Therefore, tests always execute after the corresponding models have been created.