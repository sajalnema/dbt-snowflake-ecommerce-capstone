# Interview Notes

## Explain the Project

This project demonstrates a complete ELT pipeline using dbt and Snowflake.

Pipeline

CSV

↓

Seed

↓

RAW

↓

Staging

↓

Transform

↓

Mart

↓

Snapshot

The project includes:

- Data cleaning
- Business transformations
- Customer metrics
- Incremental models
- Snapshots
- Data quality tests
- Documentation
- Lineage

---

## Why dbt?

- SQL-first transformations
- Dependency management
- Automatic lineage
- Testing
- Documentation
- Modular project structure

---

## Why Staging?

Keep raw data untouched.

Only perform cleaning.

---

## Why Transform?

Business calculations belong here.

Example

Customer Lifetime Value

---

## Why Mart?

Business-ready tables.

Consumed by dashboards.

---

## Why Incremental?

Avoid rebuilding large datasets.

Only process new or modified records.

---

## Why Snapshots?

Preserve history.

Enable SCD Type 2.

---

## Why row_hash?

Efficient change detection.

Avoid comparing every column individually.

---

## Why source()?

Represents externally managed raw tables.

---

## Why ref()?

Creates dependency between dbt models.

Enables lineage.

---

## Why Views in Staging?

Always reflect latest raw data.

Avoid unnecessary storage.

---

## Why Tables in Mart?

Optimized for reporting performance.

---

## Explain Lineage

Lineage automatically tracks model dependencies using ref() and source().

It provides visibility into data flow from source to business-ready datasets.

---

## Common Commands

dbt seed

dbt run

dbt test

dbt snapshot

dbt build

dbt docs generate

dbt docs serve