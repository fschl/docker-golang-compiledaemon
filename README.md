# Golang Development Container

- automatic recompile
- Support for private golang repositories
- runs a local GoDoc server

## Usage

1. Build the image.

```bash
docker build --tag=fschl/goodl-dev .
```

2. Run it:

```bash
docker run -it \
-v "$(shell pwd)":/go/src/gitlab.opendriverslog.de/odl/goodl \
-v "$(shell pwd)/../goodl-lib":/go/src/gitlab.opendriverslog.de/odl/goodl-lib \
-p 4000:4000 \
-p 6060:6060 \
fschl/goodl-dev
```

## TODO

- add automatic running of tests
- maybe make dependency management more comfortable
