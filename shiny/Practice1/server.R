library(shiny)
library(dplyr)

shinyServer(function(input, output) {
    #df_file <- reactive(read.csv(input$file1$datapath))
    output$head <- renderTable(head(read.csv(input$file1$datapath)))
    # output$contents <- renderTable({
    #     
    #     # input$file1 will be NULL initially. After the user selects
    #     # and uploads a file, head of that data file by default,
    #     # or all rows if selected, will be shown.
    #     
    #     req(input$file1)
    #     
    #     df <- read.csv(input$file1$datapath,
    #                    header = input$header,
    #                    sep = input$sep,
    #                    quote = input$quote)
    #     
    #     if(input$disp == "head") {
    #         return(head(df))
    #     }
    #     else {
    #         return(df)
    #     }
    #     
    # })
    
})