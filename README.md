
<!-- README.md is generated from README.Rmd. Please edit that file -->

# selfbm

The goal of selfbm is to benchmark a function against itself by
providing alternate expressions in your code, separated by a `?` symbol.

It’s very young and subject to changes, and only supports one use of `?`
by function.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("moodymudskipper/selfbm")
```

## Example

Define a function, and provide alternate statement for a call:

``` r
library(selfbm)
#> 
#> Attaching package: 'selfbm'
#> The following object is masked from 'package:utils':
#> 
#>     ?
split2_chars <- function(x){
  # some code
  # ...
  res <- c(substr(x,1,1), substr(x,2,2)) ? res <- strsplit(x,"")[[1]]
  # some more code
  # ...
  res
}
```

The function still works when called normally, using the left hand side
call:

``` r
split2_chars("ab")
#> [1] "a" "b"
```

But when we use *selfbm* the call is parsed and alternatives are
compared:

``` r
selfbm(split2_chars("ab"))
#> Called from: selfbm(split2_chars("ab"))
#> debug at C:/R/00 packages/selfbm/R/selfbm.R#50: eval(call)
#> Unit: nanoseconds
#>                                        expr  min   lq  mean median   uq
#>  res <- c(substr(x, 1, 1), substr(x, 2, 2)) 1600 1700 15930   1700 1800
#>                 res <- strsplit(x, "")[[1]]  800  900 14030    900 1000
#>      max neval cld
#>  1415500   100   a
#>  1299100   100   a
```

Two benchmarking pakages are supported, *microbenchmark* (the default),
and *bench*.

``` r
selfbm(split2_chars("ab"), engine = "bench")
#> Called from: selfbm(split2_chars("ab"), engine = "bench")
#> debug at C:/R/00 packages/selfbm/R/selfbm.R#50: eval(call)
#> # A tibble: 2 x 6
#>   expression                                   min median `itr/sec`
#>   <bch:expr>                                 <bch> <bch:>     <dbl>
#> 1 res <- c(substr(x, 1, 1), substr(x, 2, 2)) 1.9us  2.2us   413356.
#> 2 res <- strsplit(x, "")[[1]]                1.1us  1.3us   717803.
#> # ... with 2 more variables: mem_alloc <bch:byt>, `gc/sec` <dbl>
```
