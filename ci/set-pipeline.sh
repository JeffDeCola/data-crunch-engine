#!/bin/bash
# data-crunch-engine set-pipeline.sh

fly -t ci set-pipeline -p data-crunch-engine -c pipeline.yml --load-vars-from ../../../../../.credentials.yml
