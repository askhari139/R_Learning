server <- function(input, output) {
    output$distPlot <- renderPlot({
        
        # Take a dependency on input$goButton
        input$goButton
        
        # Use isolate() to avoid dependency on input$obs
        dist <- isolate({
            #set.seed(input$obs)
            rnorm(input$obs)})
        #dist <- rnorm(input$obs)
        hist(dist)
    })
    
    output
}