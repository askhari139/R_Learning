#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

bcl <- read.csv("C:/Users/Shrikishore.Hari/Desktop/R/R_Learning/shiny/deanattali/Dean_attali_app/bcl-data.csv",
                stringsAsFactors = FALSE)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("BC liquor store"),
  br(), hr(), br(),

  # Sidebar with a slider input for number of bins
  HTML("<center> <em><h3>Dynamics of price w.r.t. the alcohol content</h3></em></center>"),
  sidebarLayout(
    sidebarPanel(
       sliderInput("priceInput",
                   "Price",
                   min = 1,
                   max = 100,
                   value = c(25,40))
    ),
    mainPanel(
        plotOutput("line")
    )), hr(), br(),
  
  em(h3("Overall alcohol content distribution", align = "center")), 
  sidebarLayout(
      sidebarPanel("Alcohol levels",
                   sliderInput("bins",
                               "Number of bins",
                               min = 1,
                               max = 50,
                               value = 30)
      ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  ), hr(), br(), 
  em(h3("Country and type-wise alcohol content distribution", align = "center")), 
  fluidRow(
      column(width = 3, fluidRow(selectInput("typeInput",
                                "Type of Alcohol",
                                choices = unique(bcl$Type)
                                )),
                   fluidRow(selectInput("countryInput",
                               "Country",
                               choices = unique(bcl$Country)
                               )),
                   fluidRow(sliderInput("bins2",
                               "Number of bins",
                               min = 1,
                               max = 50,
                               value = 30)),
                   fluidRow(actionButton(inputId = "go",
                                label = "Plot"))
                    ),
      column(width = 7,
          fluidRow(tableOutput("results")),
          fluidRow(plotOutput("coolplot"))
      )
    )
  
))

