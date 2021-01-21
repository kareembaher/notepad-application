# notepad-application

Hello,

This repo is to create a Notpad web application with Kubernetes.

## Description:
Notepad is a simple Spring boot application, it stores the notes in a MySQL database instance. MySQL database needs to be up and running for notepad to work. It exposes the actuator endpoints as well as the /notes endpoint, which creates a note when it gets a POST request. The main goal is to run Notepad on a Kubernetes cluster (including MySQL).

#### So, the plan will be as follows:
- Build our notepad application.
- Build a docker image out of this application
- Create a deployment with 2 replicas for the Notepad application
- Create 1 pod for Mysql database to store your notes

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

## Repo file structure:
In this repo you will find 2 directories and 2 files:
#### notpad:
This directory containes the application code, along with the Dockerfile that we will use to create our docker image.

#### kubernetes-file:
This directory containes all the nessessary yaml files for creating the pod, deployment, secrets, and services
- notepad.deployment.yml - will create a deployment for the notepad application
- notepad.service.yml - will create a service for the notepad application
- mysql.pod.yml - will create the mysql pod
- mysql.service - will create the service for the mysql pod
- mysql.volume.claim.yml - will create a volume fo mysql to preserve its state if it is restarted
- secrets.yml - where we will store our sensetive data for the notepad and mysql env. variables that will contain the root password and database name. I encrypted the info using this URL https://www.base64decode.org/, if you wish to change any of the info you may edit the secrets file with the new encrypted code from the previous URL

#### build.sh:
This is a simple bash script that sums up all the manual commands you will have to do in order so start the notepad application, you will only be prompted to enter you docker-hub username and password.

#### docker-password.txt:
This file will contain your docker-hub regestry password for your login from the build.sh script.

## How to use:
You will only have to execute the script provided
```
./build.sh
```
Then you will be asked to enter you docker-hub username and password, your application will be built in a minuite

Assuming you already started the Kubernetes cluster in the begining of the documentation steps in Prerequisit section, if not, run this command: 
```
minikube start --driver=docker
```

To check your application is working, type the following commands:
- To list the pods you have do:
```
kubectl get pod
```

- To access the notepad application, you will have to get the service IP address for the notepad or open it directly on your default browser using this command:
```
minikube service notepad-app-service
```

## The build.sh script process:
This section describes what is done behind the scenes.

- When you execute the bash script `build.sh` you will be promted to enter your Docker-hub username and password.
- The password you entered will be stored in the `docker-password.txt` file with this command 
```
echo $password > docker-password.txt
```
- Then you will be logged in using the username and password you provided in the start of the `build.sh` script using this command 
```
cat docker-password.txt | docker login --username $username --password-stdin
```
- The next step is to build our application from the code we have in `notepad` directory using this command 
```
mvn clean install package -Dmaven.test.skip=true
```
- After the previous step is finished, the script will make a docker image out of the built application using this command 
```
docker build -t $username/notepad .
``` 
here the `$username` will be subistituted with the username you provided for the Docker-hub account.
- Now, we will push the image to our docker-hub regestry using this command 
```
docker push $username/notepad
```
- Now we will begin executing the Kubernetes yaml files in `kubernetes-files` directory, assuming that you started the Kubernetes in the steps in `Prerequisit` section, if not, run this command 
```
minikube start --driver=docker
```
- First, we will create our secrets where we stored our encrypted sensitive data including **MYSQL_ROOT_PASSWORD** and **MYSQL_DATABASE** using this command 
```
kubectl create -f secret.yml
```
- Secondly, I configured a volume to be mounted for the mysql pod to preserve its state if its deleted or restarted. So, if you created a new note, and for some reason you deleted the Mysql pod, you will find it when you recreate the Mysql pod again. So we will run this command to create the volume claim for the volume.
```
kubectl create -f mysql.volume.claim.yml
``` 
- Thirdly, we will create our services for the Mysql pod and Notepad deployment, where we will communicate to them and to each other using them, using this command 
```
kubectl create -f mysql.service.yml
``` 
and 
```
kubectl create -f notepad.service.yml
```
- Then, we will start the Mysql pod, where we configured the image to be `mysql v.5.7`, listen to port `3306`, mounted the volume where Mysql stores its data in `/var/lib/mysql`, and env. variables imported from secrets previously created 
```
kubectl create -f mysql.pod.yml
```
- Finally, we will start creating our Notepad deployment, where I configured it with `2 replicas`, listen to port `8080`, env. variables imported from secrets previously created, and the image imported from our notepad image from the Docker-hub regestry. We used this command to start our deployment 
```
kubectl create -f notepad.deployment.yml
```
- Now, you application is ready to be used, you just need to check if your pods are running using this command
```
kubectl get pod
```
- To access your application through the browser, use this command
```
minikube service notepad-app-service
```