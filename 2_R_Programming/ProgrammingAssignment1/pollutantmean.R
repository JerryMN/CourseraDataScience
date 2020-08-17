pollutantmean <- function(directory, pollutant, id = 1:332){
  list <- list.files(path = directory, pattern = ".csv", full.names = T)
  values <- numeric()
  
  for(i in id){
    data <- read.csv(list[i])
    values <- c(values, data[[pollutant]])
  }
  mean(values, na.rm = T)
}