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

#Change the working directory
cd notepad

#Building the application with maven
echo ""
echo ""
echo "Building the application..."
sleep 2
mvn clean install package -Dmaven.test.skip=true

#Building the docker image
echo ""
echo ""
echo "Building the docker image..."
sleep 2
docker build -t $username/notepad .

#Pushing the docker image to docker-hub
echo ""
echo ""
echo "Pushing the docker image to docker-hub..."
sleep 2
docker push $username/notepad

#Change working directory
cd ../kubernetes-files

#Execute kubernetes yaml files
echo ""
echo ""
echo "Running Kubernetes files..."
sleep 2
kubectl create -f secret.yml
kubectl create -f mysql.service.yml 
kubectl create -f mysql.pod.yml
kubectl create -f notepad.service.yml
kubectl create -f notepad.deployment.yml