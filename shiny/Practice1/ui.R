library(shiny)


shinyUI(
    fluidPage(
        ################File input Window#######################################
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
                
                radioButtons("quote", "Unquote",
                             choices = c(None = "",
                                         "Double Quote" = '"',
                                         "Single Quote" = "'"),
                             selected = '"'),
                
                tags$hr(),
                fluidRow(
                    column(5, radioButtons("disp", "Display",
                                           choices = c(Head = "Head",
                                                       All = "all"),
                                           selected = "Head")),
                    column(6, offset = 1, sliderInput("numRows", "Number of rows to display",
                                                      min = 5,
                                                      max = 25,
                                                      value = 10))
                ),
                tags$hr(),
                
                actionButton(inputId = "proceed", label = "Proceed to plotting")
                
            ),
            
            mainPanel(
                tableOutput("dataHead") #showing the data
            )
        ),
        
        ###################Plot Window##########################################
        uiOutput("plotWindowTitle"),
        uiOutput("plotWindow")
        
    ))
