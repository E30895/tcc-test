
setwd('C:\\Users\\eusou\\OneDrive\\Documentos\\TCC\\10. Github Upload')
dataset = load('dataset_text.Rdata')
dataset  = dataset_merged_stationary

get_boosting = function(dataset, h){
  
  library(mboost)
  library(forecast)
  
  set.seed(100)
  #Y = `BZEAMOM%`
  y = dataset$`BZEAMOM%`
  x = dataset
  x$`BZEAMOM%` = NULL 
  
  n_available = length(y)
  for_set = seq(from = floor(0.75 * n_available), to = n_available)
  y_test = y[for_set]
  
  for_hor = h #DEFINE O HORIZONTE
  n_train = for_set[1] - for_hor # DEFINE O TAMANHO DO TREINO
  train_set = seq(from = 1, to = n_train) #DEFINE AS LINHAS DE TREINO
  test = 1
  
  y_boosting =  rep(NA, length(for_set))
  
  for (i in seq_along(for_set)) {
    
    y_train = y[train_set] #PASSANDO O Y DE TREINO
    x_train = x[train_set,] #PASSANDO O X DE TREINO
    
    x_test = x[n_train+test,] #QUESTIONAR O HUDSON
    
    reg_full = glmboost(
      y =  y_train,
      x = as.matrix(x_train),
      offset = 0,
      center = TRUE,
      control = boost_control(mstop = 100, nu = 0.1)
    )
    
    cv10f = cv(model.weights(reg_full), type = "kfold", B = 5)
    cv_seq = cvrisk(reg_full, folds = cv10f, papply = lapply)
    m_opt =  mstop(cv_seq)
    
    reg_opt = glmboost(
      y =  y_train,
      x = as.matrix(x_train),
      offset = 0,
      center = TRUE,
      control = boost_control(mstop = m_opt, nu = 0.1)
    )
    
    opt_boosting = predict.glmboost(reg_opt, newdata = as.matrix(x_test)) %>% 
      as.vector()
    
    y_boosting[i] = tail(opt_boosting, 1)
    
    train_set = train_set + 1
    test = test + 1
    
    print(i / length(for_set))
    
  }
  
  results = list(values = y_boosting, accuracy = accuracy(y_boosting, x = y_test))
  return(results)
}



boosting = get_boosting(dataset, 1)
boosting$values
boosting$accuracy


