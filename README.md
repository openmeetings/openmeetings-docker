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

* complete clean-up
```bash
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
```

* to build: 
```
docker build -t om-server .
docker login -u openmeetings -p <HASHED_PWD> openmeetings-docker-images.bintray.io
docker tag om-server openmeetings-docker-images.bintray.io/server
docker push openmeetings-docker-images.bintray.io/server
```
* to run pre-build OM:
```
docker run -i --rm --name om-server -p 5080:5080 -p 1935:1935 openmeetings-docker-images.bintray.io/server:4.0.0
```
* to run OM (locally built):
```
docker run -it __HASH__
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

