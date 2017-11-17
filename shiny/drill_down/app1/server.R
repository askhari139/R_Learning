source("Sec_plot.R")

shinyServer(function(input, output, session) {
    Dataset <- reactive(read.csv(input$Ifile$datapath, header = input$Iheader))
    output$Ofile <- renderTable(
        {
            req(input$Ifile)
            head(Dataset())
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
        
        verticalLayout(selectInput(inputId = "Ixval",
                                   label = "X axis values",
                                   choices = X_cols),
                       selectInput(inputId = "Iyval",
                                   label = "Y axis values",
                                   choices = Y_cols)
        )
    })
    
    
    output$Oplot <- renderPlot({
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
    x <- eventReactive({input$go_btn 
                        input$mkprim}, {
        
        verticalLayout(
            h3("Primary Plot"),
            selectInput(inputId = "Iplottype",
                        label = "Plot type",
                        choices = c("Barplot", "Scatterplot", "Histogram")),
            uiOutput("Oplotui"),
            plotOutput("Oplot", click = "Iplot_click"))
    })
    
    output$Oprim_ui <- renderUI({x()})
    
    
    sec_plot_ui(input, output, session, Dataset)
    sec_plot(input, output, session, Dataset)
    output$Osec_ui <- renderUI({
        if(!is.null(input$Iplot_click))
        {
            lvs <- sort(levels(Dataset()[, input$Ixval]))[round(input$Iplot_click$x)]
            verticalLayout(
                h3(paste(input$Ixval, lvs, sep = " - ")),
                selectInput(inputId = "Iplottype2",
                                       label = "Plot type",
                                       choices = c("Barplot", "Scatterplot", "Histogram")),
                           uiOutput("Osec_plot"),
                actionLink("mk_prim", "Make this plot primary"))
        }
    })
    
    observeEvent(input$mk_prim, {
        lvs <- sort(levels(Dataset()[, input$Ixval]))[round(input$Iplot_click$x)]
        Dataset <- dplyr::filter(Dataset(), eval(parse(text = input$Ixval)) == lvs)
    })
   
})

