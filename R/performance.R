#' Measure performance of prediction.
#'
#' Measures the quality of a prediction w.r.t. some performance measure.
#'
#' @template arg_pred
#' @template arg_measures
#' @param task [\code{\link{Task}}]\cr
#'   Learning task, might be requested by performance measure, usually not needed except for clustering.
#' @param model [\code{\link{WrappedModel}}]\cr
#'   Model built on training data, might be requested by performance measure, usually not needed.
#' @param feats [\code{data.frame}]\cr
#'   Features of predicted data, usually not needed except for clustering.
#'   If the prediction was generated from a \code{task}, you can also pass this instead and the features
#'   are extracted from it.
#' @return [named \code{numeric}]. Performance value(s), named by measure(s).
#' @export
#' @family performance
#' @examples
#' training.set = seq(1, nrow(iris), by = 2)
#' test.set = seq(2, nrow(iris), by = 2)
#'
#' task = makeClassifTask(data = iris, target = "Species")
#' lrn = makeLearner("classif.lda")
#' mod = train(lrn, task, subset = training.set)
#' pred = predict(mod, newdata = iris[test.set, ])
#' performance(pred, measures = mmce)
#'
#' # Compute multiple performance measures at once
#' ms = list("mmce" = mmce, "acc" = acc, "timetrain" = timetrain)
#' performance(pred, measures = ms, task, mod)
performance = function(pred, measures, task = NULL, model = NULL, feats = NULL) {
  if (!is.null(pred))
    assertClass(pred, classes = "Prediction")
  measures = checkMeasures(measures, pred$task.desc)
  res = vnapply(measures, doPerformaceIteration, pred = pred, task = task, model = model, td = NULL, feats = feats)
  setNames(res, extractSubList(measures, "id"))
}

doPerformaceIteration = function(measure, pred = NULL, task = NULL, model = NULL, td = NULL, feats = NULL) {
  m = measure
  if (m$req.pred) {
    if (is.null(pred))
      stopf("You need to pass pred for measure %s!", m$id)
    pred2 = pred
    td = pred$task.desc
  } else {
    pred2 = NULL
  }
  if (m$req.model) {
    if (is.null(model))
      stopf("You need to pass model for measure %s!", m$id)
    assertClass(model, classes = "WrappedModel")
    model2 = model
    td = model$task.desc
  } else {
    model2 = NULL
  }
  if (m$req.task && !m$req.feats) {
    if (is.null(task))
      stopf("You need to pass task for measure %s!", m$id)
    assertClass(task, classes = "Task")
    task2 = task
    td = task$desc
  } else {
    task2 = NULL
  }
  if (m$req.feats) {
    if (is.null(task) && is.null(feats))
      stopf("You need to pass features for measure %s!", m$id)
    else if (is.null(feats))
      feats = task$env$data[pred$data$id,, drop = FALSE]
    else
      assertClass(feats, "data.frame")
  }
  # null only happens in custom resampled measure when we do no individual measurements
  if (!is.null(td)) {
    if (td$type %nin% m$properties)
      stopf("Measure %s does not support task type %s!", m$id, td$type)
    if (td$type == "classif" && length(td$class.levels) > 2L && "classif.multi" %nin% m$properties)
      stopf("Multiclass problems cannot be used for measure %s!", m$id)
    if (!is.null(pred2) && !(pred2$predict.type %in% m$allowed.pred.types))
      stopf("Measure %s is only allowed for predictions of type: %s!",
        m$id, collapse(m$allowed.pred.types))
  }
  measure$fun(task2, model2, pred2, feats, m$extra.args)
}
