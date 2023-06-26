# Local installation for development (not needed in the workshop)


## Prerequisites
 * [poetry](https://python-poetry.org/)


## Docker
* Start docker
* cd into the insurance-prediction folder
* `docker build -t insurance_prediction -f Dockerfile .`

## Running the interactive docker image
* Start docker
* cd into the insurance-prediction folder
* `docker build -t insurance_prediction_interactive -f interactive.Dockerfile .`
* `docker run -v "$(pwd)/output:/output" --rm -it insurance_prediction_interactive`

## First setup

```
poetry install
```

## Local development

* Use the python environment created by *poetry*: `source ./venv/bin/activate`.

## Training and validation

```
poetry run train --dataset ./datasets/insurance_prediction/ --model ./model.h5
```

```
poetry run validate --dataset ./datasets/insurance_prediction/ --model ./model.h5
```

## Simluate requests in production for k8s cluster

```
poetry run simulate-drift --dataset ./datasets/insurance_prediction/ --base_url http://localhost:30080/
```

## Docker

```
docker compose up
```

* ML Service 
  * Swagger http://localhost:8080
  * Metrics: http://localhost:8080/metrics/
* Prometheus
  * Query: http://localhost:9090/
  * Drift Gauge: http://localhost:9090/graph?g0.expr=drift_score_by_columns&g0.tab=1&g0.stacked=0&g0.show_exemplars=0&g0.range_input=1h
  * Scrape Targets: http://localhost:9090/targets
* Grafana Dashboard: http://localhost:3000/d/U54hsxv7k/evidently-data-drift-dashboard?orgId=1&refresh=5s
* Simulate Production requests without need for local installation: ./scripts/curl-drift.sh localhost:8080