
<!-- README.md is generated from README.Rmd. Please edit that file -->

# selfbm

The goal of *selfbm* is to benchmark a function against itself by
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
split_chars <- function(x){
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
split_chars("ab")
#> [1] "a" "b"
```

But when we use *selfbm* the call is parsed and alternatives are
compared:

``` r
selfbm(split_chars("ab"))
#> Unit: nanoseconds
#>                                        expr  min   lq  mean median   uq
#>  res <- c(substr(x, 1, 1), substr(x, 2, 2)) 1600 1600 20919   1700 1800
#>                 res <- strsplit(x, "")[[1]]  800  900 11740    900 1000
#>      max neval cld
#>  1905800   100   a
#>  1075100   100   a
```

Two benchmarking pakages are supported, *microbenchmark* (the default),
and *bench*.

``` r
selfbm(split_chars("ab"), engine = "bench")
#> # A tibble: 2 x 6
#>   expression                                   min median `itr/sec`
#>   <bch:expr>                                 <bch> <bch:>     <dbl>
#> 1 res <- c(substr(x, 1, 1), substr(x, 2, 2))   2us  2.4us   262533.
#> 2 res <- strsplit(x, "")[[1]]                1.1us  1.3us   635017.
#> # ... with 2 more variables: mem_alloc <bch:byt>, `gc/sec` <dbl>
```
