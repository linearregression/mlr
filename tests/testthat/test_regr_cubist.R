context("regr_cubist")

test_that("regr_cubist", {
  library(Cubist)
  parset.list1 = list(
    list(),
    list(committees = 2L),
    list(control = cubistControl(extrapolation = 50L, rules = 50L))
  )
  parset.list2 = list(
    list(),
    list(committees = 2L),
    list(extrapolation = 50, rules = 50L)
  )

  old.predicts.list = list()
  X = regr.train[, setdiff(names(regr.train), regr.target)]
  y = regr.train[, regr.target]

  for (i in 1:length(parset.list1)) {
    parset = parset.list1[[i]]
    parset = c(list(x = X, y = y), parset)
    set.seed(getOption("mlr.debug.seed"))
    m = do.call(cubist, parset)
    p  = predict(m, newdata = regr.test)
    old.predicts.list[[i]] = p
  }

  testSimpleParsets("regr.cubist", regr.df, regr.target, regr.train.inds,
    old.predicts.list, parset.list2)
})
