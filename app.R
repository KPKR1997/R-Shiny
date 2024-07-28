library(shiny)
library(shinythemes)
library(e1071)

# Load the data
data <- read.csv("film_genre_data.csv")

# Ensure the FilmGenre column is treated as a factor
data$FilmGenre <- as.factor(data$FilmGenre)

# Train a Naive Bayes model
nb_model <- naiveBayes(FilmGenre ~ ., data = data)

# Define the UI
ui <- fluidPage(
  theme = shinytheme("cerulean"),
  
  titlePanel("Film Genre Prediction"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("sex", "Sex:", choices = c("Male", "Female")),
      selectInput("employed", "Employed:", choices = c("Yes", "No")),
      selectInput("adult", "Adult:", choices = c("Yes", "No")),
      selectInput("artistic", "Artistic:", choices = c("Yes", "No")),
      actionButton("predict", "Predict Film Genre")
    ),
    mainPanel(
      textOutput("prediction")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  observeEvent(input$predict, {
    new_data <- data.frame(
      Sex = input$sex,
      Employed = input$employed,
      Adult = input$adult,
      Artistic = input$artistic
    )
    
    prediction <- predict(nb_model, new_data)
    output$prediction <- renderText({ paste("Predicted Film Genre:", prediction) })
  })
}

# Run the application
shinyApp(ui = ui, server = server)
