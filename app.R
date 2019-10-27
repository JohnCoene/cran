library(shiny)
library(waiter)
library(grapher)

shiny::addResourcePath("assets", "./assets")

ui <- navbarPage(
  "grapher",
  header = tags$head(
    tags$link( rel="stylesheet", type="text/css", href = "./assets/css/styles.css")
  ),
  id = "tabs",
  tabPanel(
    "Home",
    use_waiter(),
    show_waiter_on_load(
      color = "#000",
      waiter::spin_folding_cube()
    ),
    div(
      id = "home",
      h1("grapher"),
      actionButton("submit", "View CRAN network")
    )
  ),
  tabPanel(
    "net",
    graphOutput("g")
  )
)

server <- function(input, output, session){
  
  observeEvent(input$submit, {
    updateTabsetPanel(session = session, inputId = "tabs", selected = "net")
  })
  
  hide_waiter()
}

shinyApp(ui, server)
