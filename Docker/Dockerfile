FROM ocaml/opam2:4.05

USER root

RUN apt-get update \
 && apt-get -y install build-essential git curl make m4 rlwrap screen

USER opam

RUN opam update \
 && eval `opam config env` \
 && opam install num camlp5

RUN mkdir -p /home/opam/work

### ---------------------------------------------------------------------------
### Install Dmtcp, Version 2019-09-21.
### Version 2019-04-22 is also know to work:
### ARG DMTCP_VERSION=cfe168e2539b60e29bbac27da9a8b78b77add2a6
### ---------------------------------------------------------------------------

ARG DMTCP_VERSION=8c20abe3d8b90c22a5145c4364fac4094d10d9cf

RUN mkdir -p /home/opam/src/dmtcp \
 && cd /home/opam/src/dmtcp \
 && curl -sL https://github.com/dmtcp/dmtcp/archive/$DMTCP_VERSION.tar.gz | \
    tar xz --strip-components=1 \
 && ./configure --prefix=/usr/local && make -j 2 \
 && sudo make install

### ---------------------------------------------------------------------------
### Install HOL Light
### ---------------------------------------------------------------------------

RUN mkdir -p /home/opam/hol-light

WORKDIR /home/opam/hol-light

# Version 2019-12-02
ARG HOL_LIGHT_VERSION=93d07b78c7bac9339e9f976d26fdde6e64d64e15

RUN curl -sL https://github.com/jrh13/hol-light/archive/$HOL_LIGHT_VERSION.tar.gz | tar xz --strip-components=1

RUN eval `opam config env` && make

CMD ["/bin/sh", "-c", "eval `opam config env` && ocaml -I `camlp5 -where`"]
