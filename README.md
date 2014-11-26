# Bagging for Gaussian Process Regression
Dustin Johnson  
`r Sys.Date()`  

I was inclined to build the `GP.Bagging` package, as I am constantly running this bagging routine for a current research project in STAT 547L - Dynamic Computer Experiments. The project is still underway, and so is my code. I will be updating a more sound version in the coming weeks. To my knowledge, bagging for GPs is quite new and there is no package available on CRAN thus far.

### Important Notes
The `GP.Bagging` package is a **work in progress**, hence the version is `0.0.0.9000`. Some features are not yet available, and will be noted in the following vignette.

### Installation
To install this package from my Github repository, simply input the following:

```r
library(devtools)
install_github("Dustin21/GP.Bagging")
```


### Dependencies
`GP.Bagging` is dependent on the following packages:

* **GPfit**: Fits Gaussian Process models.
* **foreach**: Enables efficient loops and parallel computation (parallel not yet integrated).
* **reshape2**: Use `melt()` function to reform data into long-form. 
* **plyr**: Used for its `ldply()` convert list to data.frame.
* **dplyr**: Reshapes and reforms data with `group_by()` and `summarise()`.

### Bootstrap AGGregatING (Bagging)

Suppose we have a training set of N points denoted as Z. To take a bootstrapped sample, we conduct the following:

1. Randomly sample N data points with replacement from Z with probability 1/N, where the N data points represent the re-sampled training set, denoted as Z1.
2. Repeat the procedure K times and obtain K re-sampled data sets: Z1,...,ZK.
3. Fit K separate models to each re-sampled training set.
4. Combine or 'aggregate' the models by averaging their predictive distributions.

This will improve robustness and stability of your noisy model, thereby improving predictive accuracy.


### Overview of Gaussian Process Regression
Gaussian Process (GP) Regression gained hype in the late 1990's
for pattern recognition due to the rapid advancement of computational power
that helped facilitate the implementation of GPs for large data sets.
Deriving from the family of neural networks and Bayesian non-parametric
regression, GPs are noted to be quite sensitive to changes in the training
data causing stability issues. Performing bagging on GPs increases
prediction stability and accuracy in data that follows a noisy and
stochastic behaviour (non-deterministic). To my knowledge, there is no
package to facilitate a bagging procedure on Gaussian Processes. This
package is a wrapper to a companion function called GPfit.


