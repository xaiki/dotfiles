FROM alpine

MAINTAINER Niv Sardi "x@btn.sh"

RUN apk update && apk add ca-certificates graphviz emacs
RUN mkdir -p /datay
WORKDIR /data
ENV LANG C.UTF-8
ENTRYPOINT ["emacs"]

