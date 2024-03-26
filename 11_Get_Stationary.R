
library(tidyverse)
library(textdata)
library(lubridate)
library(sentometrics)
library(ipeadatar)


get_stationarity = function(dataset){
  
  "
  Essa função verificar o conjunto de dados no dataframe para testar a estacionariedade
  via Teste Augmented Dickey-Fuller (ADF)
  
  Parametros: dataset
  "

  results = list()
  suport_df = data.frame(Serie = character(), ndiffs = integer())
  
  # Loop através de cada coluna do dataframe
  for (col_name  in names(dataset)){
    serie = dataset[[col_name]]
    
    #Realizando o teste ADF (Questionar ao Hudson)
    adf_test = forecast::ndiffs(serie, alpha = 0.05, test = 'adf')
    
    temp_df = data.frame(Serie = col_name, ndiffs = adf_test)
    suport_df = rbind(suport_df, temp_df)
    
    #Iterando para realizar o número de diferenças necessárias
    if (adf_test !=0){
      diff_serie = serie
      
      for (i in 1:adf_test){
        diff_serie = diff(diff_serie)
      }
      
      results[[col_name]] = diff_serie
      
    } else {
      
      results[[col_name]] = serie
      
    }
  }
  
  return(list(results = results, ndiffs = suport_df))
  
}


