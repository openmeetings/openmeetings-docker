# openmeetings-docker

Docker image for OM (version 6.2.0, WebRTC)


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
docker run -i --rm --network host apache/openmeetings:6.2.0
```

### to run (mini) OM:
```
docker run -p 5443:5443 \
  -e OM_KURENTO_WS_URL="ws://EXT_IP:8888/kurento" \
  -e OM_DB_HOST=EXT_IP \
  -e OM_DB_USER=db_user \
  -e OM_DB_PASS=secret_pass \
  --mount type=bind,source=/opt/omdata,target=/opt/omdata \
  -it apache/openmeetings:min-6.2.0

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
docker build -t apache/openmeetings:min-6.2.0 .
docker push apache/openmeetings:min-6.2.0
```

### to build full: 
```
docker build -t apache/openmeetings:6.2.0 --build-arg BUILD_TYPE=full .
docker push apache/openmeetings:6.2.0
```

### to run (full) OM (locally built):
```
docker run --network host -e OM_TYPE=full -it [container-id]

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

