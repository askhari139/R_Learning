#library(shiny)
ui <- fluidPage(
    fluidRow(
        column(3, "Hello"),
        column(4, "How are you")
    )
)
server <- function(input, output) {}

shinyApp(ui = ui, server = server)