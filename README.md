
# Docker container for SignificanceNoncoding by Dietlein et al.

This repository contains a UNIX build script for the [noncoding driver mutation discovery method by Dietlein et al.](https://doi.org/10.1126/science.abg5601) [(source code)](https://zenodo.org/record/5913867) and a `Dockerfile` for wrapping it into a [Docker](https://www.docker.com/) container. The purpose is to deploy it in a cluster with [Singularity](https://sylabs.io/) container system, which can access the Docker Hub containers.

## Pulling a prebuilt container

Pull using Docker:
```
	docker pull anthakki/significancenoncoding
```

Pull using Singularity:
```
	singularity pull significancenoncoding.sif docker://anthakki/significancenoncoding
```

## Building the container

Building the container requires [Docker](https://docs.docker.com/engine/install/), which requires privileged access, but it is possible to run this in a virtual machine (see the link).

Building the tool requires [Java 8 SDK](https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html) (newer versions should also be ok), and using the `Makefile` requires [GNU make](https://www.gnu.org/software/make/), `patch`, and [cURL](https://curl.se/). For Ubuntu Linux, you can install them:
```
	apt-get -y install curl openjdk-8-sdk-headless make patch
```

To build the container, first run `make` to build the tool and then Docker to build your container:
```
	make
	docker build -t anthakki/significancenoncoding .
```

If you prefer not to install the build tools in your system, you can install them in a Docker container using the `Dockerfile` in `build-env/` and run the `make there instead:
```
	docker build -t anthakki/significancenoncoding-build-env build-env
	docker run -v "$PWD:$PWD" -w "$PWD" -u "$( id -u ):$( id -g )" anthakki/significancenoncoding-build-env make 
```

The Docker image can be imported into Singularity using:
```
	./docker2sif -o significancenoncoding.sif anthakki/significancenoncoding
```

## Running the container

To run analysis, run:
```
	docker run -v "$PWD:$PWD" -w "$PWD" -u "$( id -u ):$( id -g )" anthakki/significancenoncoding <entity> <path_file> <output_folder>
```

Or on Singularity:
```
	singularity run significancenoncoding.sif <entity> <path_file> <output_folder>
```

Note that the annotation files required to run the method are downloaded during build time and bundled with the container, so there is no need to pass the `annotation_folder` option unless these have been modified. Similarly, the user need not to be concerned with the Java classpath options. Additional Java runtime options (such as `-Xmx55G` recommended for the example data set), and the option `-k` to keep the intermediate files can be added in the arguments.

Consult the [user manual](https://zenodo.org/record/5913867/files/UserManual.pdf?download=1) for the usage of the tool.
