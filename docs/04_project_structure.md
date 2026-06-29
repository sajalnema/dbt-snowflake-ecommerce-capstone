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
