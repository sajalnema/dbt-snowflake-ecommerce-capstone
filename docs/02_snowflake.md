---

# Database vs Schema vs Warehouse

## Database

- Logical container for schemas.

## Schema

- Organizes related database objects such as tables and views.

## Warehouse

- Compute engine responsible for executing SQL queries.

> **Note:** Storage and compute are separated in Snowflake, allowing independent scaling.

---

# TO_TIMESTAMP()

Converts a string into a `TIMESTAMP`.

Example:

```sql
TO_TIMESTAMP(
    cleaned_timestamp,
    'DD MONTH YYYY HH24:MI:SS'
)
```

## Why?

Raw data often contains timestamps as text. Parsing them during staging standardizes the datatype for downstream models.