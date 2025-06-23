#!/usr/bin/env bash
set -e
SPARK_HOME=/opt/bitnami/spark

$SPARK_HOME/bin/spark-submit \
  --jars /opt/iceberg/lib/iceberg-spark-runtime-3.5_2.12-1.6.0.jar,\
/opt/iceberg/lib/nessie-spark-extensions-3.5_2.12-0.104.2.jar \
  /opt/bitnami/spark/scripts/ingest.py
