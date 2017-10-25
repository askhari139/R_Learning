library(shiny)
library(dplyr)

shinyUI(
 fluidPage(
     ##Uploading the data file with header and other options and displaying it
        titlePanel("Exploratory Analysis"),
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
                tableOutput("dataHead"), #showing the data
                selectInput(inputId = "columns",
                            label = "Column names in the file",
                            choices = colnames(data_file)) #to show the columnnames

            )

        )))
