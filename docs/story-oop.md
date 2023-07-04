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