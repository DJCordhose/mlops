# Story

## Vorbereitung
* Im Projekt-Verzeichnis unter `insurance-prediction`:
   * `docker build -t insurance_prediction_interactive -f interactive.Dockerfile .`
   * `docker build -t insurance-prediction .`

## Intro
1. Problemstellung: innovative Kfz-Versicherungsgesellschaft
1. Ausgangspunkt mit Colab: notebooks/exploration.ipynb
   1. Features
   1. Was wollen wir vorhersagen?
   1. Tests, Training, 
1. MLOps Grundlagen / Überblick über die Phasen, wieso kann ich damit nicht in Prod gehen

## Professionalisierung

auch: `insurance-prediction/TASKS.md`

1. Intro Docker
1. Notebook in Libs und Scripte
1. `cd insurance-prediction`
1. Build: Scripte im Docker Container laufen lassen
   1. Dev Server laufen lassen wie im Readme beschrieben
   1. Training und Validation laufen lassen
      * `poetry run train --dataset ./datasets/insurance_prediction/ --model /output/model.h5`
      * `poetry run validate --dataset ./datasets/insurance_prediction/ --model /output/model.h5`
   1. Validation diskutieren
      * was haben wir eingebaut
      * wie sinnvoll ist das, was kann man noch machen?
      * was für eine Art Test ist das?
1. API server starten
   1. `docker build -t insurance-prediction .`
   1. Gucken welcher Port frei ist und den beim Mapping nach außen nutzen
   1. `docker run -d -p 8080:80 insurance-prediction`
1. Server ausprobieren
   1. `http://localhost:8080/`
   1. Für eigene Werte ausprobieren
   1. Was passiert bei komischen Werten
   1. Ensemble, ML als kompletter Service

## Produktion
1. Was ist Kubernetes?
1. Cluster und Services wie in README.md beschrieben
   - Nach erzeugen des Clusters einmal in docker desktop oder so ansehen
1. Beendigung der Tekton Pipelines in http://tekton.localhost/#/pipelineruns abwarten
   - Selbst mit bestem Netz dauert das auf meinem Rechner 15 Minuten
   - Durchgehen, was da eigentlich alles passiert
1. Service hier ausprobieren: http://localhost:30080/
1. k9s
   - Läuft da ein pod im production Namespace? Das ist unsere Anwendung
   - Platt machen und gucken, was passiert
   - kommt man hier noch auf den Service drauf?
   
1. Hier liegt unser Source-Code http://gitea.local/
   1. Login: mlops-user / Password1234!
   1. http://gitea.local/mlops-user/mlops-gitea-repository/src/branch/main/src/insurance_prediction/train/train.py
   1. Hier die Kapazität herunter schrauben
   1. Hier müsste eine neue Pipeline anlaufen: http://tekton.localhost/#/namespaces/cicd/pipelineruns
   1. Die müsste fehlschlagen nach ca. der hälfte der Zeit, weil schon das validieren fehlschlagen müsste
   1. Dann Kapazität zurück drehen
   1. Das bauen des neuen Images wird erneut getriggert, das Ergebnis müssen wir aber nicht mehr abwarten

## Produktion wie von Tobi beschrieben: KinD Cluster mit CI/CD aufsetzen
1. Die README.md beschreibt was zu tun ist und welche Befehle ausgeführt werden müssen.
1. Wenn das erste init und apply erfolgreich durchgelaufen ist der sanity check:
   1. http://gitea.local/explore/repos / http://localhost:30030/explore/repos
   1. http://tekton.localhost/#/pipelineruns - http://localhost:30097/#/pipelineruns
1. Zurück zur README.md - Die zweite stage ausführen.
   1. In Tekton sollten nun 2 Pipelines angestoßen worden sein. Eine davon stößt direkt nach Durchlauf
        eine dritte an.
   1. In Gitea können wir nun die Repositories checken.
   1. Ist der Build komplett durchgelaufen, können wir jetzt auch die Anwendung checken.
        http://insurance-prediction.localhost / http://localhost:30080
1. Den build failen lassen, indem wir das Modell verschlechtern, so dass die Tests nicht mehr durchlaufen.
   1. Login: mlops-user / Password1234!
   1. Insurance Prediction Repository öffnen (Das heißt aktuell mlops-gitea-repository)
        http://gitea.local/mlops-user/mlops-gitea-repository/src/branch/main/src/insurance_prediction/train/train.py
   1. Hier die Kapazität herunter schrauben
   1. Auf Tekton läuft die Pipeline, die durch den push getriggert wird:
        http://tekton.localhost/#/namespaces/cicd/pipelineruns


## Monitoring
1. Evidently Metrics: http://localhost:30080/metrics/
1. Prometheus Time Series: http://localhost:30090
1. Grafana Dashboards: http://localhost:30031
   - login: admin/admin
1. Produktion simulieren
   1. Story:
     1. die Performance des Modells degradiert
	  1. aber wir haben erst nach Jahren eine Ground Truth, die uns das anhand der Metrik zeigt
	  1. wir simulieren 3 Jahre Betrieb mit
         1. Leute werden immer Älter, das passiert aber langsam (age)
	     1. Es wird immer weniger Auto gefahren, Leute steigen um auf die Bahn und öffentliche Verkehrsmittel (miles)
	     1. Die Sicherheit der Autos wird immer besser und der Einfluss der individuellen Fahrleistung wird verringert (emergency_braking, pred)  
   1. `./scripts/curl-drift.sh localhost:30080`
   1. oder ```
cd drift_demo/
kubectl create -f job.yaml
   ```
   1. `http://localhost:30080/metrics/`
   1. `http://localhost:30031/d/U54hsxv7k/evidently-data-drift-dashboard?orgId=1&refresh=5s`
1. Drift in der Reihenfolge, alle 3 nach ca. 5 Minuten gedriftet 
   1. miles
   1. emergency_braking 
   1. age  
