#!/usr/bin/env python
"""
Ingest RetailRocket events → Iceberg table lake.default.rr_events
Run inside the Spark container:
    docker exec -it lakehouse-demo-spark-1 /opt/bitnami/spark/scripts/ingest.sh
"""
import sys
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, to_timestamp

events_csv = "/workspace/raw/events.csv"
warehouse   = "s3a://warehouse"

spark = (
    SparkSession.builder.appName("rr_ingest")
    .config("spark.sql.catalog.lake", "org.apache.iceberg.spark.SparkCatalog")
    .config("spark.sql.catalog.lake.catalog-impl", "org.apache.iceberg.nessie.NessieCatalog")
    .config("spark.sql.catalog.lake.uri", "http://nessie:19120/api/v2")
    .config("spark.sql.catalog.lake.warehouse", warehouse)
    .config("spark.hadoop.fs.s3a.endpoint", "http://minio:9000")
    .config("spark.hadoop.fs.s3a.access.key", "minioadmin")
    .config("spark.hadoop.fs.s3a.secret.key", "minioadmin")
    .config("spark.hadoop.fs.s3a.path.style.access", "true")
    .config("spark.hadoop.fs.s3a.connection.ssl.enabled", "false")
    .getOrCreate()
)

# ①  Ensure the namespace exists in Nessie
spark.sql("CREATE NAMESPACE IF NOT EXISTS lake.default")

# --- read raw CSV ---
df = (
    spark.read.option("header", "true").csv(events_csv)
        .withColumn("event_time", to_timestamp(col("timestamp") / 1000))
        .withColumnRenamed("event", "event_type")
        .select(
            "event_time",
            "event_type",
            col("visitorid").cast("long"),
            col("itemid").cast("long"),
            col("transactionid").cast("long"),
        )
)

# ②  Write fully-qualified table lake.default.rr_events
(df.writeTo("lake.default.rr_events")          # <-- schema specified here
   .using("iceberg")
   .partitionedBy("event_type")
   .option("format-version", "2")
   .createOrReplace())

spark.stop()
# docker exec -it lakehouse-demo-spark-1 /opt/bitnami/spark/scripts/ingest.sh
