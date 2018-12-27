#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
book_button <- submitButton(text = "Book Now", width=100)
date_input_arrival <- dateInput(format = "mm-dd-yyyy", label = "Pick your arrival", inputId= "arrival")
date_input_departure <- dateInput(format = "mm-dd-yyyy", label = "Pick your departure", inputId = "departure")
list_rooms <- c("San Francisco Suite", "Philly Penthouse", "One Queen in Queens", "Two Twin Toronto", "Kansas King")
select <- selectInput("roomselect", "Select a room", list_rooms)
select_package <- selectInput("package", "Pick your package", c("SF Two Nights", "Week Long Spa", "Couples Queen"))
description <- "The R Hotel is a fictional reality created for the purpose of practicing Shiny."
tab_panel <- tabsetPanel(tabPanel(title = "Book", date_input_arrival, date_input_departure, select, book_button), 
tabPanel("Packages", fluidRow(DT::dataTableOutput("table", width="60%", height = "auto")), select_package, book_button), tabPanel("About", description))
title_panel <- titlePanel("R Hotel")
descriptions <- c("2 Nights in the SF Suite, 3rd Night Free", "Week Long Stay with All-Inclusive Spa Package", 
                  "Couples Deal With Two Meals in our City Restaurant, One Queen Room")
dates <- c("Now", "January 1st, 2019", "December 25th, 2018")
price <- c("$700", "$600", "$550")
package_table <- data.frame(descriptions, dates, price)
names(package_table) <- c("Deal", "Date Beginning", "Starting Price")
ui <- fluidPage(theme = shinytheme("cyborg"), title_panel, tab_panel)
server <- function(input, output){ output$table <- DT::renderDataTable(DT::datatable({return(package_table)}))}
shinyApp(ui, server)





# Run the application 
shinyApp(ui = ui, server = server)

