#!/bin/bash

## Prerequisites
#* A private Docker registry (see https://docs.docker.com/registry/deploying/)
#* A node running Docker with access to Docker Hub for downloading Gestalt images
#* A node running Docker with access to private Docker registry to push Gestalt images

## Download and Package Galactic Fog Images from Docker Hub

### 1) Pull Images from Docker Hub

# Pull images
for i in \
  galacticfog/gestalt-api-gateway:release-2.3.1 \
  galacticfog/gestalt-laser-executor-dotnet:release-2.3.1 \
  galacticfog/gestalt-laser-executor-golang:release-2.3.1 \
  galacticfog/gestalt-laser-executor-js:release-2.3.1 \
  galacticfog/gestalt-laser-executor-jvm:release-2.3.1 \
  galacticfog/gestalt-laser-executor-python:release-2.3.1 \
  galacticfog/gestalt-laser-executor-ruby:release-2.3.1 \
  galacticfog/gestalt-laser:release-2.3.1 \
  galacticfog/gestalt-meta:release-2.3.1 \
  galacticfog/gestalt-log:release-2.3.1 \
  galacticfog/gestalt-policy:release-2.3.1 \
  galacticfog/gestalt-security:release-2.3.1 \
  galacticfog/gestalt-ui-react:release-2.3.1 \
  galacticfog/elasticsearch-docker:5.3.1 \
  galacticfog/kong:release-2.3.1 \
  galacticfog/rabbit:release-2.3.1 \
  postgres:9.6.2 \
  nginx:latest \
  nginx:alpine \
  registry:2 \
 ; do
   docker pull $i
    if [ $? -ne 0 ]; then
        echo
        echo "Error pulling '$i'"
        break;
    fi
done

 ### 2) Save Images to TAR file

# Save images using `docker save`:

# Save to tar file
echo "Saving docker images..."
time docker save \
  galacticfog/gestalt-api-gateway:release-2.3.1 \
  galacticfog/gestalt-laser-executor-dotnet:release-2.3.1 \
  galacticfog/gestalt-laser-executor-golang:release-2.3.1 \
  galacticfog/gestalt-laser-executor-js:release-2.3.1 \
  galacticfog/gestalt-laser-executor-jvm:release-2.3.1 \
  galacticfog/gestalt-laser-executor-python:release-2.3.1 \
  galacticfog/gestalt-laser-executor-ruby:release-2.3.1 \
  galacticfog/gestalt-laser:release-2.3.1 \
  galacticfog/gestalt-meta:release-2.3.1 \
  galacticfog/gestalt-log:release-2.3.1 \
  galacticfog/gestalt-policy:release-2.3.1 \
  galacticfog/gestalt-security:release-2.3.1 \
  galacticfog/gestalt-ui-react:release-2.3.1 \
  galacticfog/elasticsearch-docker:5.3.1 \
  galacticfog/kong:release-2.3.1 \
  galacticfog/rabbit:release-2.3.1 \
  postgres:9.6.2 \
  nginx:latest \
  nginx:alpine \
  registry:2 \
 | gzip > gestalt-images.tar.gz


# The resulting TAR file is about 2.6 GB compressed
