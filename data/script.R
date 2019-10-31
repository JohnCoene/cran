library(grapher)
library(tidygraph)

# get data
ig <- cran_deps_graph(
  Inf, 
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
  )

# test
g <- graph %>% 
  graph() %>% 
  scale_link_color(cluster, palette = graph_palette_light()) %>% 
  graph_offline_layout(steps = 250) %>% 
  define_node_size(in_degree) %>% 
  scale_node_size(in_degree, c(50, 120)) 

l <- compute_links_length(g)

g <- hide_long_links(g, 100) %>% scale_node_size(in_degree, c(10, 120)) 

save(g, file = "graph.RData")
