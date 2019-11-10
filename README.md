
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
#>  res <- c(substr(x, 1, 1), substr(x, 2, 2)) 1600 1600 16386   1700 1800
#>                 res <- strsplit(x, "")[[1]]  800  900 15165    900 1000
#>      max neval cld
#>  1447700   100   a
#>  1402500   100   a
```

Several benchmarking packages are supported, *microbenchmark* (the
default), *bench*, and *rbenchmark*.

``` r
selfbm(split_chars("ab"), engine = "bench")
#> # A tibble: 2 x 6
#>   expression                                   min median `itr/sec`
#>   <bch:expr>                                 <bch> <bch:>     <dbl>
#> 1 res <- c(substr(x, 1, 1), substr(x, 2, 2))   2us  2.4us   323975.
#> 2 res <- strsplit(x, "")[[1]]                1.1us  1.3us   657929.
#> # ... with 2 more variables: mem_alloc <bch:byt>, `gc/sec` <dbl>
selfbm(split_chars("ab"), engine = "rbenchmark", replications = 10000)
#>                                         test replications elapsed relative
#> 1 res <- c(substr(x, 1, 1), substr(x, 2, 2))        10000    0.05        5
#> 2                res <- strsplit(x, "")[[1]]        10000    0.01        1
#>   user.self sys.self user.child sys.child
#> 1      0.05        0         NA        NA
#> 2      0.01        0         NA        NA
```
