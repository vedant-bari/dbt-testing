# 🛒 E-Commerce Analytics with dbt & Snowflake

## Overview

This project demonstrates an end-to-end analytics engineering workflow using **dbt Cloud** and **Snowflake**.

The objective is to transform raw e-commerce customer and order data into clean, validated, and analytics-ready data models following dbt best practices.

---

# Project Architecture

```text
                        +-----------------------+
                        |   Snowflake RAW Data  |
                        +-----------------------+
                          |                 |
                          |                 |
                +---------+                 +---------+
                |                                   |
        RAW.CUSTOMERS                      RAW.ORDERS
                |                                   |
                +---------------+-------------------+
                                |
                                ▼
                    ┌─────────────────────┐
                    │    Staging Layer    │
                    │  Data Standardization│
                    └─────────────────────┘
                     │                 │
                     │                 │
         stg_customers.sql     stg_orders.sql
                     │                 │
                     └─────────┬───────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │  Transform Layer    │
                    │ Business Metrics    │
                    └─────────────────────┘
                               │
                               │
               int_customer_metrics.sql
                               │
                 ┌─────────────┴─────────────┐
                 │                           │
                 ▼                           ▼
         dim_customers.sql           fact_orders.sql
                 │                           │
                 └─────────────┬─────────────┘
                               │
                               ▼
                     Business Intelligence
                  (Power BI / Tableau / Looker)
```

---

# Data Flow

```text
Raw Data
   │
   ▼
Sources (sources.yml)
   │
   ▼
Staging Models
   │
   ▼
Transform Models
   │
   ▼
Dimension & Fact Models
   │
   ▼
Data Quality Tests
   │
   ▼
Documentation & Lineage
```

---

# Technology Stack

| Component       | Technology |
| --------------- | ---------- |
| Data Warehouse  | Snowflake  |
| Transformation  | dbt Cloud  |
| Version Control | GitHub     |
| Language        | SQL        |
| Configuration   | YAML       |

---

# Project Structure

```text
ecommerce_project/
│
├── dbt_project.yml
│
├── models/
│   │
│   ├── staging/
│   │   ├── sources.yml
│   │   ├── schema.yml
│   │   ├── stg_customers.sql
│   │   └── stg_orders.sql
│   │
│   ├── transform/
│   │   ├── schema.yml
│   │   └── int_customer_metrics.sql
│   │
│   └── marts/
│       ├── schema.yml
│       ├── dim_customers.sql
│       └── fact_orders.sql
│
└── README.md
```

---

# Data Model

## Source Tables

### Customers

| Column      | Description         |
| ----------- | ------------------- |
| id          | Customer Identifier |
| first_name  | Customer First Name |
| last_name   | Customer Last Name  |
| email       | Customer Email      |
| signup_date | Registration Date   |

---

### Orders

| Column          | Description         |
| --------------- | ------------------- |
| order_id        | Order Identifier    |
| user_id         | Customer Identifier |
| order_timestamp | Order Timestamp     |
| status          | Order Status        |
| amount          | Order Amount        |

---

# Layer 1 – Staging

Purpose:

* Standardize source data
* Rename columns
* Clean values
* Maintain one-to-one mapping with source

## stg_customers

Transformations

* Rename `id` → `customer_id`
* Convert email to lowercase

Output

```text
customer_id
first_name
last_name
email
signup_date
```

---

## stg_orders

Transformations

* Rename `user_id` → `customer_id`
* Convert timestamp to date

Output

```text
order_id
customer_id
order_date
status
amount
```

---

# Layer 2 – Transform

Model:

```
int_customer_metrics
```

Calculations

* First Order Date
* Most Recent Order Date
* Total Orders
* Customer Lifetime Value (CLV)

Grouping

```sql
GROUP BY customer_id
```

---

# Layer 3 – Marts

## Dimension Table

### dim_customers

Contains

* Customer information
* Signup Date
* First Order Date
* Latest Order Date
* Total Orders
* Customer Lifetime Value

---

## Fact Table

### fact_orders

One row represents one transaction.

Contains

* Order ID
* Customer ID
* Order Date
* Status
* Amount

---

# Data Lineage

```text
RAW.CUSTOMERS
      │
      ▼
stg_customers
      │
      ▼
dim_customers

RAW.ORDERS
      │
      ▼
stg_orders
      │
      ▼
int_customer_metrics
      │
      ▼
dim_customers

stg_orders
      │
      ▼
fact_orders
```

---

# Data Quality Tests

## Staging Tests

### stg_customers

* Unique customer_id
* Not Null customer_id

---

### stg_orders

* Unique order_id
* Not Null order_id
* Not Null customer_id
* Not Null amount

---

## Mart Tests

### fact_orders

Relationship Test

```text
fact_orders.customer_id
        │
        ▼
dim_customers.customer_id
```

Ensures every order belongs to a valid customer.

---

# Running the Project

## Install Dependencies

```bash
dbt deps
```

---

## Validate Connection

```bash
dbt debug
```

---

## Build Models

```bash
dbt build
```

---

## Run Only Models

```bash
dbt run
```

---

## Execute Tests

```bash
dbt test
```

---

## Generate Documentation

```bash
dbt docs generate
```

> **Note:** `dbt docs serve` is supported only with **dbt Core**. When using **dbt Cloud**, documentation and lineage are viewed directly through the dbt Cloud interface.

---

# Expected Output

```
RAW
 │
 ├── CUSTOMERS
 └── ORDERS

STAGING
 ├── stg_customers
 └── stg_orders

TRANSFORM
 └── int_customer_metrics

MARTS
 ├── dim_customers
 └── fact_orders
```

---

# Project Validation Checklist

* Snowflake configured
* dbt Cloud connected
* Git repository connected
* Source configuration completed
* Staging models created
* Transform model created
* Mart models created
* All tests passing
* Documentation generated
* Lineage graph verified
* No compilation errors

---

# Best Practices Followed

* Layered dbt architecture
* Source definitions using `sources.yml`
* Modular SQL models
* Use of `ref()` and `source()`
* Data quality testing
* Version control with Git
* Business-ready star schema
* Automatic lineage generation

---

# Future Enhancements

* Incremental models
* Snapshots for Slowly Changing Dimensions (SCD)
* dbt Seeds
* dbt Snapshots
* Custom Generic Tests
* CI/CD using GitHub Actions
* Environment-specific deployments (Dev, QA, Prod)
* dbt Exposures for BI dashboards
