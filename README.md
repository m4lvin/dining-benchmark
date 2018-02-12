# Benchmarking Model Checkers for Dynamic and Temporal Epistemic Logics

Comparing different epistemic model checkers using the [Dining Cryptographers](https://en.wikipedia.org/wiki/Dining_cryptographers_problem) example.

A similar benchmark was done in https://doi.org/10.1007/s10009-015-0378-x.

## How to

Please have a look at the Makefile or run `make all`.

## Used Model Checkers

Currently the following model checkers are used:

- MCK from https://cgi.cse.unsw.edu.au/~mck/pmck/ (proprietary)
    - Not included here, because it is not available under a free license.
    - You should put `mck-Linux-1.1.0.tar` into the `packages` directory.
    - no downloads available as of 2018-02-01)

- MCTK from https://sites.google.com/site/cnxyluo/MCTK/ (LGPL 2.1)
    - Sources and binaries are included here as `packages/MCTK-1.0.2-compiled.zip`

- MCMAS from http://vas.doc.ic.ac.uk/software/mcmas/ (GPL-2.0)
    - The source package is included here as `packages/mcmas-1.3.0.tar.gz`

- SMCDEL from https://www.github.com/jrclogic/SMCDEL/ (GPL-2.0)
    - Gets automatically downloaded, you need [stack](https://haskellstack.org/)

## To do / To add

- DEMO from https://homepages.cwi.nl/~jve/demo/

- DEMO-S5 from https://homepages.cwi.nl/~jve/software/demo_s5/

- MCTK 2 coming soon at https://github.com/hovertiger/MCTK2
