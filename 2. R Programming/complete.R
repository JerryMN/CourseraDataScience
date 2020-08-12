complete <- function(directory, id = 1:332){
  list <- list.files(path = directory, pattern = ".csv", full.names = T)
  nobs <- numeric()
  
  
  for (i in id){
    data <- read.csv(list[i])
    nobs <- c(nobs, sum(complete.cases(data)))
  }
  df <- data.frame(id = id, nobs = nobs)
  df
}
