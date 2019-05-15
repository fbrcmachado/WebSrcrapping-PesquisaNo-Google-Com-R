library(rvest)
library(dplyr)
library(tibble)

google_url <- "www.google.com"
item_search <- "Col�gio Farias Brito"
google_session <- html_session(google_url)
google_form <- html_form(google_session)[[1]]
google_form <- set_values(google_form, 
                          'q' = item_search)

google_session <- submit_form(session = google_session, 
                              form    = google_form,
                              submit  = "btnG")



data_resultados <- data_frame()
for(i in 1:10){
  
  print(i)
  
  # Coletando os nodes dos resultados
  nodes_resultados <- html_nodes(google_session, xpath = "//h3/a")
  
  # Raspando títulos e links
  titulos <- html_text(nodes_resultados)
  links   <- html_attr(nodes_resultados, name = "href") %>% 
    paste0("https://www.google.com", .)
  
  # Compilando os resultados num data frame
  data_resultados <- bind_rows(data_resultados,
                               data_frame(titulos, links))
  
  # Navegando até a próxima página
  google_session <- follow_link(google_session, xpath = '//span[text()="Mais"]/..')
  
  # Um tempinho para o navegador respirar, carregar a página (e o Google não nos 
  # bloquear por excesso de requições)
  Sys.sleep(.5)
  
}

view(data_resultados)
