sec_plot <- function(input, output, session, Dataset){
output$Oplot2 <- renderPlot({
    req(input$Ifile)
    flt <- Dataset()
    lvs <- "yo"
    if(!is.null(input$Iplot_click))
    {
        lvs <- sort(levels(Dataset()[, input$Ixval]))[round(input$Iplot_click$x)]
        flt <- dplyr::filter(Dataset(), eval(parse(text = input$Ixval)) == lvs)
    }
    switch(input$Iplottype2,
           "Histogram" = {
               p <- ggplot(data = flt, aes_string(x = input$Ixval2)) +
                   geom_histogram() + labs(x = input$Ixval2, y = "Frequency")
           },
           "Barplot" = {
               p <- ggplot(data = flt, aes_string(x = input$Ixval2)) +
                   #geom_bar_interactive(tooltip = sort(unique(Dataset()[, input$Ixval]))) +
                   geom_bar()+ labs(x = input$Ixval2, y = "Frequency")
           },
           "Scatterplot" = {
               p <- ggplot(data = flt, aes_string(x = input$Ixval2))+
                   # geom_point_interactive(aes_string(y = input$Iyval),
                   #                       tooltip = rownames(Dataset()) ) +
                   geom_point(y = input$Iyval2)+ labs(x = input$Ixval2, y = input$Iyval2)
           })
    p + theme_hc()+ scale_color_hc()
})

}

sec_plot_ui <- function(input, output, session, Dataset){
    output$Osec_plot <- renderUI({
        req(input$Ifile)
        Dat <- Dataset()
        if(!is.null(input$Iplot_click))
        {
            x <- colnames(Dataset())
            x <- x[-which(x==input$Ixval)]
            Dat <- Dataset()[, x]
        }
        num_cols <- reactive(
            {
                colnames(
                    Dat[, sapply(Dat, is.numeric)]
                )}
        )

        char_cols <- reactive(
            {
                colnames(
                    Dat[,sapply(Dat, is.factor)]
                )}
        )

        X_cols <- switch(input$Iplottype2,
                         "Histogram" = num_cols(),
                         "Barplot" = char_cols(),
                         "Scatterplot" = colnames(Dat))

        Y_cols <- switch(input$Iplottype2,
                         "Histogram" = NULL,
                         "Barplot" = NULL,
                         "Scatterplot" = colnames(Dat))

        verticalLayout(selectInput(inputId = "Ixval2",
                              label = "X axis values",
                              choices = X_cols),
                  selectInput(inputId = "Iyval2",
                              label = "Y axis values",
                              choices = Y_cols),
                  plotOutput("Oplot2"))
    
})
}