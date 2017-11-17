
library(shiny)
library(datasets)

ui <- fluidPage(
    h1("Example app"),
    sidebarLayout(
        sidebarPanel(
            numericInput("nrows", "Number of rows", 10)
        ),
        mainPanel(
            plotOutput("plot")
        )
    )
)

server <- function(input, output, session) {
    # Assignment: Plot the first input$nrows columns of a
    # data frame of your choosing, using head() and plot()
    data("cars")
    output$plot <- renderPlot({plot(head(cars, input$nrows))})
    
}

shinyApp(ui, server)