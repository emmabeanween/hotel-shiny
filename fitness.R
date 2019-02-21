

library(shiny)


ui <- fluidPage(theme = shinytheme("superhero"),
  
   titlePanel("BMI Calculator"),
   mainPanel(
     tabsetPanel(
     tabPanel("BMI",
     selectInput(inputId = "feet", label = "Height (feet)", choices = c(2, 3, 4, 5, 6, 7, 8), selected = 5),
     selectInput(inputId = "inches", label = "Height (inches)", choices = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11), selected = 4),
     textInput(inputId = "pounds", label = "Weight (in pounds) ", value = "140"),
     actionButton(inputId = "calculate", label = "Calculate"),
     textOutput(outputId = "bmi")),
     tabPanel("HR",
       sliderInput(inputId = "heartrate", label = "Heart Rate" , min = 30, max=200, value = 70),
       actionButton(inputId = "calculatehr", label = "Add" ), 
       
       fluidRow(
                            splitLayout(cellWidths = c("50%", "50%"), plotOutput(outputId = "hrgraph", width = "300px", height
                                                                                     = "250px"),
                                DT::dataTableOutput(outputId = "hrtable")        )
                          )
       
   
      
     ))
      
                      
 
))
server <- function(input, output) {
  hr <- c()
  valueshr <- data.frame(Time = numeric(0), HR = numeric(0))
 
 height <- eventReactive(input$calculate, {
    ((as.integer(input$feet) * 12 + as.integer(input$inches)) * 0.025) ^2
  })

 weight <- eventReactive(input$calculate, {
   (as.integer(input$pounds) * 0.45)
 }) 

 
output$bmi <- renderText(paste("Your BMI is:", round(weight()/height(), 2), sep = "\t"))



actual_hr <- eventReactive(input$calculatehr, {
  hr <<- append(hr, input$heartrate)
  return(hr)
  
})




actual_hr_table <- eventReactive(input$calculatehr, {
  
    valueshr[nrow(valueshr) + 1,] <<-  list(format(Sys.time(), "%a %b %d %X %Y"), input$heartrate)
    colnames(valueshr) <<- c("Time", "HR")
    return(valueshr)
  
})

output$hrgraph <- renderPlot({
  
   if (length(actual_hr()) > 1){
     plot(actual_hr(), col = "red", type = "line", xlab = "Input", ylab = "Heart Rate")
   }
})

output$hrtable <- DT::renderDataTable(actual_hr_table())

}
shinyApp(ui = ui, server = server)

