#' Bagging Gaussian Process Regression
#'
#' This function returns a list containing the bagged prediction averages,
#' standard deviations averages, and RMSE of the bagged GP model corresponding
#' to a given test set.
#'
#' \code{GP_bag} is a wrapper over the underlying \code{GP_fit()} function in the
#' \code{GPfit} package. Therefore, this function assumes a squared-exponential
#' (Gaussian) correlation function.
#' The parameter estimates are obtained by minimizing the deviance using a
#' multi-start gradient based search (L-BFGS-B) algorithm. Please see the
#' \code{GPfit} package details on Cran for more information on the GP method
#' used.
#'
#' @param dat.train Data.frame of training set with output obs on last column.
#' @param x.test Data.frame of test set.
#' @param y.test Vector of test observations.
#' @param iterations. number of iterations of the bagging algorithm. Default is 10.
#' @param n The number of observations in the training set. Default it set to dim(dat.train)[1].
#' @param ... Further arguments inherent in \code{GP_fit} function of package \code{GPfit}.
#' @return rbound List. \code{[[1]]} calls prediction averages, \code{[[2]]} calls sdev averages.
#' @keywords misc
#' @note All training data must be scaled in \code{[0,1]^d}.
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
#' print(GP.mod)


GP_Bag <- function(dat.train, x.test, y.test, iterations = 10, n = dim(dat.train)[1], ...) {

# Bagging
bootstrap <- foreach(m = 1:iterations, .combine = rbind) %do% {
	sample <- dat.train[sample(nrow(dat.train),size=length(dat.train[,1]),replace=TRUE),]
	y.bag <- sample[,ncol(sample)]
	x.bag <- sample[, -ncol(sample)]
	GP.mod <- GP_fit(x.bag, y.bag, corr = list(type="exponential",power = 2), ...)
	pred <- predict.GP(GP.mod, x.test)


	s <- GP.mod

	return(list(pred$complete_data[,2], s$beta, s$sig))
}

# bootstrap prediction output
pred.df <- ldply(bootstrap[,1])

# Aggregation of mean
pred.average <- pred.df %>%
	melt(id.vars = ".id", value.name = "observation") %>%
	group_by(variable) %>%
	summarise(mean(observation))
colnames(pred.average) = c("var", "obs")

# Aggregation of var
var.df <- ldply(bootstrap[,3])

var.average <- var.df %>%
	summarise(mean(V1))

pred.boot <- t(pred.df[,-1])
pred.boot <- data.frame(pred.boot)

var2 <- (pred.boot - pred.average$obs)^2
var2 <- as.numeric(rowMeans(var2))/iterations

var.bag <- as.numeric(var.average) + var2
sd.bag <- sqrt(var.bag)



return(list(pred = pred.average, sd = sd.bag))
}
