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
            return(head(file_data(), 15))
        }
        else
            {return(file_data)}
        })
    numerics <- reactive({colnames(file_data()[sapply(file_data(), is.numeric)])})
    chars <- reactive({colnames(file_data()[sapply(file_data(), is.character)])})
    output$cols <- renderUI({
        req(input$file1)
        selectInput(inputId = "columns", label = "Column names in the data",
                    choices = colnames(file_data()))
    })
    output$x <- renderUI({
        req(input$file1)
        if(input$plotType == "geom_histogram(aes_string(input$x))")
            choice <- numerics()
        else
            choice <- colnames(file_data())
        selectInput(inputId = "x", label = "Abscissa",
                        choices = choice)
    })
    output$y <- renderUI({
            req(input$file1)
            if(input$plotType == "geom_histogram(aes_string(input$x))" ||
               input$plotType == "geom_bar(aes_string(input$x))")
                choice <- NULL
            else
                choice <- colnames(file_data())
            selectInput(inputId = "y", label = "Ordinate",
                        choices = choice)
    })
    output$plotType <- renderUI({
        req(input$file1)
        selectInput(inputId = "plotType", label = "Type of plot",
                    choices = c(Scatterplot = "geom_point(aes_string(input$x, input$y))",
                                Hisogram = "geom_histogram(aes_string(input$x))",
                                Boxplot = "geom_boxplot(aes_string(x = input$x, y = input$y))",
                                Bargraph = "geom_bar(aes_string(input$x))"
                    ))
    })
    output$plot <- renderPlot(
        {
            
            req(input$plotType)
            req(input$file1)
            plt <- ggplot(data = file_data()) + eval(parse(text = input$plotType)) +
                labs(title = input$plotLabel)
            if(input$line) plt <- plt + geom_smooth(method = "lm", aes_string(input$x, input$y))
            plt                          
        })
    
    
    
})

