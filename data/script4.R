library(rvest)
library(dplyr)
library(gensimr)

html <- read_html("https://cran.r-project.org/web/packages/available_packages_by_name.html")

table <- html %>% 
  html_node("table") %>% 
  html_table(fill = TRUE)

tab <- table %>%
  purrr::set_names(c("pkg", "desc")) %>% 
  slice(2:n()) 

my_env <- "./env"
reticulate::use_virtualenv(my_env)

docs <- prepare_documents(tab, desc, pkg, return_doc_id = TRUE)
remaining_pkgs <- names(docs)

dictionary <- corpora_dictionary(docs)
corpus_bow <- doc2bow(dictionary, docs)

corpus_mm <- serialize_mmcorpus(corpus_bow, auto_delete = TRUE)

tfidf <- model_tfidf(corpus_mm)

corpus_transformed <- wrap(tfidf, corpus_bow)
lda <- model_lda(corpus_transformed, id2word = dictionary, num_topics = 20L)
lda_topics <- lda$get_document_topics(corpus_bow)
wrapped_corpus_docs <- get_docs_topics(lda_topics)

delete_mmcorpus(corpus_mm)