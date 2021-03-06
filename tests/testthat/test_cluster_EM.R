context("cluster_EM")

test_that("cluster_EM", {
  library(RWeka)
	parset.list = list(
			list(),
			list(N=10)
	)
	
	old.predicts.list = list()
	
	for (i in 1:length(parset.list)) {
		parset = parset.list[[i]]
		ctrl = do.call(Weka_control, parset)
		set.seed(getOption("mlr.debug.seed"))
		m = make_Weka_clusterer("weka/clusterers/EM")(noclass.train, control=ctrl)
		p = predict(m, noclass.test) + 1
		old.predicts.list[[i]] = p
	}
	
	testSimpleParsets("cluster.EM", noclass.df, character(0L), noclass.train.inds, old.predicts.list, parset.list)
})
