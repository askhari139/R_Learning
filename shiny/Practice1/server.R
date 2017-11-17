library(shiny)

shinyServer(function(input, output) {#browser()
    #data(mtcars)
    
    ###########################file input window################################ 
    file_data <- reactive({read.csv(input$file1$datapath,
                                    header = input$header,
                                    sep = input$sep,
                                    quote = input$quote)})
    output$dataHead <- renderTable({
        req(input$file1)
        if (input$disp == "Head") {
            return(head(file_data(), input$numRows))
        }
        else
        {return(file_data())}
    })
    
    ##########################plot window#######################################
    numerics <- reactive({colnames(file_data()[sapply(file_data(), is.numeric)])})
    #chars <- reactive({colnames(file_data()[sapply(file_data(), is.character)])})
    
    ## UI for the plot type
    output$plotType <- renderUI({
        #req(input$file1)
        selectInput(inputId = "plotType", label = "Type of plot",
                    choices = c(Scatterplot = "geom_point(aes_string(input$x, input$y))",
                                Hisogram = "geom_histogram(aes_string(input$x))",
                                Boxplot = "geom_boxplot(aes(x = factor(eval(parse(text = input$x)))
                                , y = eval(parse(text = input$y))))",
                                Bargraph = "geom_bar(aes_string(input$x))"
                    )) #the geom elements of each plot are included as the values of each choice 
        #for ease of access
    })
    
    ##UI for axes selection 
    output$x <- renderUI({
        #req(input$file1)
        if(input$plotType == "geom_histogram(aes_string(input$x))")
            choice <- numerics()
        else
            choice <- colnames(file_data())
        selectInput(inputId = "x", label = "Abscissa",
                    choices = choice)
    })
    output$y <- renderUI({
        #req(input$file1)
        if(input$plotType == "geom_histogram(aes_string(input$x))" ||
           input$plotType == "geom_bar(aes_string(input$x))")
            choice <- "Frequency"
        else
            choice <- colnames(file_data())
        selectInput(inputId = "y", label = "Ordinate",
                    choices = choice)
    })
    
    
    
    ## The plot
    plt <- eventReactive(input$plotIt, {
        p <- ggplot(data = file_data()) + eval(parse(text = input$plotType)) +
            labs(title = input$plotLabel, x = input$x, y = input$y)
        if(input$plotType == "geom_point(aes_string(input$x, input$y))" 
           && input$line) 
        {p <- p + geom_smooth(method = "lm", aes_string(input$x, input$y))}
        p                         
    })
    output$plot <- renderPlot({
        
        p <- ggplot(data = file_data()) + eval(parse(text = input$plotType)) +
            labs(title = input$plotLabel, x = input$x, y = input$y)
        if(input$plotType == "geom_point(aes_string(input$x, input$y))" 
           && input$line) 
        {p <- p + geom_smooth(method = "lm", aes_string(input$x, input$y))}
        p
        
    })
    
    ## UI for the plot window
    plotWinTit <- eventReactive(input$proceed, 
                                {HTML("<center><h3>Interactive Plot window</h3></center>")})
    output$plotWindowTitle <- renderUI(plotWinTit()) 
    
    plotWin <- eventReactive(input$proceed,{ 
        sidebarLayout(
            sidebarPanel(
                uiOutput("plotType"),
                uiOutput("x"),
                uiOutput("y"),
                conditionalPanel(
                    condition = 
                        "input.plotType == 'geom_point(aes_string(input$x, input$y))'",
                    checkboxInput(inputId = "line", label = "Add best fit line")
                ),
                actionButton("plotIt", "Plot"),
                checkboxInput("save", "Save the Plot"),
                conditionalPanel(
                    condition = "input.save",
                    selectInput("imgFormat", "Image Format", 
                                choices = c(PNG = ".png",
                                            JPEG = ".jpeg",
                                            TIFF = ".tiff",
                                            PDF = ".pdf")),
                    textInput("imgName", "Filename"),
                    downloadButton("saveImage", "Save")
                    
                ),
                textOutput("fileName")
                
            ),
            mainPanel(
                textInput(inputId = "plotLabel", label = "Title for the plot"),
                plotOutput("plot")
            )
        )
    }  
    )
    
    output$plotWindow <- renderUI(plotWin())
    
    ###########################Plot Download####################################
    output$saveImage <- downloadHandler(
        filename =  function() {
            paste(input$imgName, input$imgFormat, sep = "")
        },
        # content is a function with argument file. content writes the plot to the device
        content = function(file) {
            if(input$imgFormat == ".png")
                png(file) # open the png device
            else if(input$imgFormat == ".jpeg")
                jpeg(file)
            else if(input$imgFormat == ".tiff")
                tiff(file)
            else if(input$imgFormat == ".bmp")
                bmp(file)
            else
                pdf(file) # open the pdf device
            print(plt()) #draw the plot
            dev.off()  # turn the device off
            
        }
    )
    
})

