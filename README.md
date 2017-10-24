# openmeetings-docker
Docker image for OM

## TIPS:

* to build: 
```docker
docker build -t om-server .
docker login -u openmeetings -p <HASHED_PWD> openmeetings-docker-registry.bintray.io
docker tag om-server openmeetings-docker-registry.bintray.io/server
docker push openmeetings-docker-registry.bintray.io/server
```
* to run OM:
```docker
docker run -it __HASH__
```
* to enter machine:
```docker
docker run -it __HASH__ bash
```
