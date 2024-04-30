library(forecast)
library(glmnet)
library(caret)

setwd('C:\\Users\\eusou\\OneDrive\\Documentos\\TCC\\10. Github Upload')
dataset = load('dataset_text.Rdata')
dataset  = dataset_merged_stationary

#ENTENDER A FUNCAO

y <- dataset$`BZEAMOM%`
x <- dataset
x$`BZEAMOM%` = NULL 

set.seed(100)
cv_5 <- trainControl(method = "cv", number = 5) #CROSS VALIDATION

myGrid <- expand.grid(
  alpha = seq(0, 1, length = 10), # range for alpha
  lambda = 10^seq(-10, -1, length = 10) # Broad range for lambda
)

cv_enet <- train(
  x = x %>% as.data.frame(),
  y = y,
  method = "glmnet",
  #method = 'enet', NA DOCUMENTACAO ENCONTREI UM ARGUMENTO DIFERENTE
  trControl = cv_5,
  tuneGrid = myGrid,
  metric = "RMSE",
  intercept = T,
  standardize = FALSE
)


# Assuming 'cv_enet' is your trained model object
best_lambda <- cv_enet$finalModel$lambdaOpt
best_alpha <- cv_enet$finalModel$tuneValue[1] %>% as.numeric()

opt_enet <- coef(cv_enet$finalModel, cv_enet$finalModel$lambdaOpt)

prev = predict(cv_enet, newx = as.matrix(x))
accuracy = accuracy(prev, y)
accuracy

prev == y

#ESSA PARTE FINAL EU NÃO ENTENDI
x <- rep(0, ncol(dataset))
x[opt_enet@i] <- opt_enet@x
names(x) <- colnames(dataset)


##############################################################################


modelo_elasticnet <- cv.glmnet(
  x = as.matrix(x), 
  y = y, 
  alpha = 0.5,  #alpha = 0.5 para Elastic Net (0 para Ridge, 1 para Lasso)
  intercept = T,
  standardize = F,
  nfolds = 5)

opt_net <- predict(
  modelo_elasticnet,
  s = modelo_elasticnet$lambda.min,
  newx = as.matrix(x_test))
  
# Visualizar os resultados do modelo
summary(modelo_elasticnet)
