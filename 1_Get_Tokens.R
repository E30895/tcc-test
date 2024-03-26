
library(tidyverse)
library(textdata)
library(lubridate)
library(sentometrics)


get_tokens = function(dataset) {
  
  tokens = dataset %>% 
    mutate(traducao = Traducao) %>% 
    select(-c('endereco', 'Texto', 'Num_Palavras-Chave')) %>% 
    tidytext::unnest_tokens(output = 'token', input = 'Traducao', token = 'words')

  
  return(tokens)
}

