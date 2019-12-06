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

<<<<<<< HEAD
## How to load this code using Nix

```shell
nix-shell -p hol_light
rlwrap hol_light
```

```ocaml
loads "update_database.ml";;
load_path := !load_path @ [ "<<topdir>>" ];;
=======
## Run with Docker

```shell
docker build -t kanren-light Docker
cd Devel/HOL
docker run --rm -it -v "$PWD:/home/opam/work" kanren-light /bin/bash
cd hol-light
ocaml -I `camlp5 -where`
#load "nums.cma";;
#use "make.ml";;
load_path := ".." :: !load_path;;
>>>>>>> First version of Docker file.
loadt "kanren-light/make.hl";;
```