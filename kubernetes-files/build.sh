#!/bin/bash
#change the working directory
cd notepad

#building the application with maven
echo "Building the application..."
mvn clean install package -Dmaven.test.skip=true

#building the docker image
echo "Building the docker image..."
docker build .

#pushing the docker image to docker-hub
echo "Pushing the docker image to docker-hub..."
docker push kareembaher/notepad:latest

#change working directory
cd ..

#execute kubernetes yaml files
echo "Running Kubernetes files..."
kubectl create -f secret.yml
kubectl create -f notepad.deployment.yml
kubectl create -f notepad.service.yml
kubectl create -f mysql.pod.yml
kubectl create -f mysql.service.yml 