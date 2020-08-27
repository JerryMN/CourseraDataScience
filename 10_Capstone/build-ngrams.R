# script to load swiftkey data

library(tm)
library(dplyr)
library(stringi)
library(stringr)
library(quanteda)
library(data.table)

# Load data
blogsFN <- "data/en_US.blogs.txt"
con <- file(blogsFN, open = "rb")
blogs <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

newsFN <- "data/en_US.news.txt"
con <- file(newsFN, open = "rb")
news <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

twitterFN <- "data/en_US.twitter.txt"
con <- file(twitterFN, open = "rb")
twitter <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

profanitiesFN <- "data/full-list-of-bad-words_text-file_2018_07_30.txt"
con <- file(profanitiesFN, open = "r")
profanities <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

rm(con, blogsFN, newsFN, twitterFN, profanitiesFN)

# Prepare data
set.seed(26082020)
sampleSize = 0.05
sampleBlogs <- sample(blogs, length(blogs) * sampleSize)
sampleNews <- sample(news, length(news) * sampleSize)
sampleTwitter <- sample(twitter, length(twitter) * sampleSize)

sampleBlogs <- iconv(sampleBlogs, "latin1", "ASCII", sub = "")
sampleNews <- iconv(sampleNews, "latin1", "ASCII", sub = "")
sampleTwitter <- iconv(sampleTwitter, "latin1", "ASCII", sub = "")
profanities <- iconv(profanities, "latin1", "ASCII", sub = "")

# Combine all samples into one
sampleData <- c(sampleBlogs, sampleNews, sampleTwitter)
rm(blogs, news, twitter, sampleBlogs, sampleNews, sampleTwitter, sampleSize)

# Clean data
sampleData <- tolower(sampleData)
sampleData <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", sampleData, perl = T)
sampleData <- gsub("\\S+[@]\\S+", "", sampleData, perl = T)
sampleData <- gsub("@[^\\s]+", "", sampleData, perl = T)
sampleData <- gsub("#[^\\s]+", "", sampleData, perl = T)
sampleData <- gsub("[0-9](?:st|nd|rd|th)", "", sampleData, perl = T)
sampleData <- removeWords(sampleData, profanities)
sampleData <- gsub("[^\\p{L}'\\s]+", "", sampleData, perl = T)
sampleData <- gsub("[.\\-!]", " ", sampleData, perl = T)
sampleData <- gsub("^\\s+|\\s+$", "", sampleData)
sampleData <- stripWhitespace(sampleData)

# Save data
con <- file("data/en_US.sample.txt", open = "w")
writeLines(sampleData, con)
close(con)
rm(profanities, con)

# Build corpus
corpus <- corpus(sampleData)
rm(sampleData)

# Build n-gram frequencies
topThree <- function(corpus) {
    first <- !duplicated(corpus$token)
    balance <- corpus[!first, ]
    first <- corpus[first, ]
    second <- !duplicated(balance$token)
    balance2 <- balance[!second,]
    second <- balance[second,]
    third <- !duplicated(balance2$token)
    third <- balance2[third,]
    return(rbind(first, second, third))
}

tokenFrequency <- function(corpus, n = 1, rem_stopw = NULL) {
    corpus <- dfm(tokens_ngrams(tokens(corpus), n))
    corpus <- colSums(corpus)
    total <- sum(corpus)
    corpus <- data.frame(token = names(corpus),
                         n = corpus,
                         row.names = NULL,
                         check.names = F,
                         stringsAsFactors = F)
    corpus <- mutate(corpus, token = gsub("_", " ", token))
    corpus <- mutate(corpus, percent = corpus$n / total)
    if(n > 1) {
        corpus$outcome <- word(corpus$token, -1)
        corpus$token <- word(corpus$token, start = 1, end = n - 1)
    }
    setorder(corpus, -n)
    corpus <- topThree(corpus)
    return(corpus)
}

startWord <- character()
for(i in seq_along(corpus)){
    firstWord <- word(corpus[[i]], 1)
    startWord <- c(startWord, firstWord)
}
startWord <- tokenFrequency(startWord)
startWordPrediction <- startWord$token[1:3]
saveRDS(startWordPrediction, "data/initialPrediction.RData")

bigram <- tokenFrequency(corpus, 2)
saveRDS(bigram, "data/bigram.RData")
rm(bigram)

trigram <- tokenFrequency(corpus, 3)
trigram <- filter(trigram, n > 1)
saveRDS(trigram, "data/trigram.RData")
rm(trigram)

quadgram <- tokenFrequency(corpus, 4)
quadgram <- filter(quadgram, n > 1)
saveRDS(quadgram, "data/quadgram.RData")
rm(quadgram, firstWord)