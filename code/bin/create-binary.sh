#!/bin/sh -e
# data-crunch-engine code create-binary.sh

echo " "

if [ "$1" = "-debug" ]
then
    echo "************************************************************************"
    echo "* create-binary.sh -debug (START) **************************************"
    echo "************************************************************************"
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -x
    echo " "
else
    echo "************************************************************************"
    echo "* create-binary.sh (START) *********************************************"
    echo "************************************************************************"
    echo " "
fi

echo "Create a binary data-crunch in /bin"
echo "    Kick off executable with ./data-crunch"
go build -o data-crunch ../main.go
echo " "

echo "************************************************************************"
echo "* create-binary.sh (END) ***********************************************"
echo "************************************************************************"
echo " "
