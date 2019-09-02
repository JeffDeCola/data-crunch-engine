#!/bin/bash -e
# data-crunch-engine enable-docker-container-boot.sh

echo " " 
echo "************************************************************************"
echo "****************************** enable-docker-container-boot.sh (START) *"
echo "You are root in /home/packer"
echo " "

echo "Get the image from dockerhub and run it forever - name the container hello-go"
# docker pull jeffdecola/data-crunch-engine
# docker run jeffdecola/data-crunch-engine
# -name names the docker container.
# -restart unless stopped, means it will always run.
docker run --name hello-go -dit --restart unless-stopped jeffdecola/data-crunch-engine
echo " "

echo "******************************** enable-docker-container-boot.sh (END) *"
echo "************************************************************************"
echo " "
