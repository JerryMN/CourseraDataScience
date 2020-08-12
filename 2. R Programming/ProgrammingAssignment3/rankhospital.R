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