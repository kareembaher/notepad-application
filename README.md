# notepad-application

Hello,

This repo is to create a Notpad web application with Kubernetes.

## Prerequsits:
You will need to install the following:
#### Maven:
- To build our application
- To install Maven, please refer to this URL https://maven.apache.org/install.html

#### Docker:
- To build our image
- To install your Docker, please refer to this URL https://docs.docker.com/engine/install/

#### Kubernetes:
- In this documentation I installed minikube and kubectl (single node cluster) and set my driver to docker
- To install minikube please refer to this URL https://minikube.sigs.k8s.io/docs/start/
- To install kubectl, please refer to this URL https://kubernetes.io/docs/tasks/tools/install-kubectl/
- When starting your Kubernetes cluster, please do the following command to set your driver to use docker
```
minikube start --driver=docker
```

## Description:
We will create 3 pods for the notepad:
- A deployment with 2 pods for the Notepad application
- 1 pod for Mysql database to store your notes

## Repo file structure:
In this repo you will find 2 directories and 2 files:
#### notpad:
This directory containes the application code, along with the Dockerfile that we will use to create our docker image.

#### kubernetes-file:
This directory containes all the nessessary yaml files for creating the pod, deployment, secrets, and services
- notepad.deployment.yml - will create a deployment for the notepad application
- notepad.service.yml - will create a service for the notepas application
- mysql.pod.yml - will create the mysql pod
- mysql.service - will create the service for the mysql pod
- secrets.yml - where we will store our sensetive data for the notepad and mysql env. variables that will contain the root password and database name. I encrypted the info using this URL https://www.base64decode.org/, if you wish to change any of the info you may edit the secrets file with the new encrypted code from the previous URL

#### build.sh:
This is a simple bash script that sums up all the manual commands you will have to do in order so start the notepad application, you will only be prompted to enter you docker-hub username and password.

#### docker-password.txt:
This file will contain your docker-hub regestry password for your login from the build.sh script.

## How to use it:
You will only have to execute the script provided
```
./build.sh
```
Then you will be asked to enter you docker-hub username and password, your application will be built in a minuite

To check your application is working, type the following commands:
- To list the pods you have do:
```
kubectl get pod
```

- To access the notepad application, you will have to get the service IP address for the notepad or open it directly on your default browser using this command:
```
minikube service notepad-app-service
```
