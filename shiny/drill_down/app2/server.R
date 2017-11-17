shinyServer(function(input, output, session) {
    Dataset <- reactive(read.csv(input$Ifile$datapath, header = input$Iheader))
    num_cols <- reactive(
        {
            req(input$Ifile)
            colnames(
                Dataset()[, sapply(Dataset(), is.numeric)]
            )}
    )
    
    char_cols <- reactive(
        {
            req(input$Ifile)
            colnames(
                Dataset()[,sapply(Dataset(), is.factor)]
            )}
    )
    
    output$Oxval <- renderUI({req(input$Ifile)
        cols <- switch(input$Iplottype,
                       "Histogram" = num_cols(),
                       "Barplot" = char_cols(),
                       "Scatterplot" = colnames(Dataset()))
        
        selectInput(inputId = "Ixval",
                    label = "X axis values",
                    choices = cols)
    })
    
    output$Oyval <- renderUI({req(input$Ifile)
        cols <- switch(input$Iplottype,
                       "Histogram" = NULL,
                       "Barplot" = NULL,
                       "Scatterplot" = colnames(Dataset()))
        
        selectInput(inputId = "Iyval",
                    label = "Y axis values",
                    choices = cols)
    })
    
    output$Oplotui <- renderUI({
        num_cols <- reactive(
            {
                colnames(
                    Dataset()[, sapply(Dataset(), is.numeric)]
                )}
        )
        
        char_cols <- reactive(
            {
                colnames(
                    Dataset()[,sapply(Dataset(), is.factor)]
                )}
        )
        
        X_cols <- switch(input$Iplottype,
                         "Histogram" = num_cols(),
                         "Barplot" = char_cols(),
                         "Scatterplot" = colnames(Dataset()))
        
        Y_cols <- switch(input$Iplottype,
                         "Histogram" = NULL,
                         "Barplot" = NULL,
                         "Scatterplot" = colnames(Dataset()))
        
        verticalLayout(selectInput(inputId = "Ixval2",
                              label = "X axis values",
                              choices = X_cols),
        selectInput(inputId = "Iyval2",
                              label = "Y axis values",
                              choices = Y_cols)
        )
    
})
})