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
