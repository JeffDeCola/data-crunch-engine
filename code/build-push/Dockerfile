# data-crunch-engine code Dockerfile used to build docker image

# Multi-stage build to create a small docker image

#################################
# STAGE 1 build executable binary
#################################

FROM golang:alpine AS builder

# Install git
# Git is required for fetching the dependencies
RUN apk update && apk add --no-cache git

# SET WORKING DIRECTORY AND PLACE YOUR CODE IN
WORKDIR $GOPATH/src/github.com/jeffdecola/data-crunch-engine/
COPY . .

# CHECK
RUN ls -lat $GOPATH/src/github.com/jeffdecola/data-crunch-engine/

# Fetch dependencies using go get
RUN go get -u -v github.com/sirupsen/logrus
RUN go get -d -v

# Build the binary
RUN go build -o /go/bin/data-crunch-engine main.go

###############################
# STAGE 2 build a smaller image
###############################

FROM alpine

# Add my name to it
LABEL maintainer="Jeff DeCola https://github.com/JeffDeCola/data-crunch-engine"

# Put the binary from previous build into /app
RUN mkdir /app
COPY --from=builder /go/bin/data-crunch-engine /app/data-crunch-engine
WORKDIR /app

# Add the ailibty to /bin/bash in alpine
RUN apk add --update bash

# Run the binary
ENTRYPOINT ["/app/data-crunch-engine"]
