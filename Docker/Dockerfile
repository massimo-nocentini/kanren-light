FROM ocaml/opam2

USER root

RUN apt-get -y install build-essential git curl make m4 rlwrap

USER opam

RUN opam update \
 && opam switch create hol-4.07.1 ocaml-base-compiler.4.07.1 \
 && eval `opam config env` \
 && opam install num camlp5

RUN mkdir -p /home/opam/work

WORKDIR /home/opam/work