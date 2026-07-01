# dbt Command Cheatsheet

A quick reference for the most commonly used dbt commands during development.

## Validate Connection

```bash
dbt debug
```

Checks the connection between dbt and Snowflake and validates your project configuration.

---

## Load Seed Data

```bash
dbt seed
```

Loads CSV files from the `seeds/` directory into Snowflake.

---

## Refresh Seed Data

```bash
dbt seed --full-refresh
```

Drops and recreates all seed tables from the CSV files in the `seeds/` directory.

---

## Run Models

```bash
dbt run
```

Builds all models defined in the project.

---

## Clean Project

```bash
dbt clean
```

Removes generated directories such as `target/` and `dbt_packages`, allowing them to be recreated on the next run.

# Build models + tests + seeds
dbt build

# Force rebuild Incremental Models
dbt run --full-refresh