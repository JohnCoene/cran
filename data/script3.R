library(dplyr)

deps <- purrr::map_dfr(row.names(installed.packages()), function(x){
  deps <- tryCatch(itdepends::dep_usage_pkg(x) %>% 
    count(pkg),
    error = function(e) e
  )
  if(inherits(deps, "error"))
    return(tibble::tibble())
  deps$source <- x
  return(deps)
})

library(grapher)

graph() %>% 
  graph_links(deps, source, pkg) %>% 
  graph_static_layout(scaling = c(-200, 200))