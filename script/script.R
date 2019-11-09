
library(grapher)
library(tidygraph)

# get cran network data
deps <- cran_deps_graph(
  Inf, 
  format = "igraph",
  include_base_r = FALSE
)

# compute graph metrics
graph <- as_tbl_graph(deps) %>% 
  activate(nodes) %>% 
  mutate(
    in_degree = centrality_degree(mode = "in")
  )

# build and save graph
graph(graph) %>% 
  graph_offline_layout(steps = 75) %>% 
  hide_long_links(100) %>% 
  scale_node_size(in_degree, c(6, 50)) %>% 
  scale_link_color_coords(red = c(.1, 1)) %>%
  capture_node_click() %>%  
  save_graph_json("./assets/data/graph.json")
