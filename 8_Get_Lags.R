library(tidyverse)
library(textdata)
library(lubridate)
library(sentometrics)


get_lags = function(dataset, num_lags){

  "
  UPDATES 29/04/2024:
  A função foi adaptada para ficar apenas com os LAGS.
  "

  variaveis = colnames(dataset)

  for (var in variaveis) {
    
    for (lag in 1:num_lags) {
      lag_name = paste0("lag", lag, "_", var)
      
      dataset = dataset %>%
        mutate(!!lag_name := lag(!!sym(var), lag))
    }
  }
  
  dataset = dataset %>% select(contains("lag")) #ADICIONADO EM 29/04/2024
  
  return(dataset)
}