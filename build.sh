#!/bin/bash
echo "Hello, this scripts will build the notepad application on Kubernetes cluster"
sleep 2

#Entering credentials for Docker-hub
echo "Please enter your credentials for docker-hub regestry"
Sleep 1
echo "Enter your username: " 
read username
echo "Enter your password: " 
read password

#Logging to dockerhub
echo $password > docker-password.txt
cat docker-password.txt | docker login --username $username --password-stdin

#change the working directory
cd notepad

#building the application with maven
echo ""
echo ""
echo "Building the application..."
sleep 2
mvn clean install package -Dmaven.test.skip=true

#building the docker image
echo ""
echo ""
echo "Building the docker image..."
sleep 2
docker build .

#pushing the docker image to docker-hub
echo ""
echo ""
echo "Pushing the docker image to docker-hub..."
sleep 2
docker push kareembaher/notepad:latest

#change working directory
cd ../kubernetes-files

#execute kubernetes yaml files
echo ""
echo ""
echo "Running Kubernetes files..."
sleep 2
kubectl create -f secret.yml
kubectl create -f mysql.service.yml 
kubectl create -f mysql.pod.yml
kubectl create -f notepad.service.yml
kubectl create -f notepad.deployment.yml