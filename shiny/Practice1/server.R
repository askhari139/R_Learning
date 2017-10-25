library(shiny)
library(dplyr)

shinyServer(function(input, output) {
    file_data <- reactive({read.csv(input$file1$datapath,
                  header = input$header,
                  sep = input$sep,
                  quote = input$quote)})
    output$dataHead <- renderTable({
        req(input$file1)
        if (input$disp == "Head") {
            return(head(file_data()))
        }
        else
            {return(file_data)}
        })
    output$cols <- renderUI({
        
    })
})

