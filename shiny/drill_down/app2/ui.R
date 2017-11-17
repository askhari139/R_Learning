
shinyUI(
    dashboardPage(
        dashboardHeader(title = "Interactive plotting"),
        dashboardSidebar(
            fileInput(inputId = "Ifile",
                      label = "Insert File",
                        accept = ".csv"),
            checkboxInput("Iheader", "Header", TRUE),
            
            
            ###plot options
            selectInput(inputId = "Iplottype",
                        label = "Plot type",
                        choices = c("Barplot", "Scatterplot", "Histogram")),
            # uiOutput("Oxval1"),
            # uiOutput("Oyval1"),
            uiOutput("Oplotui"),
            fluidRow(column(width = 5, offset = 3, actionButton("Igoplt", "Plot")))
        ),
        dashboardBody(
            ggiraphOutput("Oplot")
        )
    )
)
