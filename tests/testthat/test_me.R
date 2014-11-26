# Required data for testing ...................................................
n <- 40
x.train <- maximinLHS(n, 1)
y.train <- matrix(0, n, 1)
for(i in 1:n){ y.train[i] = (20*x.train[i])*sin(20*x.train[i]) + rnorm(length(x.train[i]),sd=1) }
dat.train <- data.frame(cbind(x.train,y.train))

# Test set
x.test <- seq(0, 1, 0.01);
y.test <- matrix(0, length(x.test), 1)
for(i in 1:length(x.test)){ y.test[i] = (20*x.test[i])*sin(20*x.test[i]) }
dat.test <- data.frame(cbind(x.test,y.test))

GP.mod <- GP_Bag(dat.train, x.test, y.test, iterations = 3, n = 40)
# ............................................................................


# Check that dat.train must be a data.frame
test_that("dat.train must be a data.frame", {
	expect_error(GP_Bag(as.vector(y.test), x.test, y.test, iterations = 3, n = 40))
})

# Check that iteration cannot be unit
test_that("iteration cannot be 1", {
	expect_error(GP_Bag(as.vector(y.test), x.test, y.test, iterations = 1, n = 40))
})

# Check that output of GP_Bag is a list
test_that("Output of GP_Bag is a list", {
	expect_is(GP_Bag(as.matrix(dat.train), x.test, y.test, iterations = 3, n = 40),
							 class = "list")
})

# Check that y.test cannot be a matrix
test_that("Output of GP_Bag is a list", {
	expect_error(GP_Bag(GP.mod, x.test, cbind(y.test,x.test), iterations = 3, n = 40))
})


# Check that output is a numeric vector
test_that("Error.GP_Bag outputs a numeric vector", {
	expect_is(Error.GP_Bag(GP.mod, y.test), class = "numeric")
})

# Check that input must be of class GP.mod
test_that("Error.GP_Bag must use a GP.mod class object", {
	expect_error(Error.GP_Bag(mod = GP.mod[[1]], y.test))
})

# Check that y.test input cannot be of class 'character'
test_that("y.test cannot be a character object", {
	expect_error(Error.GP_Bag(GP.mod, as.character(y.test)))
})

# Check that GP.mod is a list in Error.GP_Bag()
test_that("GP.mod must be of class list", {
	expect_error(Error.GP_Bag(y.test, y.test))
})

# Check that GP.mod is a list in plot_Bag()
test_that("GP.mod must be of class list", {
	expect_error(plot_Bag(y.test, x.test, y.test))
})





