
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
      sidebarPanel(
          fileInput(inputId = "Ifile",
                    label = "Upload file",
                    multiple = TRUE,
                    accept = ".csv"),
          checkboxInput(inputId = "Iheader",
                      label = "Header",
                      value = T),
          actionButton("go_btn", "Plot")
      ),
      mainPanel(
          tableOutput("Ofile")
      )
  ),
  
  splitLayout(#"Plotting",
      
      uiOutput("Oprim_ui"),
      uiOutput("Osec_ui")
                     
     
  )
))
