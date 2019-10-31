library(shiny)
library(waiter)
library(grapher)

shiny::addResourcePath("assets", "./assets")

g <- get(load("./data/graph.RData"))

ui <- fluidPage(
  title = "CRAN Dependency Network",
  tags$head(
    tags$link( rel="stylesheet", type="text/css", href = "./assets/css/styles.css")
  ),
  use_waiter(),
  show_waiter_on_load(
    color = "#000",
    tagList(
      spin_folding_cube(),
      span("Loading dependency graph", style = "color:white;")
    )
  ),
  div(
    textInput("search", "Package"),
    graphOutput("g", height = "100vh")
  ),
  hide_waiter_on_drawn("g")
)

server <- function(input, output, session){

  output$g <- render_graph(g)

  observeEvent(input$search, {
    graph_proxy("g") %>% 
      graph_focus_node(input$search, dist = -20)
  })

}

shinyApp(ui, server)
