# openmeetings-docker
Docker image for OM

## CREDENTIALS:

|Description|Value|
|-----------|-----|
|Db type| MySql|
|Db root password|`12345`|
|OM DB user|`om_admin`|
|OM DB user password|`12345`|
|OM admin user|`om_admin`|
|OM admin user password|`1Q2w3e4r5t^y`|


## TIPS:

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
This version has no DB, it should be passed via environment
See below
```
docker build -t apache/openmeetings:min-4.0.11 .
docker push apache/openmeetings:min-4.0.11
```

### to build full: 
```
docker build -t apache/openmeetings:4.0.11 --build-arg BUILD_TYPE=full .
docker push apache/openmeetings:4.0.11
```

### to run pre-build (full) OM:
```
docker run -i --rm --name om-server-full --expose=5443,8888 -p 5443:5443 -p 8888:8888 apache/openmeetings:4.0.11
```

### to run (full) OM (locally built):
```
docker run --expose=8888 -p 5443:5443 -p 8888:8888 -e OM_TYPE=full -it om-server-full


https://localhost:5443/openmeetings
```
> (https is preferred to use OM)


### to run (mini) OM (locally built):
```
docker run -p 5443:5443 \
  -e OM_KURENTO_WS_URL="ws://EXT_IP:8888/kurento" \
  -e OM_DB_HOST=EXT_IP \
  -e OM_DB_USER=db_user \
  -e OM_DB_PASS=secret_pass \
  --mount type=bind,source=/opt/omdata,target=/opt/omdata \
  -it om-server-min:latest

https://localhost:5443/openmeetings
```

* to enter machine:
```
docker run -it __HASH__ bash
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
