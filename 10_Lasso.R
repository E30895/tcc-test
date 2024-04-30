


setwd('C:\\Users\\eusou\\OneDrive\\Documentos\\TCC\\10. Github Upload')
dataset = load('dataset_text.Rdata')
dataset  = dataset_merged_stationary

get_lasso = function(dataset, h){
  
  library(glmnet)
  library(forecast)
  
  #Y = `BZEAMOM%`
  y = dataset$`BZEAMOM%`
  x = dataset
  x$`BZEAMOM%` = NULL
  
  n_available = length(y)
  for_set = seq(from = floor(0.75 * n_available), to = n_available)
  y_test = y[for_set]

  for_hor = 12 #DEFINE O HORIZONTE
  n_train = for_set[1] - for_hor # DEFINE O TAMANHO DO TREINO []
  train_set = seq(from = 1, to = n_train) #DEFINE AS LINHAS DE TREINO
  
  test = 1
  
  y_lasso =  rep(NA, length(for_set))
  
  for (i in seq_along(for_set)) {
    y_train = y[train_set] #PASSANDO O Y DE TREINO
    x_train = x[train_set,] #PASSANDO O X DE TREINO
    
    x_test = x[n_train+test,]
    
    #ENCONTRAR O LAMBDA OTIMO
    cv_lasso = cv.glmnet(
      x = as.matrix(x_train),
      y = y_train,
      alpha = 1,
      intercept = T,
      standardize = F,
      nfolds = 5)
    
    opt_lasso = predict(
      cv_lasso,
      s = cv_lasso$lambda.min,
      newx = as.matrix(x_test))
    
    y_lasso[i] = opt_lasso[1]
    
    train_set = train_set + 1
    test =  test + 1
    
    print(i / length(for_set))
    
  }
  
  results = list(values = y_lasso, accuracy = accuracy(y_lasso, x = y_test))
  return(results)
}


lasso = get_lasso(dataset, h=1)
lasso$values
lasso$accuracy








library(glmnet)

linhas_treino = round(0.7 * nrow(dataset.notext))
treino = dataset.notext[1:linhas_treino, ]
teste = dataset.notext[(linhas_treino + 1):nrow(dataset.notext), ]

#TREINO
y_treino = treino$`BZEAMOM%`
treino$`BZEAMOM%` = NULL
X_treino = treino[, !colnames(treino) %in% "BZEAMOM%"]

y_teste = teste$`BZEAMOM%`
teste$`BZEAMOM%` = NULL
X_teste = teste[, !colnames(teste) %in% "BZEAMOM%"]

cv_lasso = cv.glmnet(
  x = as.matrix(X_treino),
  y = y_treino,
  alpha = 1,
  intercept = T,
  standardize = F,
  nfolds = 5)

opt_lasso = predict(
  cv_lasso,
  s = cv_lasso$lambda.min,
  newx = as.matrix(X_teste))

MSE1 = mean((opt_lasso - y_teste)^2)
mean(y_teste)
mean(opt_lasso)


################################################################################
##################### MODELO COM DADOS DE TEXTO ################################
################################################################################

#SEPARANDO TREINO E TESTE
linhas_treino = round(0.7 * nrow(dataset_merged_stationary))
treino = dataset_merged_stationary[1:linhas_treino, ]
teste = dataset_merged_stationary[(linhas_treino + 1):nrow(dataset_merged_stationary), ]

#TREINO
y_treino = treino$`BZEAMOM%`
treino$`BZEAMOM%` = NULL
X_treino = treino[, !colnames(treino) %in% "BZEAMOM%"]

#TESTE
y_teste = teste$`BZEAMOM%`
teste$`BZEAMOM%` = NULL
X_teste = teste[, !colnames(teste) %in% "BZEAMOM%"]

#LASSO
grid = 10^seq(10, -2, length = 100)
lasso.mod = glmnet(X_treino, y_treino, alpha = 1, lambda = grid)
plot(lasso.mod)

bestlam = min(lasso.mod$lambda)
lasso.pred = predict(lasso.mod, s = bestlam, newx = as.matrix(X_teste))
lasso.pred
MSE2 = mean((lasso.pred - y_teste)^2)

lasso.coef = predict(lasso.mod, type = "coefficients", s = bestlam)
lasso.coef[lasso.coef != 0]
lasso.coef

################################################################################
######################## COMPARACAO DOS MODELOS ################################
################################################################################


teste = data.frame(
  date = dataset[116:nrow(dataset), "date"],
  observado = dataset[116:nrow(dataset), "BZEAMOM%"],
  estimado = lasso.pred
)

plot(x = teste$date, y = teste$BZEAMOM., col = "green", type = 'line', main = "Observado Vs Estimado")
lines(x = teste$date, y = teste$s1, col = "blue", type = 'line')
legend("topright", legend = c("Observado", "Estimado"), col = c("green", "blue"), lty = 1, lwd = 2)


