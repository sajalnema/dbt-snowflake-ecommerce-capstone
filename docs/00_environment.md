# Sprint 1 - Environment & Snowflake Setup

## Project Structure

Salesforce_Capstone/
├── ecommerce_capstone/
├── datasets/
├── notes/
└── dbt-env/

---

## Snowflake Architecture

Database:
ECOMMERCE_DBT

Schemas:

- RAW
- STAGING
- TRANSFORM
- MART

---

## Why separate schemas?

RAW
- Stores original source data.
- No transformations.

STAGING
- Cleans and standardizes raw data.
- Renames columns.
- Casts data types.

TRANSFORM
- Applies business logic.
- Joins datasets.
- Calculates metrics.

MART
- Final reporting layer.
- Used by BI tools.

---

## Important Learning

Never transform raw data directly.

Always preserve the original source data.