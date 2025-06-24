.PHONY: up trino ingest

up:                ## start / restart the lakehouse stack
	docker compose up -d

trino:             ## open Trino CLI in lake.default
	docker exec -it lakehouse-demo-trino-1 \
	    trino --catalog lake --schema "default"

ingest:            ## run the Spark ingestion job
	docker exec -it lakehouse-demo-spark-1 \
	    /opt/bitnami/spark/scripts/ingest.sh

