#!/bin/bash
# data-crunch-engine makeproto.sh

echo " "
echo "**********************************************************************"
echo "*********************************************** makeproto.sh (START) *"
echo " "

echo "protoc --go_out=. messages.proto"
protoc -I. \
    -I$GOPATH/src \
    -I$GOPATH/src/github.com/golang/protobuf/ptypes/timestamp/timestamp.proto \
    --go_out=. messages.proto
echo " "

echo "cp messages.pb.go ../data-crunch-engine/."
cp messages.pb.go ../data-crunch-engine/.
echo "cp messages.pb.go ../results-engine/."
cp messages.pb.go ../results-engine/.
echo "cp messages.pb.go ../data-engine/."
cp messages.pb.go ../data-engine/.
echo ""

echo "*************************************************** makeproto.sh (END) *"
echo "************************************************************************"
echo " "
