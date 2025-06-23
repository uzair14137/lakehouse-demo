# Cost-Efficient Lakehouse on MinIO + Apache Iceberg

## 1 · Problem
E-commerce teams outgrow flat S3/MinIO folders. They need ACID tables, time travel, and cheap storage - without paying enterprise warehouse prices.

## 2 · Architecture
```mermaid
flowchart TD
  subgraph Metadata
    Nessie[(Project Nessie)] --> Postgres[(PostgreSQL 16)]
  end
  Spark["Spark 3.5 (Driver + Workers)"] -->|writes Iceberg files| MinIO[(MinIO Object Store)]
  Spark --> Nessie
  Trino["Trino 448"] --> Nessie


