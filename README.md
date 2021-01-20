# notepad-application

Hello,

This repo is to create a Notpad web application with Kubernetes.

Prerequsits:
You will need to install the following:
    - Maven:
        = to build our application
        = to install maven, please refer to this URL https://maven.apache.org/install.html
    - Docker
        = to build our image
        = to install your docker, please refer to this URL https://docs.docker.com/engine/install/
    - Kubernetes
        = in this documentation I installed minikube and kubectl (single node cluster) and set my driver to docker
        = to install minikube please refer to this URL https://minikube.sigs.k8s.io/docs/start/
        = to install kubectl, please refer to this URL https://kubernetes.io/docs/tasks/tools/install-kubectl/
        = when starting your kubernetes cluster, please do the following comand to set your driver to use docker
          $ minikube start --driver=docker

Description:
We will create 3 pods for the notepad:
    - a deployment with 2 pods for the notepad application itself
    - 1 pod for mysql database to store your notes

Repo file structure:
in this repo you will find 2 directories and 2 files:
notpad:
this is the application code itself, along with the Dockerfile that we will use to create our image

kubernetes-file:
this directory containes all the nessessary yaml files for creating the pod, deployment, secrets, and services
notepad.deployment.yml - will create a deployment for the notepad application
notepad.service.yml - will create a service for the notepas application
mysql.pod.yml - will create the mysql pod
mysql.service - will create the service for the mysql pod
secrets.yml - where we will store our encrypyed data for the notepad and mysql env. variables

build.sh:
this is a simple bash script that sums up all the manual commands you will have to do in order so start the notepad application, you will be prompted to enter you docker-hub username and password.

docker-password.txt:
this file will contain your docker-hub regestry password for your login from the build.sh script.

How to use it:
You will only have to execute the script provides
$ ./build.sh
you will be asked to enter you docker-hub username and password
your application will be built in a minuite

to check your application, type the following commands:
to list the pods you have do:
$ kubectl get pod

to access the notepad application, you will have to get the service IP address for the notepad deployment:
minikube service notepad-app-service