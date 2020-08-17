layout: page
title: "Programming Assignment 1"
permalink: /R_Programming/


## **Introduction**

For this first programming assignment I wrote three functions that are meant to interact with a dataset containing pollution monitoring data for fine particulate matter (PM) air pollution at 332 locations in the United States. This files are located in the */specdata* folder found in my github repository. 

Each file contains three variables:

- Date: the date of the observation in YYYY-MM-DD format (year-month-day)
- sulfate: the level of sulfate PM in the air on that date (measured in micrograms per cubic meter)
- nitrate: the level of nitrate PM in the air on that date (measured in micrograms per cubic meter)

## **pollutantmean()**

The function 'pollutantmean' calculates the mean of a pollutant (sulfate or nitrate) across a specified list of monitors. The function 'pollutantmean' takes three arguments: 'directory', 'pollutant', and 'id'. Given a vector monitor ID numbers, 'pollutantmean' reads that monitors' particulate matter data from the directory specified in the 'directory' argument and returns the mean of the pollutant across all of the monitors, ignoring any missing values coded as NA.


```r
pollutantmean <- function(directory, pollutant, id = 1:332){
  list <- list.files(path = directory, pattern = ".csv", full.names = T)
  values <- numeric()
  
  for(i in id){
    data <- read.csv(list[i])
    values <- c(values, data[[pollutant]])
  }
  mean(values, na.rm = T)
}
```

## **complete()**

This function reads a directory full of files and reports the number of completely observed cases in each data file. The function returns a data frame where the first column is the name of the file and the second column is the number of complete cases.


```r
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
```

## **corr()**

This function takes a directory of data files and a threshold for complete cases and calculates the correlation between sulfate and nitrate for monitor locations where the number of completely observed cases (on all variables) is greater than the threshold. The function returns a vector of correlations for the monitors that meet the threshold requirement. If no monitors meet the threshold requirement, then the function returns a numeric vector of length 0.


```r
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
```

