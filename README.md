# Cost-Efficient Lakehouse on MinIO + Apache Iceberg

## 1 · Problem
E-commerce teams outgrow flat S3/MinIO folders. They need ACID tables, time travel, and cheap storage - without paying enterprise warehouse prices.

## 2 · Architecture
<!-- Mermaid diagram will render on GitHub -->
mermaid<br>flowchart TD<br> subgraph Metadata\n Nessie[(Project Nessie)]-->Postgres[(Postgres)]\n end<br> Spark ==writes==> MinIO[(MinIO Object Store)]<br> Spark --> Nessie<br> Spark --> IceCat[(Iceberg Catalog)]<br> Trino --> IceCat<br>
