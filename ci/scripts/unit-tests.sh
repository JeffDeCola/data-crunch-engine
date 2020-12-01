#!/bin/sh
# data-crunch-engine unit-test.sh

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

echo "The goal is to set up a go src/github.com/JeffDeCola/data-crunch-engine directory"
echo "Then tests will be run in that directory"
echo "Test coverage results, text_coverage.txt, will be moved to /coverage-results directory"
echo " "

echo "At start, you should be in a /tmp/build/xxxxx directory with two folders:"
echo "   /data-crunch-engine"
echo "   /coverage-results (created in task-unit-test.yml task file)"
echo " "

echo "pwd is: $PWD"
echo " "

echo "export START_DIRECTORY=$PWD"
export START_DIRECTORY="$PWD"
echo " "

echo "List whats in the current directory"
ls -la
echo " "

echo "mkdir -p $GOPATH/src/github.com/JeffDeCola/"
mkdir -p "$GOPATH/src/github.com/JeffDeCola/"
echo " "

echo "cp -R ./data-crunch-engine $GOPATH/src/github.com/JeffDeCola/."
cp -R "./data-crunch-engine" "$GOPATH/src/github.com/JeffDeCola/."
echo " "

echo "cd $GOPATH/src/github.com/JeffDeCola/data-crunch-engine"
cd "$GOPATH/src/github.com/JeffDeCola/data-crunch-engine"
echo " "

echo "Check that you are set and everything is in the right place for go:"
echo "gopath is: $GOPATH"
echo "pwd is: $PWD"
go version

echo "Get packages"
echo "go get -u github.com/golang/protobuf/proto"
go get -u github.com/golang/protobuf/proto
echo "go get -u github.com/nats-io/nats.go/"
go get -u github.com/nats-io/nats.go/
echo "go get -u github.com/sirupsen/logrus"
go get -u github.com/sirupsen/logrus

echo "ls -la"
ls -la
echo " "

echo "Run go test -cover"
echo "   -cover shows the percentage coverage"
echo "   Put results in /test/test_coverage.txt file"
# go test -cover ./... | tee test/test_coverage.txt
mkdir test
echo "Placeholder to run go tests for my-go-examples" | tee test/test_coverage.txt
echo " "

echo "Clean test_coverage.txt file - add some whitespace to the begining of each line"
sed -i -e 's/^/     /' test/test_coverage.txt
echo " "

echo "The test_coverage.txt file will be used by the concourse pipeline to send to slack"
echo " "

echo "Move test/text_coverage.txt to /coverage-results directory"
mv "test/test_coverage.txt" "$GOPATH/coverage-results/"
echo " "

echo "unit-tests.sh (END)"
echo " "
