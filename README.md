# Cost-Efficient Lakehouse on MinIO + Apache Iceberg

## 1 · Problem
E-commerce teams quickly outgrow flat S3 / MinIO folders.  
They need **ACID inserts, time-travel rollback, and partition pruning**—without paying enterprise-warehouse pricing.

## 2 · Architecture
```mermaid
flowchart TD
  subgraph Metadata
    Nessie[(Project Nessie)] --> Postgres[(PostgreSQL 16)]
  end
  Spark["Spark 3.5 (driver + workers)"] -->|writes Iceberg files| MinIO[(MinIO Object Store)]
  Spark --> Nessie
  Trino["Trino 448"] --> Nessie
```

| Step                                | What you see                                                                                                                    |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **Before update**                   | ![Snapshot 1](snapshots/snapshot1.png)                                                                                          |
| **Run update**                      | `sql UPDATE default.rr_events SET itemid = -1 WHERE event_type = 'view' AND pmod(xxhash64(cast(visitorid AS string)),2000)=0; ` |
| **After update (100 rows changed)** | ![Snapshot 2](snapshots/afterupdation.png)                                                                                       |
| **Rollback**                        | `sql CALL system.rollback_to_snapshot('lake."default".rr_events', <old_snapshot_id>); `                                         |
| **Back to zero changed rows**       | ![Snapshot 3](snapshots/rollback.png)                                                                                        |
