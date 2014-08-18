#' @export
#' @rdname TuneControl
makeTuneControlGenSA = function(same.resampling.instance = TRUE, impute.val = NULL, start = NULL, ...) {
  args = list(...)
  default = list(smooth = FALSE)
  default = list()
  args = insert(default, args)
  args2 = list(same.resampling.instance = same.resampling.instance, impute.val = impute.val,
    start = start, cl = "TuneControlGenSA")
  do.call(makeTuneControl, c(args, args2))
}
