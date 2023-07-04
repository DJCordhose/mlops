## Story

## Experiment

1. Problem ist im Prinzip gelöst im Notebook: https://colab.research.google.com/github/djcordhose/mlops/blob/main/insurance-prediction/notebooks/train.ipynb

## Build und Validation

1. docker starten
1. Läuft der Cluster? Wenn nicht, dann über Desktop starten
1. ```sh
cd insurance-prediction
docker run -v "$(pwd)/output:/output" --rm -it insurance_prediction_interactive

poetry run train --dataset ./datasets/insurance_prediction --model /output/model.h5
poetry run validate --dataset ./datasets/insurance_prediction/ --model /output/model.h5
exit
```
1. Wir haben nun ein trainiertes Modell, dass unsere Tests besteht
1. Das probieren wir nun aus:
1. ```sh
docker run --rm -p 8080:80 insurance-prediction
http://localhost:8080/
```

## Pipeline und Betrieb

1. Zeigen:
   1. Code im Repo: http://gitea.local/explore/repos
   1. CI/CD: http://tekton.localhost/#/pipelineruns
   1. Service hier ausprobieren: http://localhost:30080/

1. k9s
   - Läuft da ein pod im production Namespace? Das ist unsere Anwendung
   - Platt machen und gucken, was passiert
   - kommt man hier noch auf den Service drauf?
1. Den build failen lassen, indem wir das Modell verschlechtern, so dass die Tests nicht mehr durchlaufen.
   1. Insurance Prediction Repository öffnen
   1. Hier ein Pipeline Build triggern: http://gitea.local/ok-user/ok-gitea-repository/src/branch/main/src/insurance_prediction/train/train.py
http://gitea.local/mlops-user/mlops-gitea-repository/src/branch/main/src/insurance_prediction/train/train.py
   1. Hier die Kapazität herunter schrauben
   1. Auf Tekton läuft die Pipeline, die durch den push getriggert wird:
        http://tekton.localhost/#/namespaces/cicd/pipelineruns
   1. Das bauen des neuen Images wird erneut getriggert, das Ergebnis müssen wir aber nicht mehr abwarten, können wir aber später noch einmal checken

## Monitoring und Drift

### Teil I: Services checken 
1. Evidently Metrics: http://localhost:30080/metrics/
1. Prometheus Time Series: http://localhost:30090
1. Grafana Dashboards: http://localhost:30031
   - login: admin/admin


### Teil II: Request simulieren

1. Prometheus Metrics ansehen: http://localhost:30080/metrics/
1. In Grafana das `Evidently Data Drift Dashboard` aufrufen: http://localhost:30031/d/U54hsxv7k/evidently-data-drift-dashboard?orgId=1&refresh=5s
1. Requests simulieren als k8s Job
```sh
cd drift_demo/
kubectl delete -f job.yaml
kubectl create -f job.yaml
```
1. Logs in k9s oder VSC Plugin ansehen

