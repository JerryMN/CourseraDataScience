corr <- function(directory, threshold = 0){
  list <- list.files(directory, ".csv", full.names = T)
  
  # Create a vector of id's which have complete observations above the threshold
  
  compnobs <- complete(directory) # df of complete obervations ("nobs") per id
  nobst <- compnobs["nobs"] > threshold # logical vector of nobs are above the threshold
  ids <- comp[nobst, ]$id # vector of the id's corresponding to these nobs
  
  res <- numeric()
  
  # For each of these id's calculate the correlation and append it to the vector res.
  for(i in ids){
    data <- read.csv(list[i])
    compcases <- data[complete.cases(data), ]
    res <- c(res, cor(compcases$sulfate, compcases$nitrate))
  }
  return(res)
}