### GP.Bagging Package Model and Assumptions
`GP_bag` is a wrapper over the underlying `GP_fit()` function in the GPfit package. Therefore, this function assumes a squared-exponential (Gaussian) correlation function. The parameter estimates are obtained by minimizing the deviance using a multi-start gradient based search (L-BFGS-B) algorithm. Please see the [GPfit](http://cran.r-project.org/web/packages/GPfit/index.html) package details on Cran for more information on the GP method used.


### Using the function GP_Bag()
To use `GP_Bag()`, you must first load the package:


```r
library(GP.Bagging)
```

```
## Loading required package: ggplot2
## Loading required package: GPfit
## Loading required package: lhs
## Loading required package: foreach
## Loading required package: reshape2
## Loading required package: plyr
## Loading required package: dplyr
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:plyr':
## 
##     arrange, count, desc, failwith, id, mutate, rename, summarise,
##     summarize
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
## 
## Loading required package: RCurl
## Loading required package: bitops
## Loading required package: assertthat
```

You then input your training data.frame into the function as `dat.train`, and your test set, denoted as `x.test` and `y.test`. You can even specify the number of iterations to loop your bagging algorithm. `n` specifies the length of your training set. `...` can be any argument incorporated from the `GPfit` package.


```r
GP_Bag(dat.train, x.test, y.test, iterations = 10,
  n = dim(dat.train)[1], ...)
```


### Using the function plot_Bag()

Plotting the Gaussian process regressions are easy! All you have to do is input a `GP_Bag()` object and the input values of your test set.


```r
p <- plot_Bag(mod, x.test)
print(p)
```

### Using the function Error.GP_Bag()
We can even check the error of our model simply by calling our `GP_Bag()` object and the observational vector of our test set. This saves you all the work from doing it yourself.


```r
error <- Error.GP_Bag(mod, x.test)
print(error)
```


### A 1-d Toy Example
Let's combine all our functions into a toy example. First we will output our `GP_Bag()` object.


```r
### Toy Example in 2-dimensional case.
# Training set
set.seed(2)
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

GP.mod <- GP_Bag(dat.train, x.test, y.test, iterations = 20, n = 15)
print(GP.mod)
```

```
## $pred
## Source: local data frame [101 x 2]
## 
##    var        obs
## 1   V1  0.7845320
## 2   V2  0.2860105
## 3   V3 -0.4787780
## 4   V4 -1.3067734
## 5   V5 -1.8929946
## 6   V6 -1.9566616
## 7   V7 -1.3959405
## 8   V8 -0.3785725
## 9   V9  0.7153633
## 10 V10  1.4921714
## .. ...        ...
## 
## $sd
##   [1] 5.649013 5.647611 5.646162 5.646708 5.648607 5.648135 5.643319
##   [8] 5.638321 5.637855 5.639757 5.640070 5.639463 5.639490 5.640023
##  [15] 5.641100 5.642085 5.641681 5.640765 5.641258 5.642975 5.644294
##  [22] 5.643727 5.643141 5.647581 5.655128 5.657124 5.651597 5.644742
##  [29] 5.642336 5.644366 5.646248 5.645813 5.644744 5.643829 5.644641
##  [36] 5.650525 5.658848 5.662777 5.661666 5.660334 5.663290 5.668121
##  [43] 5.666638 5.658872 5.651606 5.646407 5.642093 5.639175 5.638220
##  [50] 5.639713 5.643542 5.647730 5.650355 5.651340 5.651683 5.653456
##  [57] 5.659161 5.668102 5.674709 5.673103 5.663459 5.651856 5.643866
##  [64] 5.640676 5.640987 5.643690 5.648030 5.653452 5.660676 5.670573
##  [71] 5.680516 5.684968 5.681285 5.672106 5.662153 5.655258 5.654470
##  [78] 5.662659 5.672684 5.671456 5.668933 5.677652 5.684434 5.687523
##  [85] 5.699659 5.724751 5.757351 5.776443 5.765110 5.732336 5.696829
##  [92] 5.669393 5.654270 5.651972 5.657906 5.664570 5.669636 5.682734
##  [99] 5.717051 5.766335 5.800519
```

Now let's examine the plot by simply calling our `GP_Bag()`, `GP.mod` and test set, `y.test`.


```r
p <- plot_Bag(GP.mod, x.test)
print(p)
```

![](./overview_files/figure-html/unnamed-chunk-7-1.png) 

Finally, let's examine the error by again calling on our `GP_Bag()` object, as well as our test observations, `y.test`.


```r
error <- Error.GP_Bag(GP.mod, y.test)
print(error)
```

```
## [1]   1.500329 114.366076
```


### Reflections

Building your own package was much more difficult than I had originally anticipated. I had some issues when I began using testthat for debugging, but realised that I am able to put a 'test' chunk of code within my `test_me.R`, so that I could run the checks. So, this resolved the open-ended question stated in my `gameday` vignette.

Another issues I encountered involved constructing a plotting function. For some reason, the plotting function was not able to be read, although I was able to examine its help file with `?`. After copying and pasting it into a different R script while overwriting the original file, the function magically worked. I would still like to know what happened there, as I made no changes to the function itself.

On another note, I was trying to get my vignette to output as a `.md` file as well, to push to Github. Unfortunately, when I tried the usual keep_md: true below the vignette yaml, it outputted to some other location on my computer. I am wondering if its possible to insert it in the `vignette: >` yaml using some other syntax. In the meantime, I just outputted a `.md` manually.

I mainly stuck with Jenny & Bernhard's amazing [Write your own R package](http://stat545-ubc.github.io/packages02_activity.html) walk-through to help get me through this assignment.

Altogether, this was a great learning experience and required quite a bit of work. After running the `check`, I was relieved to know that `R CMD check succeeded`. I will be updating this function in the upcoming weeks as I progress with my research project.
