#!/bin/sh -e
# data-crunch-engine build.sh

echo " "

if [ "$1" = "-debug" ]
then
    echo "************************************************************************"
    echo "* build.sh -debug (START) **********************************************"
    echo "************************************************************************"
    # set -x enables a mode of the shell where all executed commands
    # are printed to the terminal.
    set -x
    echo " "
else
    echo "************************************************************************"
    echo "* build.sh (START) *****************************************************"
    echo "************************************************************************"
    echo " "
fi

echo "cd to where go code is"
echo "cd .."
cd ..
echo " " 

echo "Build your docker image using Dockerfile"
echo "NOTE: The binary is built using this step"
echo "docker build -f build/Dockerfile -t jeffdecola/data-crunch-engine ."
docker build -f build/Dockerfile -t jeffdecola/data-crunch-engine .
echo " "

echo "Check Docker Image size"
echo "docker images jeffdecola/data-crunch-engine:latest"
docker images jeffdecola/data-crunch-engine:latest
echo " "

echo "Useful commands:"
echo "     docker run --name data-crunch-engine -dit jeffdecola/data-crunch-engine"
echo "     docker exec -i -t data-crunch-engine /bin/bash"
echo "     docker logs data-crunch-engine"
echo " "

echo "************************************************************************"
echo "* build.sh (END) *******************************************************"
echo "************************************************************************"
echo " "
