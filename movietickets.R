
library(shiny)
library(shinythemes)

ui <- fluidPage(theme = shinytheme("united"),
  
titlePanel("Book Tickets"),
sidebarLayout(
  
  sidebarPanel(htmlOutput(outputId = "prices")),
  mainPanel(
    selectInput(inputId = "movie", label = "Pick your movie", choices = c("Charlie and the Chocolate Factory",
                                              "The Devil Wears Prada", "Passengers", "Mission Impossible" )),
    dateInput(inputId = "date", label = "Pick your movie time", value= Sys.Date(), min = Sys.Date() , 
              max = Sys.Date() + 7, format = "mm-dd-yyyy"),
    numericInput(inputId = "number", label = "number of tickets", value=2, min=1, max=5),
    uiOutput(outputId = "selectinput"),
    actionButton(inputId = "tix", label = "Get Tickets"),
    htmlOutput(outputId = "total")
    
  )
  
  
)
  
)
   

server <- function(input, output) {

output$prices <- renderText({ paste("<b>Adult.........$5.50", "</b>", "</br>", "<b> Child........$3.00"
                                    , "</br>", "Senior........$4.00")   })
  
labels <- c("first ticket", "second ticket", "third ticket", "fourth ticket", "fifth ticket")
my_list <- reactive({
  
  this_list <- list()
  for (i in 1:input$number){
    
    this_list[[i]] <- selectInput(paste0("fare", i), labels[[i]], c("Adult", "Child", "Senior"))
    
  }
  
  return(this_list)
  
})

output$selectinput <- renderUI(my_list())


total <- eventReactive(input$tix, {
  
  vec <- c()
  for (i in 1:length(my_list())){
    value <-  input[[paste0("fare", i)]]
    final <- switch(value, Adult = 5.50, Child = 3.00, Senior = 4.00)
    vec <- append(vec, final)
  }
  return(sum(vec))
  
  
})

movie <- eventReactive(input$tix, {
  
  return(input$movie)
  
})

output$total <- renderUI({
  HTML( paste("Tickets booked for : ", "<b><br>", movie(), "</b> <br>", "Your total ticket cost is</br>",
               "<b>", "$", total(), "</b>"))
  
})

}

shinyApp(ui = ui, server = server)