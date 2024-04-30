
library(tidyverse)
library(textdata)
library(lubridate)
library(sentometrics)


get_Loughran_McDonald = function(){
  
  #' Obter Dicionário de Loughran-McDonald
  #'
  #' Esta função retorna o dicionário de Loughran-McDonald contendo termos relacionados à incerteza.
  #'
  #' @return Um conjunto de dados contendo o dicionário de Loughran-McDonald para termos relacionados à incerteza.
  #' @examples
  #' get_Loughran_McDonald()
  #'
  #' @importFrom textdata lexicon_loughran
  #' @importFrom dplyr mutate group_by distinct ungroup filter
  #' @importFrom tm stemDocument
  #' @export
  
  dicionario = textdata::lexicon_loughran() %>% 
    dplyr::mutate(
      token = tm::stemDocument(x = word, language = "english"),
      sentimento = sentiment,
      .keep = "none"
    ) %>% 
    dplyr::group_by(token) %>% 
    dplyr::distinct(sentimento) %>%
    dplyr::ungroup() %>% 
    dplyr::filter(sentimento %in% 'uncertainty')
  
  return(dicionario)
}

get_tepu_dict = function(){
  
  #' Obter Dicionário TEPUs
  #'
  #' Esta função retorna um dicionário contendo termos relacionados à incerteza (U) e termos políticos (P).
  #'
  #' @return Um conjunto de dados contendo o dicionário TEPUs.
  #' @examples
  #' get_tepu_dict()
  #'
  #' @importFrom dplyr mutate rbind
  #' @importFrom base rbind tolower
  #' @export
  
  
  U = get_Loughran_McDonald()[1:84,]
  U$sentimento = 'U'
  P = data.frame(
    token = c("Accountability", "Ambassador", "Autocracy", "Ballot", "Bipartisanship", "Bureaucracy", "Campaign", "Campaigning", "Cabinet", "Checks and balances",
              "Chancellor", "Central Bank", "Civil servant", "Civil service", "Coalition", "Congress", "Congressman", "Constituency", "Constituent", "Constitution", "Corruption",
              "Democracy", "Dictatorship", "Diplomat", "Diplomacy", "Domestic policy", "Electoral", "Electoral college", "Election", "Executive", "Federalism",
              "Foreign policy", "Government", "Governing party", "Gridlock", "House of Representatives", "Human rights", "Impeachment", "Initiative", "International relations",
              "Legislation", "Legislative", "Legislative", "Lobby", "Lobbyist", "Lawmaker", "Manifesto", "Majority", "Minority", "Monarch", "Monarchy", "Oligarchy",
              "Opposition", "Opposition party", "Parliament", "Petition", "Policy", "Political campaign", "Political party", "Politics", "Poll", "President",
              "President-elect", "Public servant", "Recall", "Recall election", "Referendum", "Republic", "Ruling party",
              "Senate", "Separation of powers", "Suffrage", "Transparency", "Vote"),
    sentimento = "P")
  
  tepu_dict = rbind(U, P)
  tepu_dict$token = tolower(tepu_dict$token)
  
  return(tepu_dict)
  
  }
