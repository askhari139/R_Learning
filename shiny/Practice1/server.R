library(shiny)
library(dplyr)
library(ggplot2)

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
        req(input$file1)
        selectInput(inputId = "columns", label = "Column names in the data",
                    choices = colnames(file_data()))
    })
    output$x <- renderUI({
        req(input$file1)
        selectInput(inputId = "x", label = "Abscissa",
                    choices = colnames(file_data()))
    })
    output$y <- renderUI({
            req(input$file1)
            selectInput(inputId = "y", label = "Ordinate",
                        choices = colnames(file_data()))
    })
    output$plot <- renderPlot(
        {
            req(input$plotType)
            ggplot(data = file_data, aes(renderText(input$x), renderText(input$y))) + 
                                  renderText(input$plotType)
        })
    
})

