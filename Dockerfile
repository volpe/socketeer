# DOCKER-VERSION 0.6.4

FROM ubuntu:latest

RUN        echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN        apt-get -y update
RUN        apt-get -y install wget redis
RUN wget -O - http://nodejs.org/dist/v0.10.22/node-v0.10.22-linux-x64.tar.gz | tar -C /usr/local/ --strip-components=1 -zxv
RUN apt-get -y install coffeescript
ADD . /src
RUN cd /src; npm install

EXPOSE 9875
EXPOSE 9874

CMD ["coffee", "/src/server.coffee"]