#!/bin/sh
# data-crunch-engine unit-tests.sh

echo " "

if [ "$1" = "-debug" ]
then
    echo "unit-tests.sh -debug (START)"
    # set -e causes the shell to exit if any subcommand or pipeline returns a non-zero status. Needed for concourse.
    # set -x enables a mode of the shell where all executed commands are printed to the terminal.
    set -e -x
    echo " "
else
    echo "unit-tests.sh (START)"
    # set -e causes the shell to exit if any subcommand or pipeline returns a non-zero status.  Needed for concourse.
    set -e
    echo " "
fi

echo "GOAL ----------------------------------------------------------------------------------"
echo " "

echo "The goal is to set up a go src/github.com/JeffDeCola/data-crunch-engine directory"
echo "Then tests will be run in that directory"
echo "Test coverage results, text_coverage.txt, will be moved to /coverage-results directory"
echo " "

echo "CHECK THINGS --------------------------------------------------------------------------"
echo " "

echo "At start, you should be in a /tmp/build/xxxxx directory with two folders:"
echo "   /data-crunch-engine"
echo "   /coverage-results (created in task-unit-test.yml task file)"
echo " "

echo "pwd is: $PWD"
echo " "

echo "List whats in the current directory"
ls -la
echo " "

echo "SETUP GO ------------------------------------------------------------------------------"
echo " "

echo "Setup the GOPATH based on current directory"
echo "export GOPATH=\$PWD"
export GOPATH=$PWD
echo " "

echo "Now we must move our code from the current directory ./data-crunch-engine to" 
echo "$GOPATH/src/github.com/JeffDeCola/data-crunch-engine"
echo "mkdir -p src/github.com/JeffDeCola/"
mkdir -p src/github.com/JeffDeCola/
echo "cp -R ./data-crunch-engine src/github.com/JeffDeCola/."
cp -R ./data-crunch-engine src/github.com/JeffDeCola/.
echo " "

echo "cd src/github.com/JeffDeCola/data-crunch-engine/data-crunch-engine-code"
cd src/github.com/JeffDeCola/data-crunch-engine/data-crunch-engine-code
echo " "

echo "Check that you are set and everything is in the right place for go:"
echo "gopath is: $GOPATH"
echo "pwd is: $PWD"
go version

echo "ls -la"
ls -la
echo " "

echo "GET GO PACKAGES -----------------------------------------------------------------------"
echo " "

echo "go get -u -v github.com/sirupsen/logrus"
go get -u -v github.com/sirupsen/logrus
echo " "

echo "RUN TESTS -----------------------------------------------------------------------------"
echo " "

echo "Run go tests"
echo "go test -cover ./... | tee test/test_coverage.txt"
echo "   -cover shows the percentage coverage"
echo "   Put results in /test/test_coverage.txt file"
go test -cover ./... | tee test/test_coverage.txt

# echo "TEST PLACEHOLDER -----------------------------------------------------------------------"
# echo " "

# echo "mkdir -p test"
# mkdir -p test
# echo "Placeholder to run go tests for data-crunch-engine" | tee test/test_coverage.txt
# echo " "

echo "Clean test_coverage.txt file - add some whitespace to the begining of each line"
echo "sed -i -e 's/^/     /' test/test_coverage.txt"
sed -i -e 's/^/     /' test/test_coverage.txt
echo " "

echo "MOVE TEST COVERAGE FILE ---------------------------------------------------------------"
echo " "

echo "The test_coverage.txt file will be used by the concourse pipeline to send to slack"
echo " "

echo "Move text_coverage.txt to /coverage-results directory"
mv "test/test_coverage.txt" "$GOPATH/coverage-results/"
echo " "

echo "unit-tests.sh (END)"
echo " "
