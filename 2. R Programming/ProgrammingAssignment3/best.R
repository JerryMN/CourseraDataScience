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