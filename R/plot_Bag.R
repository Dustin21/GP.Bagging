#' Plot a GP_Bag model
#'
#' his function returns ggplot for a GP_Bag type object, thereby plotting a bagged
#' Gaussian Process regression model with mean prediction and error bounds, along
#' with the true function in green.
#'
#' The \code{plot.GP_Bag} conveniently plots a \code{GP_Bag} object, so you
#' done't have to yourself.
#'
#' @param mod A GP_Bag object.
#' @param x.test Data.frame of test set.
#' @param y.test Data.frame of test observations.
#' @return ggplot. Returns a ggplot with mean prediction and error bounds
#' @keywords misc
#' @note mod must be a GP_Bag model type.
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
#' p <- plot_Bag(mod = GP.mod, x.test, y.test)
#' print(p)


plot_Bag <- function(mod, x.test, y.test) {
	pred <- as.data.frame(mod[[1]][,2])
	sdev <- as.data.frame(mod[[2]])
	upper <- as.data.frame(pred + 2*sdev)
	lower <- as.data.frame(pred - 2*sdev)
	df <- data.frame(pred, upper, lower, x.test)

	p <- ggplot(df, aes(x.test, obs)) + geom_line() +
		geom_line(aes(x.test, obs.1), linetype = "dashed", colour = "red") +
		geom_line(aes(x.test, obs.2), linetype = "dashed", colour = "red") +
		geom_line(aes(x.test, y.test), colour = "green") +
		theme(panel.background = element_rect(fill='white', colour='black')) +
		ylab("Predictions of Bagged GP model") + theme(legend.position="none")

	return(p)
}
