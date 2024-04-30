library(tidyverse)
library(textdata)
library(lubridate)
library(sentometrics)

setwd('C:\\Users\\eusou\\OneDrive\\Documentos\\TCC\\10. Github Upload')
source('1_Get_Tools.R')
source('2_Get_Tokens.R')
source('3_Get_Loughran_McDonald.R')
source('4_Get_TESI.R')
source('5_Get_TEPU.R')
source('6_Get_Ipea_Dataset.R')
source('7_Get_Stationary.R')
source('8_Get_Lags.R')

#CARREGANDO OS DATASETS
dataset = readxl::read_excel("C:\\Users\\eusou\\OneDrive\\Documentos\\TCC\\10. Github Upload\\dataset_temp.xlsx")
agronegocio = readxl::read_xlsx("C:\\Users\\eusou\\OneDrive\\Documentos\\TCC\\08. G1 Dataset\\3.noticias_tratadas_Agronegocio.xlsx")
mercadoF = readxl::read_xlsx("C:\\Users\\eusou\\OneDrive\\Documentos\\TCC\\08. G1 Dataset\\3.noticias_tratadas_MercadoFinanceiro.xlsx")
mercadoT = readxl::read_xlsx("C:\\Users\\eusou\\OneDrive\\Documentos\\TCC\\08. G1 Dataset\\3.noticias_tratadas_MercadoTrabalho.xlsx")
servicos = readxl::read_xlsx("C:\\Users\\eusou\\OneDrive\\Documentos\\TCC\\08. G1 Dataset\\3.noticias_tratadas_Serviços.xlsx")
industria = readxl::read_xlsx("C:\\Users\\eusou\\OneDrive\\Documentos\\TCC\\08. G1 Dataset\\3.noticicas_tratadas_industria.xlsx")

#CALCULANDO O TESI
agronegocio_tesi = get_tesi(agronegocio, how = "proportionalPol") %>% get_normalize(type = "TESI")  %>% get_resample(type = "TESI", timer = "month")
mercadoF_tesi = get_tesi(mercadoF, how = "proportionalPol") %>% get_normalize(type = "TESI") %>% get_resample(type = "TESI", timer = "month")
mercadoT_tesi = get_tesi(mercadoT, how = "proportionalPol") %>% get_normalize(type = "TESI") %>% get_resample(type = "TESI", timer = "month")
servicos_tesi = get_tesi(servicos, how = "proportionalPol") %>% get_normalize(type = "TESI") %>% get_resample(type = "TESI", timer = "month")
industria_tesi = get_tesi(industria, how = "proportionalPol") %>% get_normalize(type = "TESI") %>% get_resample(type = "TESI", timer = "month")

#TOKENIZANDO OS DADOS PARA O TEPU
agronegocio_tokens = get_tokens(agronegocio)
mercadoF_tokens = get_tokens(mercadoF)
mercadoT_tokens = get_tokens(mercadoT)
servicos_tokens = get_tokens(servicos)
industria_tokens = get_tokens(industria)

#CARREGANDO DICIONARIO TEPU
tepu_dict = get_tepu_dict()

#CALCULANDO TEPU
agronegocio_tepu = get_tepu(agronegocio_tokens, tepu_dict) %>% get_normalize(type = "TEPU") %>% get_resample(type = 'TEPU', timer = 'month')
mercadoF_tepu = get_tepu(mercadoF_tokens, tepu_dict) %>% get_normalize(type = "TEPU") %>% get_resample(type = 'TEPU', timer = 'month')
mercadoT_tepu = get_tepu(mercadoT_tokens, tepu_dict) %>% get_normalize(type = "TEPU") %>% get_resample(type = 'TEPU', timer = 'month')
servicos_tepu = get_tepu(servicos_tokens, tepu_dict) %>% get_normalize(type = "TEPU") %>% get_resample(type = 'TEPU', timer = 'month')
industria_tepu = get_tepu(industria_tokens, tepu_dict) %>% get_normalize(type = "TEPU") %>% get_resample(type = 'TEPU', timer = 'month')

#CARREGANDO DATASET SEM DADOS DE TEXTO (DATASET.NT)
dataset.notext = get_stationarity(dataset)
dataset.notext = do.call(cbind, dataset.notext$results) %>% as.data.frame()
dataset.notext = get_lags(dataset = dataset.notext, 12)
dataset.notext[is.na(dataset.notext)] <- 0

#CARREGANDO DATASET COM DADOS DE TEXTO (DATASET.TB)
dataset_merged = cbind(dataset, 
          agronegocio_tesi$TESI_Z, mercadoF_tesi$TESI_Z, mercadoT_tesi$TESI_Z, servicos_tesi$TESI_Z, industria_tesi$TESI_Z,
          agronegocio_tepu$TEPU_Z, mercadoF_tepu$TEPU_Z, mercadoT_tepu$TEPU_Z, servicos_tepu$TEPU_Z, industria_tepu$TEPU_Z)

dataset.text = get_stationarity(dataset_merged)
dataset.text = do.call(cbind, dataset.text$results) %>% as.data.frame()

dataset.text = get_lags(dataset = dataset.text, 12)
dataset.text[is.na(dataset.text)] <- 0

#GRAFICOS TESI
plot.ts(agronegocio_tesi$TESI_Z)
plot.ts(mercadoF_tesi$TESI_Z)
plot.ts(mercadoT_tesi$TESI_Z)
plot.ts(servicos_tesi$TESI_Z)
plot.ts(industria_tesi$TESI_Z)

#GRAFICOS TEPU
plot(x = agronegocio_tepu$Data, y = agronegocio_tepu$TEPU_Z, main = "TEPU - AGRONEGOCIO", type = 'lines')
plot(x = mercadoF_tepu$Data, y = mercadoF_tepu$TEPU_Z, main = "TEPU - MERCADO FINANCEIRO", type = 'lines')
plot(x = mercadoT_tepu$Data, y = mercadoT_tepu$TEPU_Z, main = "TEPU - MERCADO DE TRABALHO", type = 'lines')
plot(x = servicos_tepu$Data, y = servicos_tepu$TEPU_Z, main = "TEPU - SERVIÇOS", type = 'lines')
plot(x = industria_tepu$Data, y = industria_tepu$TEPU_Z, main = "TEPU - INDÚSTRIA", type = 'lines')


save(dataset.notext, file = "dataset_notext.Rdata")
save(dataset_merged_stationary, file = "dataset_text.Rdata")
