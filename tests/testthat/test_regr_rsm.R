context("regr_rsm")

test_that("regr_rsm", {
  library(rsm)
  data = regr.df[, c("b", "lstat", "medv")]
  pars = list(medv ~ FO(b, lstat), data=data[regr.train.inds,])
  set.seed(getOption("mlr.debug.seed"))
  m = do.call(rsm, pars)
  p = predict(m, newdata=regr.test)
  
  testSimple("regr.rsm", data, regr.target, regr.train.inds, p)
})
