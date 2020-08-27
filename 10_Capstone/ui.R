library(shiny)
library(shinythemes)
library(markdown)
library(dplyr)
library(tm)

shinyUI(navbarPage("Predict Next Word",
                   theme = shinytheme("spacelab"),
                   tabPanel("Home",
                            fluidPage(
                                titlePanel("Prediction"),
                                sidebarLayout(
                                    sidebarPanel(
                                        textInput("userInput",
                                                  "Enter a word or prhrase...",
                                                  value = ""),
                                        br(),
                                        sliderInput("numPredictions", "Number of Predictions to Make",
                                                    value = 1.0, min = 1.0, max = 3.0, step = 1.0)
                                    ),
                                    mainPanel(
                                        h4("Predicted next words"),
                                        verbatimTextOutput("prediction1"),
                                        verbatimTextOutput("prediction2"),
                                        verbatimTextOutput("prediction3")
                                    )
                                )
                            )
                   ),
                   tabPanel("About",
                            h3("About this App"),
                            br(),
                            div("Predict Next Word is my take at the Data Science Course
                              Capstone Project. It uses a text prediction algorithm to
                              predict the next words based on text that is entered by
                              the user.",
                                br(),
                                br(),
                                "Please allow the app a few seconds for the prediction to appear.",
                                br(),
                                br(),
                                "Use the slider to select from one to three words to predict, in
                              order of likelihood.",
                                br(),
                                br(),
                                "The source code for this app can be found over at my",
                                a(target = "_blank", href = "https://github.com/JerryMN/CourseraDataScience/tree/gh-pages/10_Capstone",
                                  " GitHub")),
                   )
))

library(shiny)
library(shinythemes)
library(markdown)
library(dplyr)
library(tm)

shinyUI(navbarPage("Predict Next Word",
                   theme = shinytheme("spacelab"),
                   tabPanel("Home",
                            fluidPage(
                                titlePanel("Prediction"),
                                sidebarLayout(
                                    sidebarPanel(
                                        textInput("userInput",
                                                  "Enter a word or prhrase...",
                                                  value = ""),
                                        br(),
                                        sliderInput("numPredictions", "Number of Predictions to Make",
                                                    value = 1.0, min = 1.0, max = 3.0, step = 1.0)
                                    ),
                                    mainPanel(
                                        h4("Predicted next words"),
                                        verbatimTextOutput("prediction1"),
                                        verbatimTextOutput("prediction2"),
                                        verbatimTextOutput("prediction3")
                                    )
                                )
                            )
                   ),
                   tabPanel("About",
                            h3("About this App"),
                            br(),
                            div("Predict Next Word is my take at the Data Science Course
                              Capstone Project. It uses a text prediction algorithm to
                              predict the next words based on text that is entered by
                              the user.",
                                br(),
                                br(),
                                "Please allow the app a few seconds for the prediction to appear.",
                                br(),
                                br(),
                                "Use the slider to select from one to three words to predict, in
                              order of likelihood.",
                                br(),
                                br(),
                                "The source code for this app can be found over at my",
                                a(target = "_blank", href = "https://github.com/JerryMN/CourseraDataScience/tree/gh-pages/10_Capstone",
                                  " GitHub")),
                   )
))