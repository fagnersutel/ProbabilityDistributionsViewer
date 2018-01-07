# 非心ベータ分布 ----
ncbeta.func <- function(shape1, shape2, ncp, p_or_c){
  if(p_or_c == "p"){
    func <- function(x) dncbeta(x, shape1=shape1, shape2=shape2, ncp=ncp)
  } else {
    func <- function(x) pncbeta(x, shape1=shape1, shape2=shape2, ncp=ncp)
  }
  return(func)
}
## functions ----
ncbeta.func_p <- function(shape1, shape2, ncp) function(x) dbeta(x, shape1=shape1, shape2=shape2, ncp=ncp)
ncbeta.func_c <- function(shape1, shape2, ncp) function(x) pbeta(x, shape1=shape1, shape2=shape2, ncp=ncp)
ncbeta.formula <- "
f(x) = \\sum_{j=0}^\\infty \\frac{1}{j!}
\\left(\\frac{\\lambda}{2}\\right)^je^{-\\lambda/2}
\\frac{x^{\\alpha+j-1}(1-x)^{\\beta-1}}{B(\\alpha+j,\\beta)}
"

## Moments ----
ncbeta.mean <- function(shape1, shape2, ncp){
  value <- exp(- ncp / 2) *
    shape1 *
    hypergeo::genhypergeo(
      U = c(shape1 + 1, shape1 + shape2),
      L = c(shape1, 1 + shape1 + shape2),
      z = ncp / 2) /
    (shape1 + shape2)
  return(value)
}
ncbeta.mean_str <- "
e^{-\\frac{\\lambda}{2}}
\\frac{\\alpha}{\\alpha+\\beta}
{}_2F_2\\left(\\alpha+\\beta,\\alpha+1;\\alpha,\\alpha+\\beta+1;\\frac{\\lambda}{2}
\\right)
"

ncbeta.variance <- function(shape1, shape2, ncp) {
  value.mean <- ncbeta.mean(shape1, shape2, ncp)
  value <- exp(- ncp / 2) *
    shape1 *
    (shape1 + 1) *
    hypergeo::genhypergeo(
      U = c(shape1 + 1, shape1 + shape2),
      L = c(shape1, 1 + shape1 + shape2),
      z = ncp / 2) /
    ((shape1 + shape2) * (shape1 + shape2 + 1)) -
    value.mean ** 2
  return(value)
}
ncbeta.variance_str <- "
e^{-\\frac{\\lambda}{2}}
\\frac{\\alpha (\\alpha+1)}{(\\alpha+\\beta)(\\alpha+\\beta+1)}
{}_2F_2\\left(\\alpha+\\beta,\\alpha+2;\\alpha,\\alpha+\\beta+2
;\\frac{\\lambda}{2}\\right) - \\mu^2
"

## Parameters ----
ncbeta.range <- list(
  min = 0,
  max = 1,
  value = c(0, 1),
  step= 0.01
)
ncbeta.shape1 <- list(
  name = "shape1",
  label = "形状 \\(\\alpha\\)",
  min = 0,
  max = 20,
  value = 2,
  step = 0.1
)
ncbeta.shape2 <- list(
  name = "shape2",
  label = "形状 \\(\\beta\\)",
  min = 0,
  max = 20,
  value = 2,
  step = 0.1
)
ncbeta.ncp <- list(
  name = "ncp",
  label = "非中心度 \\(\\lambda\\)",
  min = 0,
  max = 20,
  value = 0,
  step = 0.1
)

## Instance ----
ncbeta <- Distribution$new(
  dist = "ncbeta",
  name = "Noncentral beta distribution",
  wiki = "https://en.wikipedia.org/wiki/Noncentral_beta_distribution",
  c_or_d = "c",
  formula = ncbeta.formula,
  func_p = ncbeta.func_p,
  func_c = ncbeta.func_c,
  mean = ncbeta.mean,
  mean_str = ncbeta.mean_str,
  variance = ncbeta.variance,
  variance_str = ncbeta.variance_str,
  range = ncbeta.range,
  ncbeta.shape1,
  ncbeta.shape2,
  ncbeta.ncp
)