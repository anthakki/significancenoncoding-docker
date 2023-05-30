
FROM ubuntu:22.04

WORKDIR /

ARG DEBIAN_FRONTEND='noninteractive'

RUN apt-get -y update && \
	apt-get -y install 'curl' 'make' 'openjdk-8-jdk-headless' 'patch' && \
	rm -fr /var/lib/apt/lists/*
