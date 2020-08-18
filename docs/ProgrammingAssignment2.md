---
title: "ProgrammingAssignment2"
permalink: /R_Programming/ProgrammingAssignment2/
---

# **Introduction**

This second programming assignment creates an R function that is able to cache potentially time-consuming computations.
For example, taking the mean of a numeric vector is typically a fast operation. However, for a very long vector, it may take too long to compute the mean, especially if it has to be computed repeatedly (e.g. in a loop). If the contents of a vector are not changing, it may make sense to cache the value of the mean so that when we need it again, it can be looked up in the cache rather than recomputed.

# **Assignment**

```r
## These functions take as input a square invertible matrix, then it calculates
## the inverse matrix and caches it.
## If it has already been calculated, it skips the new calculation hence, the cache. 

## The first function generates a sort of matrix object albeit not a "true" matrix. 

makeCacheMatrix <- function(x = matrix()){
    inv <- NULL
    set <- function(y){
      x <<- y
      inv <<- NULL
  }
    get <- function() x
    setinv <- function(inverse) inv <<- inverse
    getinv <- function() inv
    list(set = set, get = get,
         setinverse = setinv, getinverse = getinv)
}


## This function calculates the inverse of the matrix and saves it, so that if it is called again,
## it skips the calculation and returns the saved (cached) value.

cacheSolve <- function(x, ...){
    inv <- x$getinv()
    if(!is.null(inv)){
        message("getting cached data")
        return(inv)
  }
    data <- x$get()
    inv <- solve(data, ...)
    x$setinv(inv)
    inv
}
```