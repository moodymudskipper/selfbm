#' Redifined question mark for benchmarking
#'
#' It evaluates its rhs so the function still works when edited with `call1 ? call2` syntax
#'
#' @param e1
#' @param e2
#'
#' @return
#' @export
#'
#' @examples
`?` <- function(e1, e2) {
  eval.parent(substitute(e1))
}


#' Benchmark a function against itself
#'
#'
#' @param call a function call
#' @param ... additional parameters passed to the relevant engine
#' @param engine engine
#'
#' @return
#' @export
#'
#' @examples
selfbm <- function(call, ..., engine = c("microbenchmark", "bench")){
  engine <- match.arg(engine)
  call <- substitute(call)
  fun <- call[[1]]
  f1 <- f2 <- eval.parent(fun)
  # nm1 and nm2 will be defined by using assign in qm_split (sorry)
  body(f1) <- qm_split(body(f1),1, environment())
  body(f2) <- qm_split(body(f2),2, environment())
  sub_lst1 <- setNames(list(quote(f1)), as.character(fun))
  sub_lst2 <- setNames(list(quote(f2)), as.character(fun))
  call1 <- do.call(substitute, list(call, sub_lst1))
  call2 <- do.call(substitute, list(call, sub_lst2))
  engine <- switch(
    engine,
    microbenchmark = quote(microbenchmark::microbenchmark),
    bench = quote(bench::mark))
  call <- as.call(c(
    engine,
    setNames(c(call1,call2), c(nm1,nm2)),
    alist(...)))
  call
  eval(call)
}

qm_split <- function(call, i, env){
  if(!is.call(call)) return(call)
  if(call[[1]] == quote(`?`)) {
    assign(paste0("nm",i), deparse2(call[[i+1]]),envir = env)
    return(call[[i+1]])
  }
  call[] <- lapply(call, qm_split, i, env)
  call
}

deparse2 <- function(x) paste(deparse(x),collapse = "")
