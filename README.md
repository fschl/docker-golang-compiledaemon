# Golang Development Container

- automatic recompile
- Support for non-public golang repositories
- _optionally_ runs a local GoDoc server

## Usage

1. Modify Dockerfile & init-script

```bash
SITE=<ip/hostname of your CVS> # e.g. github.com
USER=<user/organization> # e.g. fschl
REPO=<repo of your project> # e.g. docker-golang-compiledaemon
```

2. Build the image.

```bash
docker build --tag=fschl/goodl-dev .
```

3. Run your dev-container:

```bash
docker run -it \
-v "$(shell pwd)":/go/src/$SITE/$USER/$REPO \
-v "$(shell pwd)/../<non-public dependency>":/go/src/$SITE/$USER/$DEPENDENCY_REPO \
-p 4000:4000 \
-p 6060:6060 \
fschl/goodl-dev
```

## TODO

- add automatic running of tests
- maybe make dependency management more comfortable
