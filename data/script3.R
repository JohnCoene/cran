library(dplyr)

pkgs <- available.packages() %>% 
  tibble::as_tibble()

deps <- purrr::map_dfr(pkgs$Package, function(x){
  deps <- itdepends::dep_usage_pkg(x) %>% 
    count(pkg)
  deps$source <- x
  return(deps)
})
