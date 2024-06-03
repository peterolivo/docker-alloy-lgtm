#!/bin/bash

./run-grafana.sh &
./run-loki.sh &
./run-alloy.sh &
./run-prometheus.sh &
./run-tempo.sh &

echo "Waiting for Alloy and the Grafana LGTM stack to start up..."

# This waits for alloy metrics to be available in Prometheus.
# TODO: Also curl Grafana, Loki, Tempo to be sure all services are up.
while ! curl -sg 'http://localhost:9090/api/v1/query?query=up{job="alloy"}' | jq -r .data.result[0].value[1] | grep '1' >/dev/null; do
	sleep 1
done

echo "Alloy and the Grafana LGTM stack are up and running."

echo "Open ports:"
echo " - 4317: OpenTelemetry GRPC endpoint"
echo " - 4318: OpenTelemetry HTTP endpoint"
echo " - 3000: Grafana. User: admin, password: admin"
echo " - 12345: Alloy user interface"

sleep infinity
