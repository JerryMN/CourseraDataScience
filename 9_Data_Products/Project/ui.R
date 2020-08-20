library(shiny)
library(plotly)

shinyUI(fluidPage(

    # Application title
    titlePanel("Populations of Capital Cities, Grouped by Continent"),

    # Sidebar with checkbox inputs for all 7 continents
    sidebarLayout(
        sidebarPanel(
            h3("Select contintents to plot"),
            checkboxInput("afr_check", "AFRICA", value = T),
            checkboxInput("ant_check", "ANTARCTICA", value = T),
            checkboxInput("asia_check", "ASIA", value = T),
            checkboxInput("aus_check", "AUSTRALIA", value = T),
            checkboxInput("eur_check", "EUROPE", value = T),
            checkboxInput("na_check", "NORTH AMERICA", value = T),
            checkboxInput("sa_check", "SOUTH AMERICA", value = T)
        ),

        # Show the plot
        mainPanel(plotlyOutput("plotlyplot"))
    )
))
