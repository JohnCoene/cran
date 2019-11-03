library(shiny)
library(waiter)
library(pushbar)
library(grapher)

shiny::addResourcePath("assets", "./assets")

code <- readLines("./script/script.R") %>% 
  paste0(collapse = "\n")

ui <- fluidPage(
  title = "CRAN Dependency Network",
  tags$head(
    tags$link( rel="stylesheet", type="text/css", href = "./assets/css/prism.css"),
    tags$link( rel="stylesheet", type="text/css", href = "./assets/css/styles.css")
  ),
  use_waiter(),
  pushbar_deps(),
  tags$script(src = "./assets/js/prism.js"),
  show_waiter_on_load(
    color = "#000",
    tagList(
      spin_folding_cube(),
      span("Loading dependency graph", style = "color:white;")
    )
  ),
  div(
    textInput("search", "Search a package"),
    graphOutput("g", height = "100vh"),
    actionLink("code", "", icon = icon("code fa-lg")),
    actionLink("about", "", icon = icon("question fa-lg"))
  ),
  pushbar(
    id = "code_bar",
    from = "left",
    class = "bars",
    h1("Source code"),
    style = "width:30%;",
    tags$pre(tags$code(class = "language-r", code))
  ),
  pushbar(
    id = "about_bar",
    class = "bars",
    from = "right",
    h1("CRAN Dependency Graph"),
    p("Each node is an R package on CRAN, connections represent dependencies."),
    p(
      "While all packages are visualised not all dependencies are, to avoid",
      "a hairball graph edges that are over a certain length are hidden. This",
      "allows keeping sight of smaller communities."
    ),
    p("You view the source used to build the visualisation", actionLink("code2", "here")),
    p("with 💕 by John Coene", id = "footer"),
    style = "width:30%;"
  ),
  hide_waiter_on_drawn("g")
)

server <- function(input, output, session){

  setup_pushbar()

  output$g <- render_graph({
    graph("./assets/data/graph.json")
  })

  observeEvent(input$search, {
    graph_proxy("g") %>% 
      graph_focus_node(input$search, dist = -40)
  })

  observeEvent(input$code, {
    pushbar_open(id = "code_bar")
  })

  observeEvent(input$code2, {
    pushbar_open(id = "code_bar")
  })

  observeEvent(input$about, {
    pushbar_open(id = "about_bar")
  })

}

shinyApp(ui, server)
