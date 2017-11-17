library(shiny)

ui <- fluidPage(
    h1("Example app"),
    sidebarLayout(
        sidebarPanel(
            numericInput("nrows", "Number of rows", 10)
        ),
        mainPanel(
            plotOutput("plot"),
            tableOutput("table")
        )
    )
)

server <- function(input, output, session) {
    # Assignment: Factor out the head(cars, input$nrows) so
    # that the code isn't duplicated and the operation isn't
    # performed twice for each change to input$nrows.
    
    df <- reactive({
        head(cars, input$nrows)
    })
    
    output$plot <- renderPlot({
        plot(df())
    })
    
    output$table <- renderTable({
        df()
    })
}

shinyApp(ui, server)