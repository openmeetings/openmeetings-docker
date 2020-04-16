# openmeetings-docker

Docker image for OM (version 5.0.0-M3, WebRTC *SEMI-STABLE*)

Please use _releases_

### CREDENTIALS:

|Description|Value|
|-----------|-----|
|Db type| MySql|
|Db root password|`12345`|
|OM DB user|`om_admin`|
|OM DB user password|`12345`|
|OM admin user|`om_admin`|
|OM admin user password|`1Q2w3e4r5t^y`|

### USEFUL PARAMETERS:

|Env Variable|Description|
|-----------|-----|
|`TURN_URL`| Turn server URL |
|`TURN_USER`| Turn server user |
|`TURN_PASS`| Turn server user password |

## RUN INSTRUCTIONS

### to run (full) OM:
```
docker run -i --rm --expose=5443 --expose=8888 -p 5443:5443 -p 8888:8888 apache/openmeetings:5.0.0-M3.1
```

### to run mini OM with KMS (Docker) on same HOST machine:
#### 1. Run KMS (Docker)
```
docker run --name kms -d --network=host \
  --mount type=bind,source=/opt/omdata,target=/opt/openmeetings/webapps/openmeetings/data \
  kurento/kurento-media-server
```
#### 2. Run OM5-Mini
```
docker run --name om5-mini -d --network=host\
  -e OM_USER={admin_username} \
  -e OM_PASS={admin_pass} \
  -e OM_KURENTO_WS_URL="ws://localhost:8888/kurento" \
  -e OM_DB_HOST={DB_HOST} \
  -e OM_DB_PORT={DB_PORT} \
  -e OM_DB_USER={DB_OWNER} \
  -e OM_DB_NAME={DB_NAME} \
  -e OM_DB_TYPE={DB_TYPE} \
  -e OM_DB_PASS={DB_PASS} \
  --mount type=bind,source=/opt/omdata,target=/opt/openmeetings/webapps/openmeetings/data \
  apache/openmeetings:min-5.0.0-M3
```
> Please Specify `TURN*` parameters in case users from other networks are expected


### To access OM

`https://localhost:5443/openmeetings`



## INSTRUCTIONS FOR DEVELOPERS:

### complete clean-up
```bash
docker rm $(docker ps -a -q) ; docker rmi -f $(docker images -q)
```

### Authentication

please contact INFRA in case you don't have permissions to push to
https://hub.docker.com/repository/docker/apache/openmeetings/general

```
docker login --username solomax666
```
AUTH token as password


### to build minimized: 
This version has no DB and Kurento server, both should be passed via environment
See below
```
docker build -t apache/openmeetings:min-5.0.0-M3 .
docker push apache/openmeetings:min-5.0.0-M3
```

### to build full: 
```
docker build -t apache/openmeetings:5.0.0-M3 --build-arg BUILD_TYPE=full .
docker push apache/openmeetings:5.0.0-M3
```

### to run (full) OM (locally built):
```
docker run --expose=8888 -p 5443:5443 -p 8888:8888 -e OM_TYPE=full -it om-server-full

```

* to enter machine:
```
docker run -it om-server-full bash
```

* to join running machine
```
# get container id
docker ps
# join
docker exec -it [container-id] bash
```

* to stop:
```
docker stop $(docker ps -aq)
```
