library(shiny)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(ggmap)
library(ggrepel)
library(shinydashboard)

# Define User Interface for application that draws maps
ui <- fluidPage(
    titlePanel("Distribution of rescribed variants"),
    
    sidebarLayout(
        
        #Create side bar panel with a slider that lets users select date
        sidebarPanel(
            sliderInput("date", "Select date:",
                        min = floor_date(ymd("2011-01-01"), "month"),
                        max = floor_date(ymd("2016-12-01"), "month"),
                        value = floor_date(ymd("2011-01-01"), "month"),
                        timeFormat = "%b-%Y")),
        
        #The main panel with two tabs for the two countries
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("France", plotOutput("map_fr")),
                        tabPanel("Québec", plotOutput("map_qu"))))))


#Define server function
server <- function(input, output) {
    
    #Load in previously saved data
    france <- readRDS("france.rds")
    quebec <- readRDS("quebec.rds")
    hashtag <- readRDS("hashtag.rds")
    
    #Define color aesthetics for the maps
    city_size_FR <- c("3"=0.5, "4"=1, "5"=2, "6"=3, "7"=4, "8"=6)
    city_size_QU <- c("small"=1, "medium"=3, "large"=5)
    
    #Create a reactive filtering of the data based on user input of date
    #the 'input$date' needs to be the same format as in the data
    hashtag_filter <- reactive({
        filter(hashtag, date == floor_date(ymd(input$date), "month"))
    })
    
    #Plot output maps with aesthetic precisions
    # 'aes' requires 'mapping ='
    #Display interactive map for France
    output$map_fr <- renderPlot({
        france + geom_point(subset(hashtag_filter(), country == "france"),
                            mapping = aes(x = lon, y = lat, size = citysize, color = prescribed)) +
            scale_size_manual(values = city_size_FR, name = "Population size",
                              labels = c("3"="> 10,000 people",
                                         "4"="> 20,000 people",
                                         "5"="> 50,000 people",
                                         "6"="> 100,000 people",
                                         "7"="> 200,000 people",
                                         "8"="> 2,000,000 people")) +
            scale_color_gradient2(name = "Distribution",
                                  low = "black", mid = "red", high = "yellow",
                                  midpoint = 0.5, limits = c(0,1)) +
            geom_text_repel(subset(hashtag_filter(), country == "france"),
                            mapping = aes(x = lon, y = lat, label = city), size = 3) +
            labs(x = "longitude", y = "latitude")
    })
    
    #Display interactive map for Québec
    output$map_qu <- renderPlot({
        quebec + geom_point(subset(hashtag_filter(), country == "quebec"),
                            mapping = aes(x = lon, y = lat, size = citysize, color = prescribed)) +
            scale_size_manual(values = city_size_QU, name = "Population size",
                              labels = c("small"="> 1,000 people",
                                         "medium"="> 30,000 people",
                                         "large"="> 100,000 people")) +
            scale_color_gradient2(name = "Distribution",
                                  low = "black", mid = "red", high = "yellow",
                                  midpoint = 0.5, limits = c(0,1)) +
            geom_text_repel(subset(hashtag_filter(), country == "quebec"),
                            mapping = aes(x = lon, y = lat, label = city), size = 3) +
            labs(x = "longitude", y = "latitude")
    })
}

#Execute the shiny app
shinyApp(ui, server)