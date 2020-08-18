---
title: "ProgrammingAssignment3"
output: 
    html_document:
        keep_md: true
---



# **Introduction**

This assignment's aim is to compare hospital performance across the United States using various metrics.

The data for this assignment come from the Hospital Compare web site (http://hospitalcompare.hhs.gov) run by the U.S. Department of Health and Human Services. The purpose of the web site is to provide data and information about the quality of care at over 4,000 Medicare-certified hospitals in the U.S. This dataset essentially covers all major U.S. hospitals. This dataset is used for a variety of purposes, including determining whether hospitals should be fined for not providing high quality care to patients.

A description of the variables, the actual dataset and all other info can be consulted in the Github repo. 

# **Assignment**

Mainly, we are interested in comparing hospital mortality rates across 30 days, specifically regarding heart attack, heart failure and pneumonia.

## Finding the best hospital in a state

The function *best()* takes two arguments.

- state: written as a two letter abbreviation and inside quotes (ex. "TX")
- outcome: can be one of
    - "heart attack"
    - "heart failure"
    - "pneumonia"
    

```r
best <- function(state, outcome){
    ## Read outcome data
    data <- read.csv("outcome-of-care-measures.csv", colClasses = "character", header = T)
    
    ## Create new data frame with only columns of interest
    data <- as.data.frame(cbind(data[, 2],    #hospital
                                data[, 7],    #state
                                data[, 11],   #heart attack
                                data[, 17],   #heart failure
                                data[, 23]),  #pneumonia
                                stringsAsFactors = F)
    
    ## Add column names
    colnames(data) <- c("hospital", "state", "heart attack", "heart failure", "pneumonia")
    
    ## Check that state and outcome are valid
    if(!state %in% data[, "state"]){
        stop("invalid state")
    } else if(!outcome %in% c("heart attack", "heart failure", "pneumonia")){
        stop("invalid outcome")
    } else {
        ## Extract data for given state
        subdata <- data[which(data[, "state"] == state), ]
        ## Extract values for given outcome
        values <- as.numeric(subdata[, outcome])
        ## Find minimum
        minvalues <- min(values, na.rm = T)
        ## Find to which hospital this minimum corresponds
        result <- subdata[, "hospital"][which(values == minvalues)]
        ## Order results alphabetically in case of tie
        output <- result[order(result)]
    }
    return(output)
}
```

For example, 


```r
best("TX", "heart attack")
```

```
## [1] "CYPRESS FAIRBANKS MEDICAL CENTER"
```

returns the hospital with the lowest 30-day mortality rate for heart attack in Texas. 

## Ranking hospitals by outcome in a state

The function *rankhospital()* takes three arguments.

- state: written as a two letter abbreviation and inside quotes (ex. "TX")
- outcome: can be one of
    - "heart attack"
    - "heart failure"
    - "pneumonia"
- num: the ranking of a hospital in that state for that outcome. It can be one of
    - "best" (default)
    - "worst"
    - an integer


```r
rankhospital <- function(state, outcome, rank = "best"){
    ## Read outcome data
    data <- read.csv("outcome-of-care-measures.csv", colClasses = "character", header = T)
  
    ## Create new data frame with only columns of interest
    data <- as.data.frame(cbind(data[, 2],    #hospital
                                data[, 7],    #state
                                data[, 11],   #heart attack
                                data[, 17],   #heart failure
                                data[, 23]),  #pneumonia
                          stringsAsFactors = F)
  
    ## Add column names
    colnames(data) <- c("hospital", "state", "heart attack", "heart failure", "pneumonia")
    
    ## Check that state and outcome are valid
    if(!state %in% data[, "state"]){
      stop("invalid state")
    } else if(!outcome %in% c("heart attack", "heart failure", "pneumonia")){
      stop("invalid outcome")
    } else if(is.numeric(rank)){
      ## Extract the data for the given state
      subdata <- data[which(data[, "state"] == state), ]
      ## Change the outcome values to numeric instead of char
      subdata[, outcome] <- as.numeric(subdata[, outcome])
      ## Sort in ascending order by outcome and then by hospital
      subdata <- subdata[order(subdata[, outcome], subdata[, "hospital"]), ]
      ## Output the desired item
      output <- subdata[, "hospital"][rank]
    } else if(!is.numeric(rank)){
        if(rank == "best"){
          ## Call best function
          output <- best(state, outcome)
        } else if(rank == "worst"){
          ## Extract the data for the given state
          subdata <- data[which(data[, "state"] == state), ]
          ## Change the outcome values to numeric instead of char
          subdata[, outcome] <- as.numeric(subdata[, outcome])
          ## Sort in descending order by outcome and then by hospital
          subdata <- subdata[order(subdata[, outcome], subdata[, "hospital"], decreasing = T), ]
          ## Output the first item
          output <- subdata[, "hospital"][1]
        } else {
          stop("invalid rank")
        }
    }
      return(output)
}
```

For example,


```r
rankhospital("MD", "heart failure", 5)
```

```
## [1] "SAINT AGNES HOSPITAL"
```

returns the hospital with the fifth lowest 30-day death rate for heart failure in Maryland. 

## Ranking hospitals in all states

The function *rankall()* takes two arguments.

- outcome: can be one of
    - "heart attack"
    - "heart failure"
    - "pneumonia"
- num: the ranking of a hospital in that state for that outcome. It can be one of
    - "best" (default)
    - "worst"
    - an integer
    

```r
rankall <- function(outcome, num = "best"){
    ## Read outcome data
    data <- read.csv("outcome-of-care-measures.csv", colClasses = "character", header = T)
    
    ## Create new data frame with only columns of interest
    data <- as.data.frame(cbind(data[, 2],    #hospital
                                data[, 7],    #state
                                data[, 11],   #heart attack
                                data[, 17],   #heart failure
                                data[, 23]),  #pneumonia
                          stringsAsFactors = F)
    
    ## Add column names
    colnames(data) <- c("hospital", "state", "heart attack", "heart failure", "pneumonia")
    
    ## Check that state and outcome are valid
    if(!outcome %in% c("heart attack", "heart failure", "pneumonia")){
      stop("invalid outcome")
    } else if(is.numeric(num)){
      ## Change values to numeric instead of char
      data[, outcome] <- as.numeric(data[, outcome])
      ## Group data by state
      by_state <- with(data, split(data, state))
      ordered <- list()
      ## For every state, order by outcome values and then by hospital
      ## then create a list
      for(i in seq_along(by_state)){
        by_state[[i]] <- by_state[[i]][order(by_state[[i]][, outcome], 
                                             by_state[[i]][, "hospital"]), ]
        ordered[[i]] <- c(by_state[[i]][num, "hospital"], by_state[[i]][, "state"][1])
      }
      ## Create a data frame from this list
      result <- do.call(rbind, ordered)
      output <- as.data.frame(result, row.names = result[, 2], stringsAsFactors = F)
      names(output) <- c("hospital", "state")
    } else if(!is.numeric(num)){
      ## Change values to numeric instead of char
      data[, outcome] <- as.numeric(data[, outcome])
        if(num == "best"){
          ## Group data by state
          by_state <- with(data, split(data, state))
          ordered <- list()
          ## For every state, order by outcome values and then by hospital
          ## and make a list with the first (best) items
          for(i in seq_along(by_state)){
            by_state[[i]] <- by_state[[i]][order(by_state[[i]][, outcome], 
                                                 by_state[[i]][, "hospital"]), ]
            ordered[[i]]  <- c(by_state[[i]][1, c("hospital", "state")])
          }
          ## Create a data frame from this list
          result <- do.call(rbind, ordered)
          output <- as.data.frame(result, row.names = result[, 2], stringsAsFactors = F)
        } else if(num == "worst"){
          ## Group data by state
          by_state <- with(data, split(data, state))
          ordered <- list()
          ## For every state, order in descending order by outcome values and then by hospital
          ## and make a list with the first (worst) items
          for(i in seq_along(by_state)){
            by_state[[i]] <- by_state[[i]][order(by_state[[i]][, outcome], 
                                                 by_state[[i]][, "hospital"], 
                                                 decreasing = TRUE), ]
            ordered[[i]]  <- as.character(subset(r, state == "HI")$hospital)
          }
          ## Create a data frame from this list
          result <- do.call(rbind, ordered)
          output <- as.data.frame(result, row.names = result[, 2], stringsAsFactors = F)
        } else {
          stop("invalid rank")
        }
    }
    
    return(output)
  }
```

For example,


```r
head(rankall("pneumonia"), 3)
```

```
##                              hospital state
## AK YUKON KUSKOKWIM DELTA REG HOSPITAL    AK
## AL      MARSHALL MEDICAL CENTER NORTH    AL
## AR        STONE COUNTY MEDICAL CENTER    AR
```

returns the 3 hospitals with the best 30-day mortality rates, and in which states these are. 
