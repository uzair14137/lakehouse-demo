#!/usr/bin/env bash
set -euo pipefail
mkdir -p spark/jars trino/plugin/iceberg

# ----- versions -----
ICEBERG_VER=1.6.0          # July 2024 release
NESSIE_VER=0.104.2
TRINO_VER=448              # matches your container

# ----- Spark runtime (Iceberg + Nessie) -----
curl -L -o spark/jars/iceberg-spark-runtime-3.5_2.12-${ICEBERG_VER}.jar \
  https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.5_2.12/${ICEBERG_VER}/iceberg-spark-runtime-3.5_2.12-${ICEBERG_VER}.jar  # :contentReference[oaicite:1]{index=1}

curl -L -o spark/jars/nessie-spark-extensions_2.12-${NESSIE_VER}.jar \
  https://repo1.maven.org/maven2/org/projectnessie/nessie-spark-extensions_2.12/${NESSIE_VER}/nessie-spark-extensions_2.12-${NESSIE_VER}.jar  # :contentReference[oaicite:2]{index=2}

# ----- Trino Iceberg + Nessie connector -----
curl -L -o trino/plugin/iceberg/trino-iceberg-${TRINO_VER}.jar \
  https://repo1.maven.org/maven2/io/trino/trino-iceberg/${TRINO_VER}/trino-iceberg-${TRINO_VER}.jar

curl -L -o trino/plugin/iceberg/trino-iceberg-nessie-${TRINO_VER}.jar \
  https://repo1.maven.org/maven2/io/trino/trino-iceberg-nessie/${TRINO_VER}/trino-iceberg-nessie-${TRINO_VER}.jar
