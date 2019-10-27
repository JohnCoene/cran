library(rvest)
library(dplyr)

# get maintainers packages
html <- read_html("https://cran.r-project.org/web/checks/check_summary_by_maintainer.html#summary_by_maintainer")

table <- html %>% 
  html_nodes("table") %>% 
  html_table()

table <- tibble::as_tibble(table[[1]])

# fill blank
for(i in 1:nrow(table)){
  if(table$Maintainer[i] == ""){
    table$Maintainer[i] <- table$Maintainer[i - 1]
  }
}

# remove email
table$Maintainer <- gsub("<.*>", "", table$Maintainer)
table$Maintainer <- gsub("\"", "", table$Maintainer)
table$Maintainer <- gsub("\'", "", table$Maintainer)
table$Maintainer <- trimws(table$Maintainer)

table <- select(table, Maintainer, Package)

# packages
ig <- cran_deps_graph(
  Inf, deps = c("Imports"),
  include_base_r = FALSE
)

packages_authors <- inner_join(ig$nodes, table, by = c("id" = "Package"))
packages_links <- ig$links %>% 
  left_join(
    table, by = c("source" = "Package")
  ) %>% 
  left_join(
    table, by = c("target" = "Package")
  ) %>% 
  select(
    source = Maintainer.x,
    target = Maintainer.y
  ) %>% 
  count(source, target) %>% 
  filter(!is.na(source)) %>% 
  filter(!is.na(target))

packages_authors <- packages_authors %>% 
  select(id = Maintainer) %>% 
  count(id)

list(
  nodes = packages_authors,
  links = packages_links
) %>% 
  graph() %>% 
  scale_node_color(n) %>% 
  graph_stable_layout(ms = 10000)