# dbt Command Cheatsheet

A quick reference for the most commonly used dbt commands during development.

---

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

## Build Project

```bash
dbt build
```

Runs the complete dbt workflow by executing:

- Seeds (when applicable)
- Models
- Tests
- Snapshots (if present)

This is commonly used in CI/CD pipelines and for validating the entire project.

---

## Force Rebuild Incremental Models

```bash
dbt run --full-refresh
```

Drops and recreates Incremental Models instead of performing incremental updates. This is useful when:

- Schema changes have been made
- New columns have been added
- A complete rebuild of the model is required

---

## Clean Project

```bash
dbt clean
```

Removes generated directories such as `target/` and `dbt_packages`, allowing them to be recreated on the next run.
# Execute all tests
dbt test