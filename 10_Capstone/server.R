library(shiny)

initialPrediction <- readRDS("data/initialPrediction.RData")
freq2ngram <- readRDS("data/bigram.RData")
freq3ngram <- readRDS("data/trigram.RData")
freq4ngram <- readRDS("data/quadgram.RData")

badWordsFile <- "data/full-list-of-bad-words_text-file_2018_07_30.txt"
con <- file(badWordsFile, open = "r")
profanity <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
profanity <- iconv(profanity, "latin1", "ASCII", sub = "")
close(con)

predictionMatch <- function(userInput, ngrams) {
    
    if (ngrams > 3) {
        userInput3 <- paste(userInput[length(userInput) - 2],
                            userInput[length(userInput) - 1],
                            userInput[length(userInput)])
        dataTokens <- freq4ngram %>% filter(token == userInput3)
        if (nrow(dataTokens) >= 1) {
            return(dataTokens$outcome[1:3])
        }
        return(predictionMatch(userInput, ngrams - 1))
    }
    
    if (ngrams == 3) {
        userInput1 <- paste(userInput[length(userInput)-1], userInput[length(userInput)])
        dataTokens <- freq3ngram %>% filter(token == userInput1)
        if (nrow(dataTokens) >= 1) {
            return(dataTokens$outcome[1:3])
        }
        return(predictionMatch(userInput, ngrams - 1))
    }
    
    if (ngrams < 3) {
        userInput1 <- userInput[length(userInput)]
        dataTokens <- freq2ngram %>% filter(token == userInput1)
        return(dataTokens$outcome[1:3])
    }
    
    return(NA)
}

cleanInput <- function(input) {
    
    if (input == "" | is.na(input)) {
        return("")
    }
    
    input <- tolower(input)
    input <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("\\S+[@]\\S+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("@[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("#[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("[0-9](?:st|nd|rd|th)", "", input, ignore.case = FALSE, perl = TRUE)
    input <- removeWords(input, profanity)
    input <- gsub("[^\\p{L}'\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("[.\\-!]", " ", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("^\\s+|\\s+$", "", input)
    input <- stripWhitespace(input)
    
    if (input == "" | is.na(input)) {
        return("")
    }
    
    input <- unlist(strsplit(input, " "))
    
    return(input)
    
}

predictNextWord <- function(input, word = 0) {
    
    input <- cleanInput(input)
    
    if (input[1] == "") {
        output <- initialPrediction
    } else if (length(input) == 1) {
        output <- predictionMatch(input, ngrams = 2)
    } else if (length(input) == 2) {
        output <- predictionMatch(input, ngrams = 3)
    } else if (length(input) > 2) {
        output <- predictionMatch(input, ngrams = 4)
    }
    
    if (word == 0) {
        return(output)
    } else if (word == 1) {
        return(output[1])
    } else if (word == 2) {
        return(output[2])
    } else if (word == 3) {
        return(output[3])
    }
    
}

shinyServer(function(input, output) {
    
    output$userSentence <- renderText({input$userInput});
    
    observe({
        numPredictions <- input$numPredictions
        if (numPredictions == 1) {
            output$prediction1 <- reactive({predictNextWord(input$userInput, 1)})
            output$prediction2 <- NULL
            output$prediction3 <- NULL
        } else if (numPredictions == 2) {
            output$prediction1 <- reactive({predictNextWord(input$userInput, 1)})
            output$prediction2 <- reactive({predictNextWord(input$userInput, 2)})
            output$prediction3 <- NULL
        } else if (numPredictions == 3) {
            output$prediction1 <- reactive({predictNextWord(input$userInput, 1)})
            output$prediction2 <- reactive({predictNextWord(input$userInput, 2)})
            output$prediction3 <- reactive({predictNextWord(input$userInput, 3)})
        }
    })
})
library(shiny)

initialPrediction <- readRDS("data/initialPrediction.RData")
freq2ngram <- readRDS("data/bigram.RData")
freq3ngram <- readRDS("data/trigram.RData")
freq4ngram <- readRDS("data/quadgram.RData")

badWordsFile <- "data/full-list-of-bad-words_text-file_2018_07_30.txt"
con <- file(badWordsFile, open = "r")
profanity <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
profanity <- iconv(profanity, "latin1", "ASCII", sub = "")
close(con)

predictionMatch <- function(userInput, ngrams) {
    
    if (ngrams > 3) {
        userInput3 <- paste(userInput[length(userInput) - 2],
                            userInput[length(userInput) - 1],
                            userInput[length(userInput)])
        dataTokens <- freq4ngram %>% filter(token == userInput3)
        if (nrow(dataTokens) >= 1) {
            return(dataTokens$outcome[1:3])
        }
        return(predictionMatch(userInput, ngrams - 1))
    }
    
    if (ngrams == 3) {
        userInput1 <- paste(userInput[length(userInput)-1], userInput[length(userInput)])
        dataTokens <- freq3ngram %>% filter(token == userInput1)
        if (nrow(dataTokens) >= 1) {
            return(dataTokens$outcome[1:3])
        }
        return(predictionMatch(userInput, ngrams - 1))
    }
    
    if (ngrams < 3) {
        userInput1 <- userInput[length(userInput)]
        dataTokens <- freq2ngram %>% filter(token == userInput1)
        return(dataTokens$outcome[1:3])
    }
    
    return(NA)
}

cleanInput <- function(input) {
    
    if (input == "" | is.na(input)) {
        return("")
    }
    
    input <- tolower(input)
    input <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("\\S+[@]\\S+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("@[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("#[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("[0-9](?:st|nd|rd|th)", "", input, ignore.case = FALSE, perl = TRUE)
    input <- removeWords(input, profanity)
    input <- gsub("[^\\p{L}'\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("[.\\-!]", " ", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("^\\s+|\\s+$", "", input)
    input <- stripWhitespace(input)
    
    if (input == "" | is.na(input)) {
        return("")
    }
    
    input <- unlist(strsplit(input, " "))
    
    return(input)
    
}

predictNextWord <- function(input, word = 0) {
    
    input <- cleanInput(input)
    
    if (input[1] == "") {
        output <- initialPrediction
    } else if (length(input) == 1) {
        output <- predictionMatch(input, ngrams = 2)
    } else if (length(input) == 2) {
        output <- predictionMatch(input, ngrams = 3)
    } else if (length(input) > 2) {
        output <- predictionMatch(input, ngrams = 4)
    }
    
    if (word == 0) {
        return(output)
    } else if (word == 1) {
        return(output[1])
    } else if (word == 2) {
        return(output[2])
    } else if (word == 3) {
        return(output[3])
    }
    
}

shinyServer(function(input, output) {
    
    output$userSentence <- renderText({input$userInput});
    
    observe({
        numPredictions <- input$numPredictions
        if (numPredictions == 1) {
            output$prediction1 <- reactive({predictNextWord(input$userInput, 1)})
            output$prediction2 <- NULL
            output$prediction3 <- NULL
        } else if (numPredictions == 2) {
            output$prediction1 <- reactive({predictNextWord(input$userInput, 1)})
            output$prediction2 <- reactive({predictNextWord(input$userInput, 2)})
            output$prediction3 <- NULL
        } else if (numPredictions == 3) {
            output$prediction1 <- reactive({predictNextWord(input$userInput, 1)})
            output$prediction2 <- reactive({predictNextWord(input$userInput, 2)})
            output$prediction3 <- reactive({predictNextWord(input$userInput, 3)})
        }
    })
})
