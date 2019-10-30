library(shiny)
library(waiter)
library(grapher)

shiny::addResourcePath("assets", "./assets")

g <- get(load("./data/graph.RData"))

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
    div(
      class = "net",
      textInput("search", "Package"),
      graphOutput("g", height = "100vh")
    )
  )
)

server <- function(input, output, session){

  load("./data/graph.RData")
  
  observeEvent(input$submit, {
    updateTabsetPanel(session = session, inputId = "tabs", selected = "net")
  })

  output$g <- render_graph({
    hide_long_links(g, 100) %>% scale_node_size(in_degree, c(10, 150)) 
  })

  observeEvent(input$search, {
    graph_proxy("g") %>% 
      graph_focus_node(input$search)
  })
  
  hide_waiter()
}

shinyApp(ui, server)
