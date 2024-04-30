

setwd('C:\\Users\\eusou\\OneDrive\\Documentos\\TCC\\10. Github Upload')
dataset = load('dataset_text.Rdata')
dataset  = dataset_merged_stationary

#ADICIONAR GRAFICOS OBSERVADO X PREVISTO

get_sarima = function(dataset, h){
  
  library(tidyverse)
  library(forecast)
  
  #Y = `BZEAMOM%`
  y <- dataset$`BZEAMOM%`

  n_available <- length(y)
  for_set <- seq(from = floor(0.75 * n_available), to = n_available)
  y_test = y[for_set]
  
  for_hor <- h #DEFINE O HORIZONTE
  n_train <- for_set[1] - for_hor # DEFINE O TAMANHO DO TREINO
  train_set <- seq(from = 1, to = n_train) #DEFINE AS LINHAS DE TREINO
  
  y_arima =  rep(NA, length(for_set))
  
  #ITERANDO PELAS JANELAS
  for (i in seq_along(for_set)) {
    y_train <- y[train_set] #PASSANDO OS DADOS DE TREINO
    
    reg_arima <- auto.arima(y = y_train, stepwise = F, approximation = F, stationary = T)
    for_arima_aux <- forecast(object = reg_arima, h = for_hor)
    
    y_arima[i] <- tail(for_arima_aux$mean, 1)
    
    train_set <- train_set + 1
    print(i / length(for_set))
    
    results = list(values = y_arima, accuary = accuracy(y_arima, x = y_test))

  }
  
  return (results)
  
}

sarima = get_sarima(dataset, h = 1)
sarima$values
sarima$accuary
