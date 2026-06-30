# Decision Log

This document captures the key engineering decisions made throughout the project along with the reasoning behind each choice. It serves as a reference for understanding the project's architecture and design choices.

| Decision | Reason |
|----------|--------|
| Maintain original datasets inside the `datasets/` directory and copy them into `seeds/` | Preserves the original source files while allowing dbt to consume version-controlled seed files. This also reflects the separation between source data and transformation logic. |
| Use Git feature branches for each implementation phase | Enables isolated development, cleaner commit history, and mirrors the workflow followed by engineering teams. |
| Organize documentation into dedicated Markdown files instead of a single document | Keeps concepts modular, easier to navigate, and allows documentation to evolve alongside the implementation. |
| Use `dbt seed` to load the initial datasets | Suitable for small, static datasets used during development and learning. Production systems typically ingest data using dedicated ingestion services before dbt transformations begin. |
| Separate the Snowflake environment into `RAW`, `STAGING`, `TRANSFORM`, and `MART` schemas | Provides clear separation of responsibilities across the data lifecycle, making the pipeline easier to maintain, debug, and extend. |
| Use a dedicated Snowflake warehouse (`COMPUTE_WH`) for the project | Keeps compute resources isolated from storage and aligns with Snowflake's architecture, where warehouses independently manage query execution. |
| Keep dbt project configuration (`dbt_project.yml`) separate from connection configuration (`profiles.yml`) | Allows the same project to run across multiple environments without exposing credentials or modifying project code. |
| Exclude generated folders (`logs`, `target`, `dbt_packages`) from version control | These directories are generated during execution and can always be recreated. Ignoring them keeps the repository clean and avoids unnecessary commits. |
| Preserve timestamps in the staging layer instead of converting them to dates | Staging is responsible for standardization without losing information. Business-specific transformations such as extracting dates belong in the transform layer. |
| Materialize staging models as Views | Staging transformations are lightweight and should always reflect the latest raw data without duplicating storage. |
| Use `ref()` instead of hardcoded table names | Enables dependency management, automatic lineage generation, and environment-independent model references. |
| Override dbt schema generation to create dedicated warehouse schemas | Produces a clean warehouse architecture (`RAW`, `STAGING`, `TRANSFORM`, `MART`) instead of generated schemas such as `STAGING_RAW`. |
| Preserve timestamps as TIMESTAMP instead of DATE  | Time information may be useful for future analytics. Business-level date extraction can happen in downstream models. |
| Use `INITCAP()` even though current data is clean | Makes the pipeline resilient to inconsistent future source data.                                                     |
| Use `REGEXP_REPLACE()` before parsing timestamps  | Removes ordinal suffixes (`st`, `nd`, `rd`, `th`) so the timestamp can be parsed reliably.                           |
| Filter records with null business keys            | Invalid customer references and missing emails reduce downstream data quality.                                       |
