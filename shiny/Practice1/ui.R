library(shiny)
library(dplyr)
library(ggplot2)


shinyUI(
 fluidPage(
     ##Uploading the data file with header and other options and displaying it
     titlePanel("", windowTitle = "Data Visualization"),
     HTML("<center><h1>Data Visualization</h1></center>"), hr(), br(),
     HTML("<center><h3>Input data window</h3></center>"),
        sidebarLayout( #Options for loading the file
            sidebarPanel(

                fileInput("file1", "Choose CSV File",
                          multiple = TRUE,
                          accept = c("text/csv",
                                     "text/comma-separated-values,text/plain",
                                     ".csv")),
                tags$hr(),

                checkboxInput("header", "Header", TRUE),

                radioButtons("sep", "Separator",
                             choices = c(Comma = ",",
                                         Semicolon = ";",
                                         Tab = "\t"),
                             selected = ","),

                radioButtons("quote", "Quote",
                             choices = c(None = "",
                                         "Double Quote" = '"',
                                         "Single Quote" = "'"),
                             selected = '"'),

                tags$hr(),

                radioButtons("disp", "Display",
                             choices = c(Head = "Head",
                                         All = "all"),
                             selected = "Head")

            ),

            mainPanel(
                tableOutput("dataHead") #showing the data
                #uiOutput("cols")
            )
        ),
        HTML("<center><h3>Interactive Plot window</h3></center>"),
        sidebarLayout(
            sidebarPanel(
                uiOutput("plotType"),
                uiOutput("x"),
                uiOutput("y"),
                conditionalPanel(
                    condition = "input.plotType == 'geom_point(aes_string(input$x, input$y))'",
                    checkboxInput(inputId = "line", label = "Add best fit line")
                ),
                checkboxInput("save", "Save the plot"),
                conditionalPanel(
                    condition = "input.save",
                    selectInput("imgFormat", "Image Format", 
                                choices = c(PNG = ".png",
                                            JPG = ".jpg",
                                            TIFF = ".tiff")),
                    textInput("imgName", "Filename")
                    
                )
                
            ),
            mainPanel(
                textInput(inputId = "plotLabel", label = "Title for the plot"),
                plotOutput("plot")
            )
        )
    ))
