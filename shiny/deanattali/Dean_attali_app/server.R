#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

bcl <- read.csv("C:/Users/Shrikishore.Hari/Desktop/R/shiny/deanattali/Dean_attali_app/bcl-data.csv",
                stringsAsFactors = FALSE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- bcl$Alcohol_Content
    bins <- seq(0, max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white', xlab = "Alcohol Content", 
         main = "Histogram of Alcohol content in BC liquor")
    
  })
  
  output$line <- renderPlot({
      x <- bcl$Price
      y <- bcl$Alcohol_Content
      xlims <- input$priceInput
      boxplot(x ~ y, col = "red", xlab = "Alcohol content", ylab = "Log of Price", 
           main = "Change of price w.r.t. alcohol content", xlim = xlims, log = "y")
      #abline(lm(x ~ y), col = "red")
  })
  
})
