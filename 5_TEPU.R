

library(tidyverse)
library(textdata)
library(lubridate)
library(sentometrics)

get_tepu = function(tokens, tepu_dict){
  
  dataset = dplyr::inner_join(
    x = tokens,
    y = tepu_dict) %>% 
    dplyr::group_by(Data, traducao) %>% 
    dplyr::count(sentimento)
  
  analise_sentimento = dataset %>% 
    tidyr::pivot_wider(
      id_cols = c("traducao", 'Data'),
      names_from = "sentimento",
      values_from = "n") %>% 
    group_by(Data) %>% 
    summarise(Noticias = n(),
              EPU = sum(!is.na(P) & !is.na(U))) %>% 
    mutate(TEPU = EPU/Noticias) %>% 
    arrange(Data)
  
}
