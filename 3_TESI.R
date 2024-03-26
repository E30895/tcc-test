
library(tidyverse)
library(textdata)
library(lubridate)
library(sentometrics)


get_tesi = function(dataset, how=c('proportional', 'proportionalPol', 'TFIDF')){
  
  dataset = data.frame(
    id = 1:dim(dataset)[1],
    date = dataset$Data,
    texts = dataset$Traducao) %>% 
    na.omit()
  
  l3 <- sento_lexicons(list_lexicons["LM_en"], list_valence_shifters[["en"]][, c("x", "t")])
  corpus <- sento_corpus(corpusdf = dataset, do.clean = T)
  sentiment_series <- compute_sentiment(corpus, l3, how = how, nCore = 4)
  
  sentiment_series <- sentiment_series %>%
    group_by(date) %>%
    summarise(sentiment = mean(`LM_en--dummyFeature`, na.rm = TRUE))
  
  return(sentiment_series)
}