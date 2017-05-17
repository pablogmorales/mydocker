# # # # STEPS # # # #

# DO NOT use  this images in a production environment, this image was created
# for testing purposes and no security in mind, default passwords were used
# for root user and mysql admin user.


1 - Make sure you have docker-ce installed, if you are using ubuntu 16.04 add the following
    line to /etc/apt/sources.list 
    deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable

    Then update the repos:
    apt-get update 
    
    Install Docker-CE Community Edition
    apt-get install -y docker-ce apt-transport-https ca-certificates curl software-properties-common

    Add the keys:
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

2 - Install git if it's no intalled yet 
    apt-get install -y git

2 - Create a temporary directory , this can be /tmp/dockertest and change to that directory:
    mkdir /tmp/dockertest
    cd /tmp/dockertest

    Clone my repo to get the required files:
    git clone https://github.com/pablogmorales/mydocker.git

3 - Create the container, this will download an ubuntu image 16.04 - Xenial
    docker build . -t pabloupworktest
    
4 - After the compilation completes you should see a new images like this:
    
    docker images
	
	REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
	pabloupworktest     latest              6e5805b8e5e0        50 seconds ago      796 MB

5 - Execute the container as follow, this will expose the port 8080 from the container to your localhost on 8080,
    if you have it already in use choose another one, for example 8088.

    docker run -d  -p 127.0.0.1:8080:8080 pabloupworktest:latest
    You should see the container is running with the following command:

    docker ps
    CONTAINER ID    IMAGE                    COMMAND                  CREATED        STATUS         PORTS                              NAMES
    9e2f6ffc4a0a    pabloupworktest:latest   "/usr/bin/supervisord"   4 seconds ago  Up 2 seconds   22/tcp, 127.0.0.1:8080->8080/tcp   practical_kalam
    

6 - To see the data use your favourite browser and point it to:
    http://localhost:8080/index.php 
 
7 - To connect to the container execute:
    docker exec -i -t 9e2f6ffc4a0a  /bin/bash  

8  - To exit the container just type exit to return to your local prompt.


9 - To get rid of the container and image do the following:
   
    docker stop 9e2f6ffc4a0a ( replace this ID with the one you've got from the docker ps command above )
    docker rm 9e2f6ffc4a0a   ( replace this ID with the one you've got from the docker ps command above )
  
    docker rmi 6e5805b8e5e0 ( replace with the IMAGE ID number you've got from the docker images command above )

 

During the start up process a couple of things will happen:

    	A - The local MySQL server will be configure with default values
	B - Nginx and php-fpm will be configured to accept requests on port 8080
        C - SSHD service will be configure, handy in case you want to connect to the container 
	    ( default root password is password )
	D - salt-minion will be configured against salt-master ( default container )
	E - The external repo containing the employees database will be cloned
	F - The employees database will be imported into the MySQL Server

        
EOF
