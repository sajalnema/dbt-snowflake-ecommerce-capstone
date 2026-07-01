# Project Structure

## Repository Structure

```
datasets/
docs/
ecommerce_capstone/
```

* **datasets/** → Original source CSV files.
* **docs/** → Engineering documentation and interview notes.
* **ecommerce_capstone/** → Actual dbt project.

---

## dbt Project Structure

```
dbt_project.yml
models/
seeds/
macros/
tests/
snapshots/
analyses/
```

### dbt_project.yml

Acts as the central configuration file for the dbt project.

Responsibilities:

* Project configuration
* Model locations
* Seed locations
* Test locations
* Materialization configuration

---

## Seeds

The `seeds/` directory contains static CSV files consumed by dbt.

Current project:

* raw_customers.csv
* raw_orders.csv

These files are loaded into Snowflake using:

```
dbt seed
```


## Layer Responsibilities

### RAW
Stores the source data exactly as received without applying transformations.

### STAGING
Standardizes raw data by renaming columns, normalizing values, and applying lightweight cleaning while preserving all business information.

### TRANSFORM
Applies business logic such as aggregations, metrics, and reusable calculations.

### MART
Provides analytics-ready fact and dimension tables for BI tools and reporting.

## Staging Layer Principles

The staging layer is responsible for:

- Renaming columns
- Standardizing values
- Cleaning whitespace
- Normalizing text
- Preserving business information

The staging layer should avoid business-specific calculations and should not remove useful information from the source data.
## Responsibilities of the Staging Layer

Purpose:

- Standardize data
- Rename columns
- Normalize text
- Parse datatypes
- Remove invalid records

Avoid:

- Business calculations
- Aggregations
- KPIs
- Metrics

These belong to the Transform layer.

## Transform Layer Responsibilities

The transform layer converts cleaned operational data into reusable business metrics.

Typical operations:
- Aggregations
- Business KPIs
- Reusable calculations
- Joins between staging models

Avoid:
- Final reporting tables
- Dashboard-specific models
## Mart Layer Responsibilities

Purpose:
- Expose business-ready datasets
- Combine reusable business metrics
- Build reporting-friendly tables
- Power BI / Tableau ready

Models:

fact_orders
- One row per order
- Uses cleaned staging orders

dim_customers
- One row per customer
- Combines customer attributes with aggregated order metrics