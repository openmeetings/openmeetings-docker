# openmeetings-docker

Docker image for OM (version 5.0.0-M2, WebRTC *SEMI-STABLE*)

Please use _releases_

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

### to build minimized: 
This version has no DB and Kurento server, both should be passed via environment
See below
```
docker build -t om-server-min .
docker login -u openmeetings -p <HASHED_PWD> openmeetings-docker-images.bintray.io
docker tag om-server-min openmeetings-docker-images.bintray.io/server-min
docker push openmeetings-docker-images.bintray.io/server-min
```
### to build full: 
```
docker build -t om-server-full --build-arg BUILD_TYPE=full .
docker login -u openmeetings -p <HASHED_PWD> openmeetings-docker-images.bintray.io
docker tag om-server-full openmeetings-docker-images.bintray.io/server-full
docker push openmeetings-docker-images.bintray.io/server-full
```
### to run pre-build (full) OM:
```
docker run -i --rm --name om-server-full --expose=5443 --expose=8888 -p 5443:5443 -p 8888:8888 openmeetings-docker-images.bintray.io/server-full:latest
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
