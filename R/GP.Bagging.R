#' Bootstrap Aggregation (Bagging) for Gaussian Process Regression
#'
#' A wrapper for the function \code{GP_fit()} in the package \code{GPfit}
#' that enabled one to conduct bootstrap re-sampling of a Gaussian Process
#' Regression.
#'
#' This function was inspired by the paper "Bagging for Gaussian
#' process regression" by T. Chen and J. Ren [2].
#'
#' There are many packages that offer the ability to bootstrap a typical
#' regression, but are unable to cope with more sophistocated models, such
#' as the Gaussian Process (GP) Regression. As the predictions of GP
#' regressions are considered to be quite sensitive to changes in the
#' training data, a package offering such a capability would surely increase
#' the rubustness of their predictions and improve acuracy [1]. Please note that
#' this is only the case with functions that have noisy and stochastic behaviour
#' and thus, has not been tested with deterministic functions. The boostrap would
#' have to be adjusted to "without replacement" in such a case where no noise
#' is present.
#'
#' [1] L. Breiman, Bagging predictors, Machine Learning 26 (1996) 123 - 140.
#'
#' [2] T. Chen and J. Ren, "Bagging for Gaussian process regression," Neurocomputing,vol.
#' 72, pp. 1605 - 1610, 2009
#'
#' @docType package
#' @name GP.Bagging
NULL
