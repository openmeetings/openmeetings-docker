# openmeetings-docker
Docker image for OM

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
docker run -i --rm --name om-server -p 5080:5080 -p 1935:1935 openmeetings-docker-images.bintray.io/server:latest
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
