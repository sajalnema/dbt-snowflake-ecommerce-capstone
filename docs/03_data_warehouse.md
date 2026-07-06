# Data Warehouse Concepts

## What is a Data Warehouse?

A Data Warehouse is a centralized analytical database used for reporting and business intelligence.

Unlike OLTP systems, a warehouse is optimized for reading and aggregating large datasets.

---

## OLTP vs OLAP

| OLTP | OLAP |
|------|------|
| Transactional | Analytical |
| Many inserts/updates | Mostly reads |
| Normalized | Denormalized |
| Current data | Historical + analytical |

---

## ELT Pipeline

Extract

↓

Load

↓

Transform (dbt)

In this project:

CSV

↓

Snowflake RAW

↓

Staging

↓

Transform

↓

Mart

↓

Snapshot

---

## Warehouse Layers

### RAW

Stores original data exactly as received.

Purpose

- Auditing
- Reprocessing
- Data recovery

---

### STAGING

Purpose

- Clean data
- Rename columns
- Normalize formats
- Remove invalid records

No business aggregations.

---

### TRANSFORM

Purpose

Apply business logic.

Example

Customer Lifetime Value

First Order Date

Most Recent Order Date

---

### MART

Purpose

Business-ready datasets.

Optimized for dashboards and reporting.

---

## Star Schema

Fact Table

Contains measurable business events.

Example

Orders

Dimension Table

Contains descriptive information.

Example

Customers

Fact joins to Dimensions.

---

## Slowly Changing Dimensions (SCD)

Type 1

Overwrite history.

Type 2

Preserve historical versions.

Implemented in this project using dbt Snapshots.