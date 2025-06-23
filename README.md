# Cost-Efficient Lakehouse on MinIO + Apache Iceberg

## 1 · Problem
E-commerce teams outgrow flat S3/MinIO folders. They need ACID tables, time travel, and cheap storage - without paying enterprise warehouse prices.

## 2 · Architecture
```mermaid
flowchart TD
  subgraph Metadata
    Nessie[(Project Nessie)] --> Postgres[(Postgres)]
  end
  Spark ==writes==> MinIO[(MinIO Object Store)]
  Spark --> Nessie
  Spark --> IceCat[(Iceberg Catalog)]
  Trino --> IceCat

