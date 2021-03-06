context("classif_linDA")

test_that("classif_linDA", {
  library(DiscriMiner)
	set.seed(getOption("mlr.debug.seed"))
  m = linDA(multiclass.train[,-multiclass.class.col], group=multiclass.train[,multiclass.class.col])
	p =  classify(m, newdata=multiclass.test[,-multiclass.class.col])
	testSimple("classif.linDA", multiclass.df, multiclass.target, multiclass.train.inds, p$pred_class)
	
  tt = function (formula, data, subset, ...) {
    j = which(colnames(data) == as.character(formula)[2])
    m = linDA(variables = data[subset,-j], group = data[subset,j])
    list(model = m, target=j)
  }
  
  tp = function(model, newdata) {
    classify(model$model, newdata = newdata[,-model$target])$pred_class
  }
  
  testCV("classif.linDA", multiclass.df, multiclass.target, tune.train=tt, tune.predict=tp)
})
