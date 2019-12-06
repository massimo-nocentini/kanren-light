# Index of this directory

## The core library

| File            | Description                         |
| --------------- | ----------------------------------- |
| make.hl         | Top-level load file                 |
| streams.hl      | Library for streams                 |
| misc.hl         | Miscellanea                         |
| tunify.hl       | Unification helper functions        |
| solvers.hl      | Basic solvers and HO solvers        |
| list_solvers.hl | Solvers for lists                   |

## Additional library and examples

| File                 | Description                                       |
| -------------------- | ------------------------------------------------- |
| itaut.hl             | Our ITAUT solver                                  |
| lisp.hl              | A lisp like language and quine generator          |
| lock.hl              | Examples from The Mystery of the Monte Carlo Lock |
| ski.hl               | Experiments with SKI combinators (incomplete)     |
| lambda.hl            | Experiments with lambda-calculus (incomplete)     |

## Support material

| File                 | Description
| -------------------- | -------------------------------------------------
| sexp.hl              | Datatype and syntax for sexps

## Test files

| File                 | Description
| -------------------- | -------------------------------------------------
| solvers_test.hl      | Tests for basic solvers
| list_solvers_test.hl | Tests for lists solvers

## How to load this code using Nix

```shell
nix-shell -p hol_light
rlwrap hol_light
```

```ocaml
loads "update_database.ml";;
load_path := "/Users/maggesi/Devel/HOL" :: !load_path;;
loadt "kanren-light/make.hl";;
```

## How to build and the Docker image

Build the image:

```shell
docker build -t kanren-light Docker
```
or
```shell
docker build --pull --no-cache -t kanren-light Docker
```
then start the container:
```shell
docker run --rm -it -v "$PWD:/home/opam/work" kanren-light
```
ocaml is started automatically.

Then, load HOL Light:
```ocaml
#load "nums.cma";;
#use "make.ml";;
load_path := "/home/opam/work" :: !load_path;;
loadt "kanren-light/make.hl";;
```

## Build a docker container with the checkpointed HOL images

```shell
docker container rm kanren-light

docker run -it -h kanren-light --name kanren-light \
  -v "$PWD:/home/opam/work" \
  kanren-light /bin/bash
```

In one screen terminal
```shell
screen
dmtcp_coordinator -q -p 7779
s
```

In another screen terminal (C-a c)
```shell
dmtcp_launch -q -j -p 7779 ocaml -I `camlp5 -where` -init make.ml
```

Once finished loading (before checkpoint)
```
load_path := "/home/opam/work" :: !load_path;;
loads "update_database.ml";;
Gc.compact();;
```

Back into the first terminal (`C-a n` to cycle between screen terminals)
```
c
```

Commit the docker container:

```shell
docker commit -m "With checkpointed HOL" kanren-light kanren-light-ckpt
```

```shell
docker container rm kanren-light-ckpt

docker run -it -h kanren-light --name kanren-light-ckpt \
  -v "$PWD:/home/opam/work" \
  kanren-light-ckpt /bin/bash
```

Then load kanren light:
```ocaml
loadt "kanren-light/make.hl";;
```
