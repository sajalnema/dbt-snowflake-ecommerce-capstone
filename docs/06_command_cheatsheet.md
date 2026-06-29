# DBT Command Cheatsheet

## Validate Connection

```bash
dbt debug
```

Checks the connection between dbt and Snowflake.

---

## Load Seed Data

```bash
dbt seed
```

Loads CSV files from the `seeds/` directory into Snowflake.

---

## Clean Project

```bash
dbt clean
```

Removes generated folders such as `target/` and `dbt_packages`.
