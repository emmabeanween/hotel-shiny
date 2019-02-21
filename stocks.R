

library(shiny)
library(shinythemes)
library(dplyr)


#not real data
dataset <- data.frame(AMZN = rnorm(365), GOOGLE = rnorm(365), APPL = rnorm(365), date = seq(as.Date("2018/2/7"),
                                                                                            by = "days", length.out = 365) )
ui <- fluidPage(theme = shinytheme("paper"),

  titlePanel("Stock Returns"),
  sidebarLayout(sidebarPanel(
    
    selectInput(inputId = "company", label = "Company", choices = c("AMZN", "GOOGLE", "APPL"))
    
  ),
                
          mainPanel(tabsetPanel(id = "tabs",
             tabPanel("weekly"), 
            tabPanel("monthly"), tabPanel("yearly")),
            
         plotOutput(outputId = "plot"))
  
))



server <- function(input, output) {
  
  stocks_subsetted <- reactive({
    stocks <- select(dataset, input$company, date )
    
    return(stocks)
  })
  

  stocks_filtered <- reactive({
   switch(input$tabs, weekly = filter(stocks_subsetted(), date >= as.Date("2019-02-07") - 7), 
          monthly = filter(stocks_subsetted(), date >= as.Date("2019-02-07") - 30),
          yearly = stocks_subsetted())
          
  })

  output$plot <- renderPlot({ plot(select(stocks_filtered(), input$company) %>% unlist() %>% as.vector(),
                                   type = "l", col = "black", xlab = input$company, ylab = "Returns")    })

  

}
  
shinyApp(ui = ui, server = server)

