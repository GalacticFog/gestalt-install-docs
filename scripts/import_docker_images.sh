
## Prerequisites
#* A private Docker registry (see https://docs.docker.com/registry/deploying/)
#* A node running Docker with access to Docker Hub for downloading Gestalt images
#* A node running Docker with access to private Docker registry to push Gestalt images

## Download and Package Galactic Fog Images from Docker Hub

### 1) Pull Images from Docker Hub

time \
docker load -i gestalt-images.tar.gz

repo_prefix="my.private.registry.example.com"

### 2) Re-Tag and push Gestalt Images for Private Registry

for i in \
  galacticfog/gestalt-installer:3.0.3 \
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
 ; do
   docker tag $i $repo_prefix/$i
   docker push $repo_prefix/$i
 done

for i in \
  postgres:9.6.2 \
  nginx:latest \
  nginx:alpine \
  registry:2 \
 ; do
   docker tag $i $repo_prefix/$i
   docker push $repo_prefix/$i
 done
