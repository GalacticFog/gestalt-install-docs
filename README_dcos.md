# Gestalt Platform Offline Installation for DC/OS

The following detail the offline installation process for DC/OS.

## Prerequisites
* A private Docker registry (see https://docs.docker.com/registry/deploying/)
* A node running Docker with access to Docker Hub for downloading Gestalt images
* A node running Docker with access to private Docker registry to push Gestalt images

## Download and Package Galactic Fog Images from Docker Hub

Run the following from a node running Docker with access to Docker Hub:

### 1) Pull Images from Docker Hub

Download images with `docker pull`:

```sh
# Pull images
for i in \
  galacticfog/gestalt-api-gateway:release-1.2.0 \
  galacticfog/gestalt-dcos:1.2.0 \
  galacticfog/gestalt-laser-executor-dotnet:release-1.2.0 \
  galacticfog/gestalt-laser-executor-golang:release-1.2.0 \
  galacticfog/gestalt-laser-executor-js:release-1.2.0 \
  galacticfog/gestalt-laser-executor-jvm:release-1.2.0 \
  galacticfog/gestalt-laser-executor-python:release-1.2.0 \
  galacticfog/gestalt-laser-executor-ruby:release-1.2.0 \
  galacticfog/gestalt-laser:release-1.2.0 \
  galacticfog/gestalt-meta:release-1.2.0 \
  galacticfog/gestalt-policy:release-1.2.0 \
  galacticfog/gestalt-security:release-1.2.0 \
  galacticfog/gestalt-ui-react:release-1.2.0 \
  galacticfog/kong:release-1.2.0 \
  galacticfog/postgres_repl:release-1.2.0 \
  galacticfog/rabbit:release-1.2.0 \
  galacticfog/universe-server:gestalt-1.2.0 \
 ; do
   docker pull $i
 done
 ```

 ### 2) Save Images to TAR file

 Save images using `docker save`:

```sh
# Save to tar file
docker save \
  galacticfog/gestalt-api-gateway:release-1.2.0 \
  galacticfog/gestalt-dcos:1.2.0 \
  galacticfog/gestalt-laser-executor-dotnet:release-1.2.0 \
  galacticfog/gestalt-laser-executor-golang:release-1.2.0 \
  galacticfog/gestalt-laser-executor-js:release-1.2.0 \
  galacticfog/gestalt-laser-executor-jvm:release-1.2.0 \
  galacticfog/gestalt-laser-executor-python:release-1.2.0 \
  galacticfog/gestalt-laser-executor-ruby:release-1.2.0 \
  galacticfog/gestalt-laser:release-1.2.0 \
  galacticfog/gestalt-meta:release-1.2.0 \
  galacticfog/gestalt-policy:release-1.2.0 \
  galacticfog/gestalt-security:release-1.2.0 \
  galacticfog/gestalt-ui-react:release-1.2.0 \
  galacticfog/kong:release-1.2.0 \
  galacticfog/postgres_repl:release-1.2.0 \
  galacticfog/rabbit:release-1.2.0 \
  galacticfog/universe-server:gestalt-1.2.0 \
 > gestalt-dcos-images-1.2.0.tar

# Optionally compress the tar file prior to transfer
# gzip gestalt-dcos-images-1.2.0.tar

```
The resulting TAR file is about 4-5 GB uncompressed.

## Load Galactic Fog Images into Private Docker Registry

Run the following from a node with access to the Private Docker registry.

### 1) Load Gestalt Images from TAR File

Transfer `gestalt-dcos-images-1.2.0.tar` to the private Docker registry node, then load the images into the registry using `docker load`:

```sh

# First transfer 'gestalt-dcos-images-1.2.0.tar'

$ docker load -i gestalt-dcos-images-1.2.0.tar
Loaded image: galacticfog/gestalt-laser-executor-dotnet:release-1.2.0
Loaded image: galacticfog/gestalt-laser-executor-ruby:release-1.2.0
Loaded image: galacticfog/gestalt-policy:release-1.2.0
Loaded image: galacticfog/rabbit:release-1.2.0
Loaded image: galacticfog/kong:release-1.2.0
Loaded image: galacticfog/gestalt-laser-executor-js:release-1.2.0
Loaded image: galacticfog/gestalt-laser-executor-jvm:release-1.2.0
Loaded image: galacticfog/gestalt-laser-executor-python:release-1.2.0
Loaded image: galacticfog/gestalt-laser:release-1.2.0
Loaded image: galacticfog/gestalt-security:release-1.2.0
Loaded image: galacticfog/gestalt-dcos:1.2.0
Loaded image: galacticfog/gestalt-laser-executor-golang:release-1.2.0
Loaded image: galacticfog/gestalt-meta:release-1.2.0
Loaded image: galacticfog/postgres_repl:release-1.2.0
Loaded image: galacticfog/gestalt-api-gateway:release-1.2.0
Loaded image: galacticfog/gestalt-ui-react:release-1.2.0
Loaded image: galacticfog/universe-server:gestalt-1.2.0
```

### 2) Re-Tag and push Gestalt Images for Private Registry

```sh
for i in \
  galacticfog/gestalt-api-gateway:release-1.2.0 \
  galacticfog/gestalt-dcos:1.2.0 \
  galacticfog/gestalt-laser-executor-dotnet:release-1.2.0 \
  galacticfog/gestalt-laser-executor-golang:release-1.2.0 \
  galacticfog/gestalt-laser-executor-js:release-1.2.0 \
  galacticfog/gestalt-laser-executor-jvm:release-1.2.0 \
  galacticfog/gestalt-laser-executor-python:release-1.2.0 \
  galacticfog/gestalt-laser-executor-ruby:release-1.2.0 \
  galacticfog/gestalt-laser:release-1.2.0 \
  galacticfog/gestalt-meta:release-1.2.0 \
  galacticfog/gestalt-policy:release-1.2.0 \
  galacticfog/gestalt-security:release-1.2.0 \
  galacticfog/gestalt-ui-react:release-1.2.0 \
  galacticfog/kong:release-1.2.0 \
  galacticfog/postgres_repl:release-1.2.0 \
  galacticfog/rabbit:release-1.2.0 \
  galacticfog/universe-server:gestalt-1.2.0 \
 ; do
   docker tag $i my.private.repo/$i
   docker push my.private.repo/$i
 done
```


## Run Gestalt Platform Launcher from DC/OS Dashboard

### 1) Construct a JSON Payload for the Gestalt DC/OS Launcher

Using the below example, modify the following under the `cmd` field:
 - Modify `-Ddatabase.password` parameter with a password of your choice.
 - Modify `-Dsecurity.password` parameter with a password of your choice.
 - Modify `-Dmeta.company-name` parameter with your company name.
 - Modify `-Dmarathon.tld` parameter corresponding to DNS settings (e.g. `gestalt-poc.internal.mycompany.com`)
 - Also, modify the `GESTALT_*_IMG` parmeters in the `env` field to reference the location of the images in your private registry.

JSON Example:
```json
{
  "id": "/gestalt-poc/dcos-launcher",
  "cmd": "./bin/gestalt-dcos -Dhttp.port=$PORT0 -Dmeta.company-name=\"COMPANY NAME\" -Dmarathon.url=http://marathon.mesos:8080 -Dmarathon.app-group=gestalt-poc -Dlaser.scale-down-timeout=60 -Dlaser.max-port-range=60500 -Dlaser.min-port-range=60000 -Dlaser.min-cool-executors=1 -Dlaser.enable-js-runtime=true -Dlaser.enable-jvm-runtime=true -Dlaser.enable-dotnet-runtime=true -Dlaser.enable-golang-runtime=true -Dlaser.enable-python-runtime=true -Dlaser.enable-ruby-runtime=true -Dsecurity.username=gfadmin -Dsecurity.password=\"ENTER A PASSWORD\" -Ddatabase.num-secondaries=0 -Ddatabase.prefix=gestalt- -Ddatabase.username=gestaltdev -Ddatabase.password=\"ENTER A PASSWORD\" -Ddatabase.provision=true -Ddatabase.provisioned-size=100 -Dmarathon.tld=\"gestalt-poc.internal.mycompany.com\"",
  "env": {
    "JVM_OPTS": "-Xmx384m",
    "GESTALT_FRAMEWORK_VERSION": "1.2.0",
    "GESTALT_DATA_IMG": "galacticfog/postgres_repl:release-1.2.0",
    "GESTALT_RABBIT_IMG": "galacticfog/rabbit:release-1.2.0",
    "GESTALT_KONG_IMG": "galacticfog/kong:release-1.2.0",
    "GESTALT_SECURITY_IMG": "galacticfog/gestalt-security:release-1.2.0",
    "GESTALT_META_IMG": "galacticfog/gestalt-meta:release-1.2.0",
    "GESTALT_POLICY_IMG": "galacticfog/gestalt-policy:release-1.2.0",
    "GESTALT_LASER_IMG": "galacticfog/gestalt-laser:release-1.2.0",
    "GESTALT_API_GATEWAY_IMG": "galacticfog/gestalt-api-gateway:release-1.2.0",
    "GESTALT_UI_IMG": "galacticfog/gestalt-ui-react:release-1.2.0",
    "LASER_EXECUTOR_JS_IMG": "galacticfog/gestalt-laser-executor-js:release-1.2.0",
    "LASER_EXECUTOR_JVM_IMG": "galacticfog/gestalt-laser-executor-jvm:release-1.2.0",
    "LASER_EXECUTOR_DOTNET_IMG": "galacticfog/gestalt-laser-executor-dotnet:release-1.2.0",
    "LASER_EXECUTOR_PYTHON_IMG": "galacticfog/gestalt-laser-executor-python:release-1.2.0",
    "LASER_EXECUTOR_RUBY_IMG": "galacticfog/gestalt-laser-executor-ruby:release-1.2.0",
    "LASER_EXECUTOR_GOLANG_IMG": "galacticfog/gestalt-laser-executor-golang:release-1.2.0"
  },
  "instances": 1,
  "cpus": 0.5,
  "mem": 512,
  "disk": 0,
  "gpus": 0,
  "backoffSeconds": 1,
  "backoffFactor": 1.15,
  "maxLaunchDelaySeconds": 3600,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "galacticfog/gestalt-dcos:1.2.0",
      "forcePullImage": true,
      "privileged": false,
      "network": "HOST"
    }
  },
  "healthChecks": [
    {
      "protocol": "HTTP",
      "path": "/_gfhealth",
      "gracePeriodSeconds": 60,
      "intervalSeconds": 30,
      "timeoutSeconds": 20,
      "ignoreHttp1xx": false
    }
  ],
  "upgradeStrategy": {
    "minimumHealthCapacity": 1,
    "maximumOverCapacity": 1
  },
  "labels": {
    "DCOS_PACKAGE_RELEASE": "2",
    "DCOS_SERVICE_SCHEME": "http",
    "DCOS_PACKAGE_SOURCE": "https://universe.galacticfog.com/repo",
    "DCOS_PACKAGE_METADATA": "eyJwYWNrYWdpbmdWZXJzaW9uIjoiMy4wIiwibmFtZSI6Imdlc3RhbHQtZnJhbWV3b3JrIiwidmVyc2lvbiI6IjEuMS4wIiwibWFpbnRhaW5lciI6InRlYW1AZ2FsYWN0aWNmb2cuY29tIiwiZGVzY3JpcHRpb24iOiJUaGUgR2VzdGFsdCBGcmFtZXdvcmsgaXMgYSBzb2x1dGlvbiBmb3IgYnVpbGRpbmcgZW50ZXJwcmlzZS1ncmFkZSBjbG91ZC1uYXRpdmUgYXBwbGljYXRpb25zIHVzaW5nIGNvbnRhaW5lcnMgYW5kIGxhbWJkYXMuIiwidGFncyI6WyJnZXN0YWx0LWZyYW1ld29yayIsIm9yY2hlc3RyYXRpb24iLCJsYW1iZGEiLCJwb2xpY3kiXSwic2VsZWN0ZWQiOmZhbHNlLCJzY20iOiJodHRwczovL2dpdGh1Yi5jb20vR2FsYWN0aWNGb2cvZ2VzdGFsdC1kY29zLmdpdCIsIndlYnNpdGUiOiJodHRwOi8vd3d3LmdhbGFjdGljZm9nLmNvbS9nZXQtc3RhcnRlZCIsImZyYW1ld29yayI6dHJ1ZSwicHJlSW5zdGFsbE5vdGVzIjoiUmVxdWlyZXMgREMvT1MgMS44LjUgb3IgbGF0ZXIuIFBsZWFzZSBzZWUgdGhlIEdldHRpbmcgc3RhcnRlZCBndWlkZSBhdCBodHRwOi8vd3d3LmdhbGFjdGljZm9nLmNvbS9nZXQtc3RhcnRlZCIsInBvc3RJbnN0YWxsTm90ZXMiOiJUaGUgR2VzdGFsdCBGcmFtZXdvcmsgaXMgbm93IHJ1bm5pbmcgb24geW91ciBzZXJ2ZXIuIiwicG9zdFVuaW5zdGFsbE5vdGVzIjoiVGhlIGdlc3RhbHQtZnJhbWV3b3JrIGxhdW5jaGVyIGhhcyBiZWVuIHVuaW5zdGFsbGVkLlxuSWYgdGhlIGZyYW1ld29yayBzZXJ2aWNlcyB3ZXJlIG5vdCBzaHV0ZG93biBmcm9tIHRoZSBsYXVuY2hlciwgdGhleSB3aWxsIG5lZWQgdG8gYmUgbWFudWFsbHkgcmVtb3ZlZCBmcm9tIE1hcmF0aG9uLiIsImxpY2Vuc2VzIjpbeyJuYW1lIjoiQXBhY2hlIExpY2Vuc2UgVmVyc2lvbiAyLjAiLCJ1cmwiOiJodHRwczovL2dpdGh1Yi5jb20vR2FsYWN0aWNGb2cvZ2VzdGFsdC1kY29zL2Jsb2IvZGV2ZWxvcC9MSUNFTlNFIn0seyJuYW1lIjoiQ29tbWVyY2lhbCIsInVybCI6Imh0dHA6Ly93d3cuZ2FsYWN0aWNmb2cuY29tL2NvbnRhY3QifSx7Im5hbWUiOiJFbmQgVXNlciBMaWNlbnNlIEFncmVlbWVudCIsInVybCI6Imh0dHA6Ly93d3cuZ2FsYWN0aWNmb2cuY29tL2dlc3RhbHQtZXVsYS5odG1sIn1dLCJpbWFnZXMiOnsiaWNvbi1zbWFsbCI6Imh0dHBzOi8vczMuYW1hem9uYXdzLmNvbS9nZmkubWlzYy9HZXN0YWx0LUljb24tU21hbGwucG5nIiwiaWNvbi1tZWRpdW0iOiJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vZ2ZpLm1pc2MvR2VzdGFsdC1JY29uLU1lZGl1bS5wbmciLCJpY29uLWxhcmdlIjoiaHR0cHM6Ly9zMy5hbWF6b25hd3MuY29tL2dmaS5taXNjL0dlc3RhbHQtSWNvbi1MYXJnZS5wbmcifX0=",
    "DCOS_PACKAGE_REGISTRY_VERSION": "3.0",
    "DCOS_SERVICE_NAME": "gestalt-poc",
    "DCOS_SERVICE_PORT_INDEX": "0",
    "DCOS_PACKAGE_VERSION": "1.2.0",
    "DCOS_PACKAGE_NAME": "gestalt-framework",
    "DCOS_PACKAGE_IS_FRAMEWORK": "true"
  },
  "ports": [0]
}
```

### 2) Run the Launcher as a DC/OS Service

 1. Go to DC/OS dashbaord, Services, Deploy Service
 -  Enter JSON mode, paste the JSON payload and run
