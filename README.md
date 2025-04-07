# DATA CRUNCH ENGINE

[![Tag Latest](https://img.shields.io/github/v/tag/jeffdecola/data-crunch-engine)](https://github.com/JeffDeCola/data-crunch-engine/tags)
[![jeffdecola.com](https://img.shields.io/badge/website-jeffdecola.com-blue)](https://jeffdecola.com)
[![MIT License](https://img.shields.io/:license-mit-blue.svg)](https://jeffdecola.mit-license.org)
[![Go Reference](https://pkg.go.dev/badge/github.com/JeffDeCola/data-crunch-engine.svg)](https://pkg.go.dev/github.com/JeffDeCola/data-crunch-engine)
[![Go Report Card](https://goreportcard.com/badge/github.com/JeffDeCola/data-crunch-engine)](https://goreportcard.com/report/github.com/JeffDeCola/data-crunch-engine)
[![Docker Pulls](https://badgen.net/docker/pulls/jeffdecola/data-crunch-engine?icon=docker&label=pulls)](https://hub.docker.com/r/jeffdecola/data-crunch-engine/)

```text
*** THIS CHEAT SHEET IS UNDER CONSTRUCTION - CHECK BACK SOON ***
```

_A lightweight asynchronous microservice that will receive data,
crunch data and return the results. You provide the data crunching algorithm._

Table of Contents

* [OVERVIEW](https://github.com/JeffDeCola/data-crunch-engine#overview)
* [PREREQUISITES](https://github.com/JeffDeCola/data-crunch-engine#prerequisites)
* [SOFTWARE STACK](https://github.com/JeffDeCola/data-crunch-engine#software-stack)
* [PROTOCOL COMPILE FOR GO](https://github.com/JeffDeCola/data-crunch-engine#protocol-compile-for-go)
* [RUN](https://github.com/JeffDeCola/data-crunch-engine#run)
* [CREATE BINARY](https://github.com/JeffDeCola/data-crunch-engine#create-binary)
* [STEP 1 - TEST](https://github.com/JeffDeCola/data-crunch-engine#step-1---test)
* [STEP 2 - BUILD (DOCKER IMAGE VIA DOCKERFILE)](https://github.com/JeffDeCola/data-crunch-engine#step-2---build-docker-image-via-dockerfile)
* [STEP 3 - PUSH (TO DOCKERHUB)](https://github.com/JeffDeCola/data-crunch-engine#step-3---push-to-dockerhub)
* [STEP 4 - DEPLOY (TO DOCKER)](https://github.com/JeffDeCola/data-crunch-engine#step-4---deploy-to-docker)
* [CONTINUOUS INTEGRATION & DEPLOYMENT](https://github.com/JeffDeCola/data-crunch-engine#continuous-integration--deployment)

Documentation and References

* [data-crunch-engine docker image](https://hub.docker.com/r/jeffdecola/data-crunch-engine)
  on DockerHub
* This repos
  [github webpage](https://jeffdecola.github.io/data-crunch-engine/)
  _built with
  [concourse](https://github.com/JeffDeCola/data-crunch-engine/blob/master/ci-README.md)_

## OVERVIEW

This `data-crunch-engine` is,

* Written in go
* Utilizes goroutines (concurrency)
* Uses protobuf over NATS for messaging
* Built to a lightweight Docker Image

This illustration shows a high level view,

![IMAGE - data-crunch-engine-high-level-view - IMAGE](docs/pics/data-crunch-engine-high-level-view.svg)

Notice that you may have multiple `data-crunch-engine`s running.

And a more detailed view of the data-crunch engine,

![IMAGE - data-crunch-engine - IMAGE](docs/pics/data-crunch-engine.svg)

## PREREQUISITES

You will need the following go packages,

```bash
go get -u -v github.com/sirupsen/logrus
go get -u -v github.com/cweill/gotests/...
```

## SOFTWARE STACK

* DEVELOPMENT
  * [go](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/development/languages/go-cheat-sheet)
  * gotests
* OPERATIONS
  * [concourse/fly](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations/continuous-integration-continuous-deployment/concourse-cheat-sheet)
    (optional)
  * [docker](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations/orchestration/builds-deployment-containers/docker-cheat-sheet)
* SERVICES
  * [dockerhub](https://hub.docker.com/)
  * [github](https://github.com/)

Where,

* **GUI**
  _golang net/http package and ReactJS_
* **Routing & REST API framework**
  _golang gorilla/mux package_
* **Backend**
  _golang_
* **Database**
  _N/A_

## PROTOCOL COMPILE FOR GO

The protocol buffer human readable file is located
[here](https://github.com/JeffDeCola/data-crunch-engine/blob/master/proto/messages.proto)

The two interfaces have been defined as,

```go
// Check your error
func checkErr(err error) {
    if err != nil {
        log.Fatal("ERROR:", err)
    }
}
```

```proto
message MyData {
    int64 ID = 1;
    int64 Data = 2;
    string Meta = 3;
}
```

```proto
message MyResult {
    int64 ID = 1;
    int64 Data = 2;
    string Meta = 3;
    google.protobuf.Timestamp DTimeStamp = 4;
    int64 RData = 5;
    google.protobuf.Timestamp ProcessTime = 6;
}
```

This file has already been compiled, but you may recompile it using the shell script.

## RUN

First, start your NATS server,

```bash
nats-server -DV -p 4222 -a 127.0.0.1
```

In separate terminals start the `data-engine`, the `data-crunch-engine`
and the `results-engine` respectively,

```bash
go run data-engine.go messages.pb.go
go run data-crunch-engine.go messages.pb.go
go run results-engine.go messages.pb.go
```

Currently, I have a placeholder as follows,

To
[run.sh](https://github.com/JeffDeCola/data-crunch-engine/blob/master/data-crunch-engine-code/run.sh),

```bash
cd data-crunch-engine-code
go run main.go
```

As a placeholder, every 2 seconds it will print,

```txt
    INFO[0000] Let's Start this!
    Hello everyone, count is: 1
    Hello everyone, count is: 2
    Hello everyone, count is: 3
    etc...
```

## CREATE BINARY

To
[create-binary.sh](https://github.com/JeffDeCola/data-crunch-engine/blob/master/data-crunch-engine-code/bin/create-binary.sh),

```bash
cd data-crunch-engine-code/bin
go build -o data-crunch-engine ../main.go
./data-crunch-engine
```

This binary will not be used during a docker build
since it creates it's own.

## STEP 1 - TEST

To create unit `_test` files,

```bash
cd data-crunch-engine-code
gotests -w -all main.go
```

To run
[unit-tests.sh](https://github.com/JeffDeCola/data-crunch-engine/tree/master/data-crunch-engine-code/test/unit-tests.sh),

```bash
go test -cover ./... | tee test/test_coverage.txt
cat test/test_coverage.txt
```

## STEP 2 - BUILD (DOCKER IMAGE VIA DOCKERFILE)

To
[build.sh](https://github.com/JeffDeCola/data-crunch-engine/blob/master/data-crunch-engine-code/build/build.sh)
with a
[Dockerfile](https://github.com/JeffDeCola/data-crunch-engine/blob/master/data-crunch-engine-code/build/Dockerfile),

```bash
cd data-crunch-engine-code
docker build -f build/Dockerfile -t jeffdecola/data-crunch-engine .
```

You can check and test this docker image,

```bash
docker images jeffdecola/data-crunch-engine:latest
docker run --name data-crunch-engine -dit jeffdecola/data-crunch-engine
docker exec -i -t data-crunch-engine /bin/bash
docker logs data-crunch-engine
docker rm -f data-crunch-engine
```

In **stage 1**, rather than copy a binary into a docker image (because
that can cause issues), the Dockerfile will build the binary in the
docker image,

```bash
FROM golang:alpine AS builder
RUN go get -d -v
RUN go build -o /go/bin/data-crunch-engine main.go
```

In **stage 2**, the Dockerfile will copy the binary created in
stage 1 and place into a smaller docker base image based
on `alpine`, which is around 13MB.

## STEP 3 - PUSH (TO DOCKERHUB)

You must be logged in to DockerHub,

```bash
docker login
```

To
[push.sh](https://github.com/JeffDeCola/data-crunch-engine/blob/master/data-crunch-engine-code/push/push.sh),

```bash
docker push jeffdecola/data-crunch-engine
```

Check the
[data-crunch-engine docker image](https://hub.docker.com/r/jeffdecola/data-crunch-engine)
at DockerHub.

## STEP 4 - DEPLOY (TO DOCKER)

To
[deploy.sh](https://github.com/JeffDeCola/data-crunch-engine/blob/master/data-crunch-engine-code/deploy/deploy.sh),

```bash
cd data-crunch-engine-code
docker run --name data-crunch-engine -dit jeffdecola/data-crunch-engine
docker exec -i -t data-crunch-engine /bin/bash
docker logs data-crunch-engine
docker rm -f data-crunch-engine
```

## CONTINUOUS INTEGRATION & DEPLOYMENT

Refer to
[ci-README.md](https://github.com/JeffDeCola/data-crunch-engine/blob/master/ci-README.md)
on how I automated the above steps.
