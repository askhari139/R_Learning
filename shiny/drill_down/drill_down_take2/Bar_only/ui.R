
shinyUI(
    dashboardPage(
        dashboardHeader(title = "Interactive plotting"),
        dashboardSidebar(
            fileInput(inputId = "Ifile",
                      label = "Insert File",
                      accept = ".csv"),
            checkboxInput("Iheader", "Header", TRUE),
            
            
            ###plot options
            uiOutput("Oplottype"),
            uiOutput("Oplotui"),
            fluidRow(column(width = 5, offset = 3, actionButton("Igoplt", "Plot")))
        ),
        dashboardBody(
            plotOutput("Oplot", click = "I1_click")
        )
    )
)
