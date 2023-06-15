
FROM ubuntu:22.04

WORKDIR /

ARG DEBIAN_FRONTEND='noninteractive'

RUN apt-get -y update && \
	apt-get -y install 'openjdk-8-jre-headless' && \
	rm -fr /var/lib/apt/lists/*

# NB. filtering in Dockerfile.. otherwise we have multiple copies..
 # TODO: working chmod would be nice.. --chmod=go-w does nothing (only octal works)
COPY share/ /SignificanceNoncoding/share/
COPY bin/ /SignificanceNoncoding/bin/
COPY lib/ /SignificanceNoncoding/lib/

ENTRYPOINT ["/SignificanceNoncoding/bin/SignificanceNoncoding", \
	"-jar_path", "/SignificanceNoncoding/lib/SignificanceNoncoding/SignificanceNoncoding.jar", \
	"-default_annotation_folder", "/SignificanceNoncoding/share/SignificanceNoncoding/AnnotationFilesComplete/"]
CMD []
