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

# save
save(graph, file = "./graph.RData")

# test
g <- graph %>% 
  graph() %>% 
  scale_link_color(cluster) %>% 
  graph_static_layout(scaling = c(-5000, 5000)) %>% 
  define_node_size(in_degree) %>% 
  scale_node_size(in_degree, c(30, 120)) 

l <- compute_links_length(g)

hide_long_links(g, 400)
