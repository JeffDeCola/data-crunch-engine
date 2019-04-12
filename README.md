# data-crunch-engine

[![Go Report Card](https://goreportcard.com/badge/github.com/JeffDeCola/data-crunch-engine)](https://goreportcard.com/report/github.com/JeffDeCola/data-crunch-engine)
[![GoDoc](https://godoc.org/github.com/JeffDeCola/data-crunch-engine?status.svg)](https://godoc.org/github.com/JeffDeCola/data-crunch-engine)
[![Maintainability](https://api.codeclimate.com/v1/badges/6ed9dfb17eedad9c40ee/maintainability)](https://codeclimate.com/github/JeffDeCola/data-crunch-engine/maintainability)
[![Issue Count](https://codeclimate.com/github/JeffDeCola/data-crunch-engine/badges/issue_count.svg)](https://codeclimate.com/github/JeffDeCola/data-crunch-engine/issues)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://jeffdecola.mit-license.org)

`data-crunch-engine` _is a small asynchronous microservice that will receive data,
crunch data and return the results._

The `data-crunch-engine`
[Docker Image](https://hub.docker.com/r/jeffdecola/data-crunch-engine)
on DockerHub.

The `data-crunch-engine`
[GitHub Webpage](https://jeffdecola.github.io/data-crunch-engine/).

## PREREQUISITES

For this exercise I used go.  Feel free to use a language of your choice,

* [go](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/development/languages/go-cheat-sheet)

To build a docker image you will need docker on your machine,

* [docker](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/orchestration/builds-deployment-containers/docker-cheat-sheet)

To push a docker image you will need,

* [DockerHub account](https://hub.docker.com/)

As a bonus, you can use Concourse CI to run the scripts,

* [concourse](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/continuous-integration-continuous-deployment/concourse-cheat-sheet)
  (Optional)

## RUN

To run from the command line,

```bash
go run main.go
```

Every 2 seconds `data-crunch-engine` will print:

```bash
Hello everyone, count is: 1
Hello everyone, count is: 2
Hello everyone, count is: 3
etc...
```

![IMAGE - data-crunch-engine - IMAGE](docs/pics/data-crunch-engine.jpg)

## STEP 1 - TEST

Lets unit test the code,

```bash
go test -cover ./... | tee /test/test_coverage.txt
```

There is a `unit-tests.sh` script to run the unit tests.
There is also a script in the /ci folder to run the unit tests
in concourse.

## STEP 2 - BUILD (DOCKER IMAGE VIA DOCKERFILE)

We will be using a multi-stage build using a Dockerfile.
The end result will be a very small docker image around 13MB.

```bash
docker build -f build-push/Dockerfile -t jeffdecola/data-crunch-engine .
```

Obviously, replace `jeffdecola` with your DockerHub username.

In stage 1, rather than copy a binary into a docker image (because
that can cause issue), the Dockerfile will build the binary in the
docker image.

If you open the DockerFile you can see it will get the dependencies and
build the binary in go,

```bash
FROM golang:alpine AS builder
RUN go get -d -v
RUN go build -o /go/bin/data-crunch-engine main.go
```

In stage 2, the Dockerfile will copy the binary created in
stage 1 and place into a smaller docker base image based
on `alpine`, which is around 13MB.

You can check and test your docker image,

```bash
docker run --name data-crunch-engine -dit jeffdecola/data-crunch-engine
docker exec -i -t data-crunch-engine /bin/bash
docker logs data-crunch-engine
docker images jeffdecola/data-crunch-engine:latest
```

There is a `build-push.sh` script to build and push to DockerHub.
There is also a script in the /ci folder to build and push
in concourse.

## STEP 3 - PUSH (TO DOCKERHUB)

Lets push your docker image to DockerHub.

If you are not logged in, you need to login to dockerhub,

```bash
docker login
```

Once logged in you can push to DockerHub

```bash
docker push jeffdecola/data-crunch-engine
```

Check you image at DockerHub. My image is located
[https://hub.docker.com/r/jeffdecola/data-crunch-engine](https://hub.docker.com/r/jeffdecola/data-crunch-engine).

There is a `build-push.sh` script to build and push to DockerHub.
There is also a script in the /ci folder to build and push
in concourse.

## STEP 4 - DEPLOY

tbd

## TEST, BUILT, PUSH & DEPLOY USING CONCOURSE (OPTIONAL)

For fun, I use concourse to automate the above steps.

A pipeline file [pipeline.yml](https://github.com/JeffDeCola/data-crunch-engine/tree/master/ci/pipeline.yml)
shows the entire ci flow. Visually, it looks like,

![IMAGE - data-crunch-engine concourse ci pipeline - IMAGE](docs/pics/data-crunch-engine-pipeline.jpg)

The `jobs` and `tasks` are,

* `job-readme-github-pages` runs task
  [readme-github-pages.sh](https://github.com/JeffDeCola/data-crunch-engine/tree/master/ci/scripts/readme-github-pages.sh).
* `job-unit-tests` runs task
  [unit-tests.sh](https://github.com/JeffDeCola/data-crunch-engine/tree/master/ci/scripts/unit-tests.sh).
* `job-build-push` runs task
  [build-push.sh](https://github.com/JeffDeCola/data-crunch-engine/tree/master/ci/scripts/build-push.sh).
* `job-deploy` runs task
  [deploy.sh](https://github.com/JeffDeCola/data-crunch-engine/tree/master/ci/scripts/deploy.sh).

The concourse `resources type` are,

* `data-crunch-engine` uses a resource type
  [docker-image](https://hub.docker.com/r/concourse/git-resource/)
  to PULL a repo from github.
* `resource-dump-to-dockerhub` uses a resource type
  [docker-image](https://hub.docker.com/r/concourse/docker-image-resource/)
  to PUSH a docker image to dockerhub.
* `resource-marathon` users a resource type
  [docker-image](https://hub.docker.com/r/ckaznocha/marathon-resource)
  to DEPLOY the newly created docker image to marathon.
* `resource-slack-alert` uses a resource type
  [docker image](https://hub.docker.com/r/cfcommunity/slack-notification-resource)
  that will notify slack on your progress.
* `resource-repo-status` uses a resource type
  [docker image](https://hub.docker.com/r/dpb587/github-status-resource)
  that will update your git status for that particular commit.

For more information on using concourse for continuous integration,
refer to my cheat sheet on [concourse](https://github.com/JeffDeCola/my-cheat-sheets/tree/master/software/operations-tools/continuous-integration-continuous-deployment/concourse-cheat-sheet).
