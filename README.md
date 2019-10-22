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
loads "update_database.ml";;
load_path := <<topdir>> :: !load_path;;
loadt "kanren_light/make.hl";;
```