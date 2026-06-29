# dbt Project Setup

## dbt_project.yml

Purpose:
Stores project configuration.

Examples:
- Project name
- Model paths
- Materializations
- Schema configuration

---

## profiles.yml

Location:

~/.dbt/profiles.yml

Purpose:
Stores connection information.

Contains:
- Account
- Username
- Password
- Warehouse
- Database
- Schema

Important:
This file is usually NOT committed to Git because it contains credentials.

---

## dbt debug

Purpose:
Checks whether dbt can successfully connect to the data warehouse before running models.