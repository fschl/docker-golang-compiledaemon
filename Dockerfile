FROM golang:1.6

MAINTAINER Frieder Schlesier <fschl.code@gmail.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        git-core \
        ssh \
        golang-go.tools \
        && rm -rf /var/lib/apt/lists/*

# install the CompileDaemon
RUN go get -v github.com/fschl/CompileDaemon
RUN cd $GOPATH/src/github.com/fschl/CompileDaemon \
    && go install

# setup for private gitlab repositories
ENV GIT_IP 10.10.10.1
ENV GIT_PORT 10022
# path for your go-projects
ENV SITE github.com
ENV USER fschl
ENV REPO glide

ENV PROJECT_PATH $GOPATH/src/$SITE/$USER/$REPO

# private key for access to gitlab
#ADD ./deploy_private /root/.ssh/id_rsa
#RUN chmod 700 /root/.ssh/id_rsa

# uncomment those, if you use self-signed certs
#RUN echo "Host gitlab.opendriverslog.de\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
#RUN echo "Host "${GIT_IP}"\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
#RUN git config --global url.ssh://git@${GIT_IP}:${GIT_PORT}/.insteadOf http://gitlab.opendriverslog.de/

# add init script
RUN mkdir -p /opt/setup/
ADD init /opt/setup/init
RUN chmod +x /opt/setup/init

# add current directory as project
ADD . $PROJECT_PATH

# clone private dependencies
#RUN git clone -b develop ssh://git@${GIT_IP}:${GIT_PORT}/$USER/<repo-of-dependency>.git $PROJECT_PATH/../<repo-of-dependency>

WORKDIR $PROJECT_PATH

# go get public dependencies
#RUN go get -v github.com/WHO/WHAT

EXPOSE 4000

CMD ["/opt/setup/init"]
