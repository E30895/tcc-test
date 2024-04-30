setwd('C:\\Users\\eusou\\OneDrive\\Documentos\\TCC\\10. Github Upload')
load('bloomberg.Rdata')
load('dataset_text.Rdata')

get_boosting = function(y, dataset, window_size) {
  
  library(mboost)
  library(forecast)
  
  # INICIALIZACAO DE VARIAVEIS
  set.seed(100)
  y = y
  x = dataset_merged_stationary[, !colnames(dataset_merged_stationary) %in% "BZEAMOM%"]
  n_available = length(y)
  for_set = seq(from = floor(0.75 * n_available), to = n_available)
  y_test = y[for_set]
  y_boosting = rep(NA, length(for_set))
  
  train_set = seq(from = 1, to = for_set[1] - window_size + 1)

  # LOOP DE JANELA DE ROLAGEM
  for (i in seq_along(for_set)) {
    
    # DEFININDO INDICES DE TREINO E TESTE PARA A JANELA ATUAL
    n_train = for_set[i] - window_size + 1
    #train_set = seq(from = 1, to = n_train)
    test_set = seq(from = for_set[i] - window_size + 1, to = for_set[i])
    
    # SUBCONJUNTO DOS DADOS PARA A JANELA ATUAL
    x_train = x[train_set,]
    y_train = y[train_set]
    x_test = x[test_set,]
    
    # AJUSTE DO MODELO DE BOOSTING
    reg_full = glmboost(
      y = y_train,
      x = as.matrix(x_train),
      offset = 0,
      center = TRUE,
      control = boost_control(mstop = 100, nu = 0.1)
    )
    
    # DETERMINACAO DO NUMERO OTIMO DE ITERACOES
    cv10f = cv(model.weights(reg_full), type = "kfold", B = 5)
    cv_seq = cvrisk(reg_full, folds = cv10f, papply = lapply)
    m_opt = mstop(cv_seq)
    
    # AJUSTE DO MODELO COM O NUMERO OTIMO DE ITERACOES
    reg_opt = glmboost(
      y = y_train,
      x = as.matrix(x_train),
      offset = 0,
      center = TRUE,
      control = boost_control(mstop = m_opt, nu = 0.1)
    )
    
    # PREVISAO PARA A JANELA DE TESTE
    opt_boosting = predict(reg_opt, newdata = as.matrix(x_test))
    
    # ARMAZENAMENTO DA PREVISAO
    #y_boosting[i] = opt_boosting[length(opt_boosting)]
    y_boosting[i] = tail(opt_boosting, 1)
    
    # ATUALIZACAO DO CONJUNTO DE TREINAMENTO
    train_set = train_set + 1

    # PROGRESSO
    print(i / length(for_set))
    
    # ATUALIZACAO DO CONJUNTO DE TESTE
    print(n_train)
    print(train_set)
  }
  
  # RESULTADOS
  results = list(values = y_boosting, accuracy = accuracy(y_boosting, x = y_test))
  return(results)
}


boosting = get_boosting(y=dataset_bloomberg$`BZEAMOM%`, dataset_merged_stationary, window_size = 1)
boosting$values
boosting$accuracy
