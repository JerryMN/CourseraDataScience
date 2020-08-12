## These functions take as input a square invertible matrix
## Then it calculates the inverse matrix and caches it
## If it has already been calculates, it skips the new calculation
## hence, the cache. 

## The first function generates a sort of matrix object
## albeit not a "true" matrix. 

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


## This function calculates de inverse of the matrix
## and saves it, so that if it is called again, it
## skips the calculation and returns the saved (cached)
## value.

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