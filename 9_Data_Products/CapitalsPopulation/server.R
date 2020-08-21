library(shiny)
library(plotly)
library(dplyr)
library(readr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$plotlyplot <- renderPlotly({

        capitals <- read_csv("capitals.csv", locale = locale(encoding = "Latin1"))
        
        if(input$afr_check == F){
            capitals <- filter(capitals, Continent != "Africa")
        }
        if(input$ant_check == F){
            capitals <- filter(capitals, Continent != "Antarctica")
        }
        if(input$asia_check == F){
            capitals <- filter(capitals, Continent != "Asia")
        }
        if(input$aus_check == F){
            capitals <- filter(capitals, Continent != "Australia")
        }
        if(input$eur_check == F){
            capitals <- filter(capitals, Continent != "Europe")
        }
        if(input$na_check == F){
            capitals <- filter(capitals, Continent != "North America")
        }
        if(input$sa_check == F){
            capitals <- filter(capitals, Continent != "South America")
        }
        
        fig <- plot_ly(capitals, x = ~Continent, y = ~Population, text=~paste(Capital, ",", Country),
                       mode = "markers", type = "scatter", height = 900)
        fig

    })

})
