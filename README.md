
[![LeopoldWalther](https://circleci.com/gh/LeopoldWalther/ml-microservice-kubernetes.svg?style=svg)](https://app.circleci.com/gh/LeopoldWalther/ml-microservice-kubernetes)


## Project Overview

In the world of Data Science and Machine Learning there is a lot of emphasis on developing machine learning models in jupyter notebooks, but a lot less on taking a model and deploying it to production.

Goal of this project is to operationalize a machine learning microservice using [kubernetes](https://kubernetes.io/), which is an open-source system for automating the management of containerized applications. The mircroservice contains of a pre-trained, `sklearn` model that has been trained to predict housing prices in Boston according to several features, such as average rooms in a home and data about highway access, teacher-to-pupil ratios [data source site](https://www.kaggle.com/c/boston-housing). This machine learning model is used by a Python flask app `app.py`, that serves out predictions (inference) about housing prices through API calls. This project could be extended to any pre-trained machine learning model, such as those for image recognition and data labeling.


## Setup the Environment

* Create a virtualenv with Python 3.7 and activate it. Refer to this link for help on specifying the Python version in the virtualenv. 
You should have Python 3.7 available in your host. 
Check the Python path using `which python3`

`make setup` or 

```bash
python3 -m venv ~/.devops
source ~/.devops/bin/activate
```
* Run `make install` to install the necessary dependencies or
```bash
pip install --upgrade pip && pip install -r requirements.txt
```

* Test code using linting with `make lint`
This should be run from inside a virtualenv
```bash
# linter for Docker files
hadolint Dockerfile

# linter for Python source code linter: https://www.pylint.org/
pylint --disable=R,C,W1203,W1202 app.py
```

### Running `app.py`

1. Standalone:  `python app.py`
2. Run in Docker:  `./run_docker.sh` 
3. Run in Kubernetes:  `./run_kubernetes.sh`

### Kubernetes Steps

1. Setup and Configure Docker locally
2. Setup and Configure Kubernetes locally
3. Create Flask app in Container
4. Run via kubectl


### Upload Docker image to Dockerhub with `./upload_docker.sh` or 
```bash
# Create dockerpath
dockerpath=leopoldwalther/housing-price-prediction

# Authenticate & tag
echo "Docker ID and Image: $dockerpath"
docker login -u leopoldwalther
docker tag housing-price-prediction $dockerpath:latest

# Push image to a docker repository
docker push $dockerpath:latest
```

### Configure Kubernetes and create a Kubernetes cluster
Start Minikube with `minikube start` and check if certificate-authority and server are up running with `kubectl config view`

To stop minikube `minikube delete`.

### Deploy a container using Kubernetes with `./run_kubernetes.sh` and make a prediction

```bash
# dockerpath=<>
dockerpath=leopoldwalther/housing-price-prediction

# Run the Docker Hub container with kubernetes
kubectl create deploy housing-price-prediction --image=$dockerpath:latest
#kubectl run housing-price-prediction --image=$dockerpath --port=80

# List kubernetes pods and get name of running pod with id
kubectl get pods
podname=$(kubectl get pods | grep -o "housing-price-prediction-.*" | awk '{print $1}')

# Forward the container port to a host
kubectl port-forward pod/$podname 8000:80
```

Test if API works with `./make_prediction.sh` from different terminal.

### Upload a complete Github repo with CircleCI batch to indicate that code has been tested
