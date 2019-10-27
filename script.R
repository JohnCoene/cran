library(grapher)
library(tidygraph)

# get data
ig <- cran_deps_graph(
  Inf, deps = c("Imports"),
  format = "igraph",
  include_base_r = FALSE
)

# ig <- igraph::mst(ig)

graph <- as_tbl_graph(ig) %>% 
  activate(nodes) %>% 
  mutate(
    cluster = group_walktrap(),
    cluster = as.character(cluster),
    in_degree = centrality_degree(mode = "in")
  ) %>% 
  filter(in_degree >= 1)

# save
save(graph, file = "./data/graph.RData")

# test

g <- graph %>% 
  graph() %>% 
  scale_link_color(cluster) %>% 
  graph_stable_layout(ms = 25000) %>% 
  define_node_size(in_degree) %>% 
  scale_node_size(in_degree)

g
