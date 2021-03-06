#!/bin/sh -e
# data-crunch-engine build-push.sh

echo " "

if [ "$1" = "-debug" ]
then
    echo "************************************************************************"
    echo "* build-push.sh -debug (START) *****************************************"
    echo "************************************************************************"
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -x
    echo " "
else
    echo "************************************************************************"
    echo "* build-push.sh (START) ************************************************"
    echo "************************************************************************"
    echo " "
fi

echo "cd up to code"
cd ..
echo " "

#echo "Create a binary hello-go in /bin"
#go build -o bin/hello-go main.go
#echo " "

#echo "Copy the binary in /build-push because docker needs it with Dockerfile"
#cp bin/hello-go build-push/.
#echo " "

#echo "cd build-push"
#cd build-push
#echo " "

echo "Build your docker image from binary /bin/hello-go using /build-push/Dockerfile"
docker build -f build-push/Dockerfile -t jeffdecola/data-crunch-engine .
echo " "

echo "Image size"
docker images jeffdecola/data-crunch-engine:latest
echo " "

echo "Assuming you are logged in, lets push your built docker image to DockerHub"
docker push jeffdecola/data-crunch-engine
echo " "

echo "Useful commands:"
echo "     docker run --name data-crunch-engine -dit jeffdecola/data-crunch-engine"
echo "     docker exec -i -t data-crunch-engine /bin/bash"
echo "     docker logs data-crunch-engine"
echo " "

echo "************************************************************************"
echo "* build-push.sh (END) **************************************************"
echo "************************************************************************"
echo " "
