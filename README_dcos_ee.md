# Gestalt Platform Offline Installation for DC/OS Enterprise

The following detail the offline installation process for DC/OS Enterprise version 1.8.x.

## Prerequisites
* A private Docker registry (see https://docs.docker.com/registry/deploying/)
* A node running Docker with access to Docker Hub for downloading Gestalt images
* A node running Docker with access to private Docker registry to push Gestalt images
* A DC/OS service account for running the launcher (instructions below)

## Download and Package Galactic Fog Images from Docker Hub

The following instructions are for Gestalt Platform version `1.2.1`, which contains both `1.2.0` and `1.2.1` images:

```sh
# 1.2.1 images
galacticfog/gestalt-dcos:1.2.1
galacticfog/gestalt-api-gateway:release-1.2.1
galacticfog/kong:release-1.2.1
galacticfog/gestalt-laser:release-1.2.1
galacticfog/gestalt-meta:release-1.2.1
galacticfog/gestalt-ui-react:release-1.2.1

# 1.2.0 images
galacticfog/gestalt-laser-executor-dotnet:release-1.2.0
galacticfog/gestalt-laser-executor-golang:release-1.2.0
galacticfog/gestalt-laser-executor-js:release-1.2.0
galacticfog/gestalt-laser-executor-jvm:release-1.2.0
galacticfog/gestalt-laser-executor-python:release-1.2.0
galacticfog/gestalt-laser-executor-ruby:release-1.2.0
galacticfog/gestalt-policy:release-1.2.0
galacticfog/gestalt-security:release-1.2.0
galacticfog/postgres_repl:release-1.2.0
galacticfog/rabbit:release-1.2.0
galacticfog/universe-server:gestalt-1.2.0
```

Run the following from a node running Docker with access to Docker Hub:

### 1) Pull Images from Docker Hub

Download images with `docker pull`:

```sh

# Pull updated version 1.2.1 images
for i in \
  galacticfog/gestalt-dcos:1.2.1 \
  galacticfog/gestalt-api-gateway:release-1.2.1 \
  galacticfog/kong:release-1.2.1 \
  galacticfog/gestalt-laser:release-1.2.1 \
  galacticfog/gestalt-meta:release-1.2.1 \
  galacticfog/gestalt-ui-react:release-1.2.1 \
 ; do
  docker pull $i
done


# Pull version 1.2.0 images
for i in \
  galacticfog/gestalt-laser-executor-dotnet:release-1.2.0 \
  galacticfog/gestalt-laser-executor-golang:release-1.2.0 \
  galacticfog/gestalt-laser-executor-js:release-1.2.0 \
  galacticfog/gestalt-laser-executor-jvm:release-1.2.0 \
  galacticfog/gestalt-laser-executor-python:release-1.2.0 \
  galacticfog/gestalt-laser-executor-ruby:release-1.2.0 \
  galacticfog/gestalt-policy:release-1.2.0 \
  galacticfog/gestalt-security:release-1.2.0 \
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

# 1.2.1 images
docker save \
  galacticfog/gestalt-dcos:1.2.1 \
  galacticfog/gestalt-api-gateway:release-1.2.1 \
  galacticfog/kong:release-1.2.1 \
  galacticfog/gestalt-laser:release-1.2.1 \
  galacticfog/gestalt-meta:release-1.2.1 \
  galacticfog/gestalt-ui-react:release-1.2.1 \
 > gestalt-dcos-images-1.2.1.tar

# 1.2.0 images
docker save \
  galacticfog/gestalt-laser-executor-dotnet:release-1.2.0 \
  galacticfog/gestalt-laser-executor-golang:release-1.2.0 \
  galacticfog/gestalt-laser-executor-js:release-1.2.0 \
  galacticfog/gestalt-laser-executor-jvm:release-1.2.0 \
  galacticfog/gestalt-laser-executor-python:release-1.2.0 \
  galacticfog/gestalt-laser-executor-ruby:release-1.2.0 \
  galacticfog/gestalt-policy:release-1.2.0 \
  galacticfog/gestalt-security:release-1.2.0 \
  galacticfog/postgres_repl:release-1.2.0 \
  galacticfog/rabbit:release-1.2.0 \
  galacticfog/universe-server:gestalt-1.2.0 \
  > gestalt-dcos-images-1.2.0.tar


# Optionally compress the tar file prior to transfer
# gzip gestalt-dcos-images-1.2.0.tar
# gzip gestalt-dcos-images-1.2.1.tar

```
The resulting TAR files together are about 4-5 GB uncompressed.

## Load Galactic Fog Images into Private Docker Registry

Run the following from a node with access to the Private Docker registry.

### 1) Load Gestalt Images from TAR File

Transfer `gestalt-dcos-images-1.2.0.tar` and `gestalt-dcos-images-1.2.1.tar` to the private Docker registry node, then load the images into the registry using `docker load`:

```sh

# First transfer 'gestalt-dcos-images-1.2.0.tar' and 'gestalt-dcos-images-1.2.1.tar'

docker load -i gestalt-dcos-images-1.2.1.tar

docker load -i gestalt-dcos-images-1.2.0.tar
```

### 2) Re-Tag and push Gestalt Images for Private Registry

```sh
for i in \
  galacticfog/gestalt-dcos:1.2.1 \
  galacticfog/gestalt-api-gateway:release-1.2.1 \
  galacticfog/kong:release-1.2.1 \
  galacticfog/gestalt-laser:release-1.2.1 \
  galacticfog/gestalt-meta:release-1.2.1 \
  galacticfog/gestalt-ui-react:release-1.2.1 \
  galacticfog/gestalt-laser-executor-dotnet:release-1.2.0 \
  galacticfog/gestalt-laser-executor-golang:release-1.2.0 \
  galacticfog/gestalt-laser-executor-js:release-1.2.0 \
  galacticfog/gestalt-laser-executor-jvm:release-1.2.0 \
  galacticfog/gestalt-laser-executor-python:release-1.2.0 \
  galacticfog/gestalt-laser-executor-ruby:release-1.2.0 \
  galacticfog/gestalt-policy:release-1.2.0 \
  galacticfog/gestalt-security:release-1.2.0 \
  galacticfog/postgres_repl:release-1.2.0 \
  galacticfog/rabbit:release-1.2.0 \
  galacticfog/universe-server:gestalt-1.2.0 \
 ; do
   docker tag $i my.private.repo/$i
   docker push my.private.repo/$i
 done
```


## Configure DC/OS Service Account

### Service Account Creation
Create a service account for the installation.  Note the Service account requires specifying the public key of a key pair.  

If required, generate or use a key pair based on your organizations standards.  You may find these example commands helpful:
```sh
# Examples:

# Generate the public key from an existing private key if necessary
ssh-keygen -y -f service_account_privatekey > service_account_pubkey

# Convert public key to PEM format
ssh-keygen -f service_account_pubkey -e -m pem > service_account_pubkey.pem
```

### Service Account Permissions
The service account needs access to a Marathon instance to read events from the event bus and create applications in the application group.

Permissions (example for top-level Marathon):
 - `dcos:service:marathon:marathon:admin:events`	- read
 - `dcos:service:marathon:marathon:services:/path/to/gestalt-app-group` - create, delete, read, update


## Run Gestalt Platform Launcher from DC/OS Dashboard

### 1) Construct a JSON Payload for the Gestalt DC/OS Launcher

Using the below example, modify the JSON file for the DC/OS environment.

#### Images:
- Modify the `GESTALT_*_IMG` parmeters in the `env` field to reference the location of the images in your private registry.

#### `cmd` field:
 - Modify `-Ddatabase.username` parameter with a username of your choice.
 - Modify `-Ddatabase.password` parameter with a password of your choice.
 - Modify `-Dmeta.company-name` parameter with the company or team name.

#### `env` field:

Authentication settings:
 - `DCOS_AUTH_UID` - set to the name of the DC/OS service account.
 - `DCOS_AUTH_PRIVATE_KEY` - Set to the private key of the service account (replace any new lines with "\n", see example)

**Note:** You can insert "\n" strings into your private key with this command:
```sh
# Append "\n" to end of every line, then remove new line characters.  The result is suitable to copy and paste into the JSON payload.
key_with_returns=$( while IFS='' read -r line; do echo "$line\\n"; done < privatekey | tr -d '\n' )

echo "\"DCOS_AUTH_PRIVATE_KEY\" : \"$key_with_returns\","
```


 - `DCOS_PERMISSIVE_HTTPS` - set to `true` to relax certificate checks if needed.

Gestalt Security settings:
 - `SECURITY_USERNAME` / `SECURITY_PASSWORD` - Gestalt admin user credentials

Marathon Settings:
 - `MARATHON_FRAMEWORK_NAME` - Set to the name of the Marathon framework.
 - `MARATHON_APP_GROUP` - Set to desired Marathon application group path.
 - `MARATHON_TLD` - Set corresponding to DNS settings (e.g. `gestalt-poc.internal.mycompany.com`).
 - `MARATHON_URL` - Set to the URL of the Marathon instance Gestalt will run under.

#### `labels` field:
 - `DCOS_SERVICE_NAME` - Set as desired.

### JSON Example:
```json
{
  "id": "/dev/gcp-api/dcos-launcher",
  "cmd": "./bin/gestalt-dcos -Dhttp.port=9000 -Dmeta.company-name=\"COMPANY NAME\" -Dlaser.max-port-range=60500 -Dlaser.min-port-range=60000 -Ddatabase.num-secondaries=0  -Ddatabase.prefix=gestalt-  -Ddatabase.username=gestaltdev  -Ddatabase.password=\"<database password>\"  -Ddatabase.provision=true  -Ddatabase.provisioned-size=100",
  "env": {
    "JVM_OPTS": "-Xmx384m",
    "GESTALT_FRAMEWORK_VERSION": "1.2.0",
    "GESTALT_API_GATEWAY_IMG": "your.private.registry/galacticfog/gestalt-api-gateway:release-1.2.1",
    "GESTALT_DATA_IMG": "your.private.registry/galacticfog/postgres_repl:release-1.2.0",
    "GESTALT_KONG_IMG": "your.private.registry/galacticfog/kong:release-1.2.1",
    "GESTALT_LASER_IMG": "your.private.registry/galacticfog/gestalt-laser:release-1.2.1",
    "GESTALT_META_IMG": "your.private.registry/galacticfog/gestalt-meta:release-1.2.1",
    "GESTALT_POLICY_IMG": "your.private.registry/galacticfog/gestalt-policy:release-1.2.0",
    "GESTALT_RABBIT_IMG": "your.private.registry/galacticfog/rabbit:release-1.2.0",
    "GESTALT_SECURITY_IMG": "your.private.registry/galacticfog/gestalt-security:release-1.2.0",
    "GESTALT_UI_IMG": "your.private.registry/galacticfog/gestalt-ui-react:release-1.2.1",
    "LASER_EXECUTOR_DOTNET_IMG": "your.private.registry/galacticfog/gestalt-laser-executor-dotnet:release-1.2.0",
    "LASER_EXECUTOR_GOLANG_IMG": "your.private.registry/galacticfog/gestalt-laser-executor-golang:release-1.2.0",
    "LASER_EXECUTOR_JS_IMG": "your.private.registry/galacticfog/gestalt-laser-executor-js:release-1.2.0",
    "LASER_EXECUTOR_JVM_IMG": "your.private.registry/galacticfog/gestalt-laser-executor-jvm:release-1.2.0",
    "LASER_EXECUTOR_PYTHON_IMG": "your.private.registry/galacticfog/gestalt-laser-executor-python:release-1.2.0",
    "LASER_EXECUTOR_RUBY_IMG": "your.private.registry/galacticfog/gestalt-laser-executor-ruby:release-1.2.0",

    "DCOS_PERMISSIVE_HTTPS": "true",
    "DCOS_AUTH_METHOD": "acs",
    "DCOS_AUTH_BASEURL": "https://master.mesos",
    "DCOS_AUTH_UID": "<Enter service account>",
    "DCOS_AUTH_PRIVATE_KEY": "<This is an example private key, replace contents with the private key of the service account (note the \n charaters)>-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC9OzC0iseKnsqd\nu82KvTav6q+j4MoSS3mGGPZIA2JaD/cMjpzBtaaOxIbcyLWt2M8hwdO3TLXCZiW2\nybz2Koeo3+vNphnO7U4ZggSIuM+RYfhUUnQ79yiYKmL3z93HRrvZBlulG3yOFo5y\n30IFKqyt2QKlPy3ObCtZYwT4opYNnkev/pubtOjsjdkU9/u088eiLfVHwSwpBxjG\n2wbpFVGyN3p55UHW3K6QUrUw8B7EOF2A5EXzgR5GmAgL6SjuzEdghumqdMcSxGoE\n4pL3Y6LHer391ITdxO819o0i3cfglvgXxFGZSsiRVV89X15n8pEbP73cD3sRxnwe\nIwW860ZnAgMBAAECggEAIKUXb+4JIobmWXPOr8KYrpyEFHdxJNrUaifgROggjXz3\nl7j6nghiZXrN8UTG4ujmQuKXTaX0LUdF9lSzPpxzrtSCb4XaKfKSaKAffB614FTQ\nbGuVFcs7u5SEYk//6KLxQS1xnfgx8qk9hd+yGgYUqCEp7awKkPPkPpVwhBw4WrzJ\nkYxJ3bIT7j3svTr5uhno7cFso5jhfFyMA7PruHGNfyOWLIgzgw5qwRUK1WLMyk88\nJivrDRbvuskWK7pxvLrRQ/VA34LvGKLroj9Gqw9HIDGbY526PPjFo/uDq8ErHBsQ\nBdoagN6VihX5YjXdi3eF8mIcaFYBOQj6zB+Kfmkc0QKBgQDjkIemfgpHEMcRsinm\ni0WLlZGD8hjFTNku1Pki5sFffXcHR+FImrEUXL/NqJr8iqIeJ+1cx3OAiBm8PHh4\nl+LYz4H2TlvIEEURmOwLiBbh49N4o7T9the+PluDGLsZ9ka3AGHP1LBcvwYJdf7v\nubK3eky1QQSI5Ce6+uayU76QFQKBgQDU4G4j2eAIVTDQ0xMfJYXFaIh2eVqTkv83\nPeskWhAQcPUKzyX7bPHSdSbx+91ZW5iL8GX4DFp+JBiQFSqNq1tqhLwz9xHTxYrj\nGvi6MUJ4LCOihbU+6JIYuOdxq3govxtnJ+lE4cmwr5Y4HM1wx2dxba9EsItLrzkj\nHGPNDJ6fiwKBgCXgPHO9rsA9TqTnXon8zEp7TokDlpPgQpXE5OKmPbFDFLilgh2v\ngaG9/j6gvYsjF/Ck/KDgoZzXClGGTxbjUOJ9R0hTqnsWGijfpwoUUJqwbNY7iThh\nQnprrpeXWizsDMEQ0zbgU6pcMQkKFrCX2+Ml+/Z/J94Q+3vnntY3khQxAoGAdUkh\n5cbI1E57ktJ4mpSF23n4la3O5bf7vWf0AhdM+oIBwG7ZMmmX4qiBSJnIHs+EgLV2\nuO+1fAJPNjMzOtLKjymKt+bMf607FF1r5Mn3IVbQW17nuT1SISTe/5XFok2Iv5ER\nyM3N3fcgANJ9rkFvEOOpyWKrnItyI5IkunjVfHkCgYEAjmAjQOQt5eCO9kGitL7X\ntQGn8TWWHRCjMm1w3ith7bPp11WrdeyfNuUAB7weQjk2qjAIKTOGWtIRqc36OLPA\nkwF1GDyFXvLqJej/2ZLfytyjhetLAQnRL0qOgCi7EU5+YLXuYnn7zPEJgrR3ogX4\n4rvG4NIQ8wG0sEUTnr06nck=\n-----END PRIVATE KEY-----",

    "LASER_SCALE_DOWN_TIMEOUT" : "60",
    "LASER_MIN_COOL_EXECUTORS" : "1",

    "LASER_ENABLE_JS_RUNTIME" : "true",
    "LASER_ENABLE_JVM_RUNTIME" : "true",
    "LASER_ENABLE_DOTNET_RUNTIME" : "true",
    "LASER_ENABLE_RUBY_RUNTIME" : "true",
    "LASER_ENABLE_PYTHON_RUNTIME" : "true",
    "LASER_ENABLE_GOLANG_RUNTIME" : "true",

    "MARATHON_FRAMEWORK_NAME":"marathon",
    "MARATHON_APP_GROUP" : "/path/to/gestalt/app-group",
    "MARATHON_TLD" : "<Enter your Marathon TLD, e.g. gestalt.internal.mycompany.com>",
    "MARATHON_URL" : "https://marathon.mesos:8443",

    "SECURITY_USERNAME":"gestalt-admin",
    "SECURITY_PASSWORD":"<Password for Gestalt Platform admin user>"
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
      "image": "your.private.registry/galacticfog/gestalt-dcos:1.2.1",
      "forcePullImage": true,
      "privileged": false,
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 9000,
          "protocol": "tcp"
        }
      ]
    }
  },
  "healthChecks": [
    {
      "protocol": "HTTP",
      "path": "/_gfhealth",
      "port": 9000,
      "gracePeriodSeconds": 60,
      "intervalSeconds": 30,
      "timeoutSeconds": 20,
      "ignoreHttp1xx": false
    }
  ],
  "gcpFlags": {
    "ENABLE_HTTP_ENDPOINT": "true"
  },
  "upgradeStrategy": {
    "minimumHealthCapacity": 1,
    "maximumOverCapacity": 1
  },
  "labels": {
    "DCOS_SERVICE_SCHEME": "http",
    "DCOS_SERVICE_NAME": "gestalt-poc",
    "DCOS_SERVICE_PORT_INDEX": "0"
  }
}
```

### 2) Run the Launcher as a DC/OS Service

 1. Go to DC/OS dashbaord, Services, Deploy Service
 -  Enter JSON mode, paste the JSON payload and run
