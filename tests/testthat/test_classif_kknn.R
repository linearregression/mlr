context("classif_kknn")

test_that("classif_kknn", {
  library(kknn)
  parset.list = list(
    list(),
    list(k = 1),
    list(k = 4),
    list(k = 10)
  )

  old.predicts.list = list()
  old.probs.list = list()

  for (i in 1:length(parset.list)) {
    parset = parset.list[[i]]
    pars = list(formula = multiclass.formula, train = multiclass.train, test = multiclass.test)
    pars = c(pars, parset)
    set.seed(getOption("mlr.debug.seed"))
    m = do.call(kknn, pars)
    p = predict(m, newdata = multiclass.test)
    old.predicts.list[[i]] = p
    old.probs.list[[i]] = m$prob
  }

  testSimpleParsets("classif.kknn", multiclass.df, multiclass.target, multiclass.train.inds,
    old.predicts.list, parset.list)
  testProbParsets("classif.kknn", multiclass.df, multiclass.target, multiclass.train.inds,
    old.probs.list, parset.list)

  tt = function (formula, data, k = 7) {
    return(list(formula = formula, data = data, k = k))
  }
  tp = function(model, newdata) {
    kknn(model$formula, train = model$data, test = newdata, k = model$k)$fitted
  }

  testCVParsets("classif.kknn", multiclass.df, multiclass.target, tune.train = tt, tune.predict = tp,
    parset.list = parset.list)
})

