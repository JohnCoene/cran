
library(grapher)
library(tidygraph)

# get cran network data
ig <- cran_deps_graph(
  Inf, 
  format = "igraph",
  include_base_r = FALSE
)

# compute graph metrics
graph <- as_tbl_graph(ig) %>% 
  activate(nodes) %>% 
  mutate(
    cluster = group_walktrap(),
    cluster = as.character(cluster),
    in_degree = centrality_degree(mode = "in")
  )

# build and save graph
graph %>% 
  graph() %>% 
  scale_link_color(cluster, palette = graph_palette()) %>% 
  graph_offline_layout(steps = 1000) %>% 
  define_node_size(in_degree) %>% 
  hide_long_links(100) %>% 
  scale_node_size(in_degree, c(10, 70)) %>% 
  save_graph_json("./assets/data/graph.json")
