#' Determine Error of GP_Bag model
#'
#' This function returns the root mean square error (RMSE) and the absolute error (AbsE)
#' of the bagged Gaussian process regression (\code{GP_Bag}) object.
#'
#' The \code{Error.GP_Bag} conveniently returns your model error, so you
#' done't have to yourself.
#'
#' @param mod A GP_Bag object.
#' @param y.test Data.frame of test observations. Defaults to a vector y.test.
#' @return vector. Returns a 1x2 vector with RMSE and AbsE
#' @keywords misc
#' @note Must be a GP_Bag model type.
#' @export
#' @examples
#' ### Toy Example in 2-dimensional case.
#' # Training set
#' set.seed(2)
#' n <- 40
#' x.train <- maximinLHS(n, 1)
#' y.train <- matrix(0, n, 1)
#' for(i in 1:n){ y.train[i] = (20*x.train[i])*sin(20*x.train[i]) + rnorm(length(x.train[i]),sd=1) }
#' dat.train <- data.frame(cbind(x.train,y.train))
#'
#' # Test set
#' x.test <- seq(0, 1, 0.01);
#' y.test <- matrix(0, length(x.test), 1)
#' for(i in 1:length(x.test)){ y.test[i] = (20*x.test[i])*sin(20*x.test[i]) }
#' dat.test <- data.frame(cbind(x.test,y.test))
#'
#' GP.mod <- GP_Bag(dat.train, x.test, y.test, iterations = 20, n = 40)
#'
#' Error.GP_Bag(GP.mod, y.test)


Error.GP_Bag <- function(mod, y.test) {

	assert_that(check_list(mod))

	predictions <- mod[[1]][,2]
	actual <- y.test
	RMSE <- sqrt(mean((actual - predictions)^2))
	AbsE <- sum(abs(actual - predictions))

	return(c(RMSE, AbsE))
}
