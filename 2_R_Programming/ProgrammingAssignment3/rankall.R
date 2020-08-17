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