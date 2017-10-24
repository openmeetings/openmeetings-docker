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
* to run pre-build OM:
```docker
docker run -i --rm --name om-server -p 5080:5080 -p 1935:1935 openmeetings-docker-registry.bintray.io/server:latest
```
* to run OM (locally built):
```docker
docker run -it __HASH__
```
* to enter machine:
```docker
docker run -it __HASH__ bash
```

* to stop:
```docker
docker stop $(docker ps -aq)
```

