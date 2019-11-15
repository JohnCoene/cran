library(shiny)
library(waiter)
library(pushbar)
library(grapher)

shiny::addResourcePath("assets", "./assets")

code <- readLines("./script/script.R") %>% 
  paste0(collapse = "\n")

load("pkgs.RData")

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
    dqshiny::autocomplete_input("search", "Package", pkgs, placeholder = "e.g.: dplyr, data.table"),
    graphOutput("g", height = "100vh"),
    uiOutput("clicked"),
    div(
      id = "buttons",
      actionLink("code", "", icon = icon("code fa-lg")),
      actionLink("about", "", icon = icon("question fa-lg"))
    )
  ),
  pushbar(
    id = "code_bar",
    from = "left",
    class = "bars",
    h1("Source code"),
    p(
      "The visualisation is powered by the",
      tags$a("grapher package", href = "https://grapher.network/")
    ),
    style = "width:30%;",
    tags$pre(tags$code(class = "language-r", code))
  ),
  pushbar(
    id = "about_bar",
    class = "bars",
    from = "right",
    h1("CRAN Dependency Graph"),
    p(
      "Each node is an R package on CRAN, connections represent dependencies",
      tags$code("Depends", class = "language-r"), tags$code("Imports", class = "language-r"), 
      "and", tags$code("LinkingTo.", class = "language-r")
    ),
    p(
      "You can navigate the graph with the", tags$kbd("w"), tags$kbd("a"), 
      tags$kbd("s"), tags$kbd("d"), "and the arrow keys (",
      tags$kbd(HTML("&larr;")), tags$kbd(HTML("&uarr;")), tags$kbd(HTML("&rarr;")), 
      tags$kbd(HTML("&darr;")), ") to rotate the camera", tags$kbd("a"), tags$kbd("e"), 
      "will rotate it."
    ),
    p("Click on a node to reveal more information about it."),
    p("Type the name of a package in the search box in the top left corner to zoom in on it."),
    p(
      "While all packages are visualised not all dependencies are, to avoid",
      "a hairball graph edges that are over a certain length are hidden. This",
      "allows keeping sight of smaller communities."
    ),
    p("You view the source used to build the visualisation", actionLink("code2", "here")),
    p(tags$a("with 💕 by John Coene", id = "footer", href = "https://john-coene.com")),
    style = "width:30%;"
  ),
  hide_waiter_on_drawn("g"),
  tags$script(src = "./assets/js/mobile.js"),
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

  focus <- reactiveValues(pkg = NULL)

  observeEvent(input$g_node_click, {
    focus$pkg <- input$g_node_click
  })

  observeEvent(input$g_retrieve_node, {
    focus$pkg <- input$g_retrieve_node
  })

  observeEvent(input$search, {
    graph_proxy("g") %>% 
      retrieve_node(input$search)
  })

  output$clicked <- renderUI({
    sel <- focus$pkg

    if(is.null(sel))
      return(span())

    deps <- sel$links %>% 
      dplyr::filter(fromId != sel$id) %>% 
      nrow()

    tagList(
      strong(sel$id, style = "color:white;"),
      br(),
      span("Reverse Dependencies:", prettyNum(deps, big.mark = ","),  style = "color:white;")
    )
  })

  observeEvent(input$screen_width, {
    if(input$screen_width < 760)
      showModal(
        modalDialog(
          title = NULL,
          "Apologies, this website is only available on desktop 🖥️",
          footer = NULL,
          fade = FALSE
        )
      )
  })

}

shinyApp(ui, server)
