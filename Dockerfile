FROM golang:1.4

MAINTAINER Frieder Schlesier <frieder@opendriverslog.de>

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        git-core \ 
        ssh \
        golang-go.tools \
        && rm -rf /var/lib/apt/lists/*

# setup for private gitlab repositories
ENV GIT_IP 10.10.10.1
ENV GIT_PORT 10022
ENV GODOC_PORT 6060

ADD ./deploy_private /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN echo "Host gitlab.opendriverslog.de\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
RUN echo "Host "${GIT_IP}"\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
RUN git config --global url.ssh://git@${GIT_IP}:${GIT_PORT}/.insteadOf http://gitlab.opendriverslog.de/

# install the CompileDaemon
RUN go get -v github.com/fschl/CompileDaemon
RUN cd $GOPATH/src/github.com/fschl/CompileDaemon \
    && go install

# add init script
RUN mkdir -p /opt/setup/
ADD init /opt/setup/init
RUN chmod 700 /opt/setup/init

# add current directory as project
ADD . $GOPATH/src/gitlab.opendriverslog.de/odl/goodl

# clone private dependencies
RUN git clone -b develop ssh://git@${GIT_IP}:${GIT_PORT}/odl/goodl-lib.git $GOPATH/src/gitlab.opendriverslog.de/odl/goodl-lib

WORKDIR $GOPATH/src/gitlab.opendriverslog.de/odl/goodl

# go get public dependencies
RUN go get -v gitlab.opendriverslog.de/odl/goodl

EXPOSE 4000

CMD ["/opt/setup/init"]

