
library(tidyverse)
library(textdata)
library(lubridate)
library(sentometrics)


get_normalize = function(dataset, type = c('TESI', 'TEPU')){
  
  
  if (type == 'TESI'){
    dataset$SSN = ((dataset$sentiment - mean(dataset$sentiment)) / sd(dataset$sentiment))} 
  
  else if (type == "TEPU"){
    dataset$TEPU = ((dataset$TEPU - mean(dataset$TEPU)) / sd(dataset$TEPU))}
  
  else {
    paste("Escolha um tipo: TESI ou TEPU")
  }
  
  return(dataset)
  
}


get_resample = function(dataset, type =c('TESI', 'TEPU'),timer=c('weeek', 'month', 'quarter', 'year')){
  
  if (type == "TESI"){
    dataset <- dataset %>%
      mutate(date = floor_date(date, timer)) %>%
      group_by(date) %>%
      summarise(TESI_Z = mean(SSN, na.rm = TRUE))}
  
  else if (type == "TEPU"){
    dataset <- dataset %>%
      mutate(Data = floor_date(Data, timer)) %>%
      group_by(Data) %>%
      summarise(TEPU_Z = mean(TEPU, na.rm = TRUE))}
  
  else {
    paste("Seletione um tipo:  TESI ou TEPU")
  }
  
  return(dataset)
  
}