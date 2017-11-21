shinyServer(function(input, output, session) {
    Dataset <- reactive(read.csv(input$Ifile$datapath, header = input$Iheader))
    
    output$Oplottype <- renderUI({
        req(input$Ifile)
        selectInput(inputId = "Iplottype",
                    label = "Plot type",
                    choices = c("Barplot", "Scatterplot", "Histogram"))
    })
    
    Plot <- eventReactive(input$Igoplt,
                          {
                              req(input$Ifile)
                              p <- NULL
                              switch(input$Iplottype,
                                     "Histogram" = {
                                         p <- ggplot(data = Dataset(), aes_string(x = input$Ixval)) +
                                             geom_histogram() + labs(x = input$Ixval, y = "Frequency")
                                     },
                                     "Barplot" = {
                                         p <- ggplot(data = Dataset(), aes_string(x = input$Ixval)) +
                                             #geom_bar_interactive(tooltip = sort(unique(Dataset()[, input$Ixval]))) +
                                             geom_bar()+ labs(x = input$Ixval, y = "Frequency")
                                     },
                                     "Scatterplot" = {
                                         p <- ggplot(data = Dataset(), aes_string(x = input$Ixval, y = input$Iyval))+
                                             # geom_point_interactive(aes_string(y = input$Iyval), 
                                             #                       tooltip = rownames(Dataset()) ) + 
                                             geom_point()+ labs(x = input$Ixval, y = input$Iyval)
                                     })
                              p + theme_hc() + scale_color_hc()
                          })
    
    output$Oplot <- renderPlot({
        Plot()
    })
    
    output$Oplotui <- renderUI({req(input$Ifile)
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
        
        verticalLayout(selectInput(inputId = "Ixval",
                                   label = "X axis values",
                                   choices = X_cols),
                       selectInput(inputId = "Iyval",
                                   label = "Y axis values",
                                   choices = Y_cols)
        )
        
    })
    
})

