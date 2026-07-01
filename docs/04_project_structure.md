# Project Structure

## Repository Structure

```text
datasets/
docs/
ecommerce_capstone/
```

- **datasets/** → Original source CSV files.
- **docs/** → Engineering documentation and interview notes.
- **ecommerce_capstone/** → Actual dbt project.

---

# dbt Project Structure

```text
dbt_project.yml
models/
seeds/
macros/
tests/
snapshots/
analyses/
```

## `dbt_project.yml`

Acts as the central configuration file for the dbt project.

### Responsibilities

- Project configuration
- Model locations
- Seed locations
- Test locations
- Materialization configuration

---

# Seeds

The `seeds/` directory contains static CSV files consumed by dbt.

### Current Project

- `raw_customers.csv`
- `raw_orders.csv`

These files are loaded into Snowflake using:

```bash
dbt seed
```

---

# Layer Responsibilities

## RAW

Stores the source data exactly as received without applying transformations.

## STAGING

Standardizes raw data by:

- Renaming columns
- Normalizing values
- Cleaning whitespace
- Parsing datatypes
- Preserving all business information

The staging layer should **avoid**:

- Business calculations
- Aggregations
- KPIs
- Metrics

These belong to the Transform layer.

## TRANSFORM

The Transform layer converts cleaned operational data into reusable business metrics.

Typical operations:

- Aggregations
- Business KPIs
- Reusable calculations
- Joins between staging models

Avoid:

- Final reporting tables
- Dashboard-specific models

## MART

Provides analytics-ready fact and dimension tables for BI tools and reporting.

Purpose:

- Expose business-ready datasets
- Combine reusable business metrics
- Build reporting-friendly tables
- Power BI / Tableau ready

### Models

#### `fact_orders`

- One row per order
- Uses cleaned staging orders

#### `dim_customers`

- One row per customer
- Combines customer attributes with aggregated order metrics

---

# Production Enhancement

The customer dimension was converted from a standard table into an Incremental Model.

## Benefits

- Faster execution for large datasets
- Avoids rebuilding the complete table
- Supports merge-based updates using `customer_id`

## Production Enhancements

### `dim_customers`

- Incremental Materialization
- Active Customer Flag
- Audit Timestamp
- Row Hash

### Purpose

Make the mart suitable for production-scale incremental processing while supporting auditing and change detection.
## Data Quality Layer

Model Tests

staging/schema.yml

- customer_id → unique, not_null
- email → not_null
- order_id → unique, not_null
- customer_id → relationships

transform/schema.yml

- customer_id → unique, not_null

marts/schema.yml

dim_customers
- customer_id → unique, not_null

fact_orders
- order_id → unique, not_null
- customer_id → relationships
## Snapshot Layer

Purpose

Maintain historical versions of customer profiles.

Flow

dim_customers
        │
        ▼
dim_customers_snapshot

Current-state data remains in the mart.

Historical versions are preserved in the snapshot.



## Source Layer

External Data

↓

raw.raw_customers

raw.raw_orders

↓

Staging

↓

Transform

↓

Mart

↓

Snapshot

The Source layer represents externally managed raw data.
For reproducibility in this capstone, source tables are populated using dbt seed.