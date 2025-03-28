
<!-- README.md is generated from README.Rmd. Please edit that file -->

# LGBF

<!-- badges: start -->

[![R-CMD-check](https://github.com/jsleight1/LGBF/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/jsleight1/LGBF/actions/workflows/check-standard.yaml)
[![Codecov test
coverage](https://codecov.io/gh/jsleight1/LGBF/branch/main/graph/badge.svg)](https://app.codecov.io/gh/jsleight1/LGBF/?branch=main)
<!-- badges: end -->

This repo contains an R package to create the
[LGBF](https://jack-sleight.shinyapps.io/LGBF/) shiny application. The
shiny application generates interactive visualisations and datatables of
local government benchmarking Framework indicator data generated across
local authorities in Scotland.

## Installation

You can install the development version of LGBF from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
devtools::install_github("jsleight1/LGBF")
```

LGBF also contains a `renv.lock` file which can be used to create a
reproducible environment using
[renv](https://rstudio.github.io/renv/articles/renv.html).

Alternatively, a docker image is available avaiable from
[docker.io](https://hub.docker.com/r/jsleight1/lgbf).

## Example

The shiny application can be launched locally using:

``` r
library(LGBF)
LGBF()
```

A dockerised version of the application can be launched using:

    docker run -p 9001:9001 -it docker.io/jsleight1/lgbf:latest

The application can then be viewed at:

    http://localhost:9001/

***Please note the docker image is only avaiable for linux/arm64 and
linux/amd64 OS architectures.***

## Data and references.

All data used to produce this dashboard was downloaded from the Local
Government Benchmarking Framework
([LGBF](https://www.improvementservice.org.uk/benchmarking/explore-the-data)).
