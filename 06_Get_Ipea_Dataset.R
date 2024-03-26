

library(tidyverse)
library(textdata)
library(lubridate)
library(sentometrics)
library(ipeadatar)


get_ipea_dataset = function(){
  
  dataset <- readxl::read_excel("C:\\Users\\eusou\\OneDrive\\Documentos\\TCC\\8. IPEA Dataset\\dataset.xlsx",
                        col_types = c(
                          "text", "text", "text",
                          "date", "date", "numeric", "text"))
  
  UNRATE <- "SEADE12_TDTGSP12"
  IPCA <- "PRECOS12_IPCA12"
  SPREAD <- "JPM366_EMBI366"
  
  ## Acquiring the metadata from each CODE
  metadados <- metadata(dataset$codigo)
  metadados_spread <- metadata("JPM366_EMBI366")
  
  ## Acquiring the values from each CODE
  data <- ipeadata(metadados$code)
  data_spread <- ipeadata(metadados_spread$code)
  
  ## Converting data to wide format
  df <- data %>%
    pivot_wider(names_from = "code") %>%
    select(-c(uname, tcode))
  
  df_sorted <- df[order(as.Date(df$date, format = "%Y/%m/%d")), ]
  
  df_spread <- data_spread %>%
    pivot_wider(names_from = "code") %>%
    select(-c(uname, tcode))
  
  # Transaform SPREAD from daily data to monthly data using mean
  df_spread <- df_spread %>%
    mutate(year_month = format(date, "%Y-%m")) %>%  # Create a new column with year-month format
    group_by(year_month) %>%                        # Group by year-month
    summarise(JPM366_EMBI366 = mean(JPM366_EMBI366)) %>% # Calculate the average for each month
    mutate(date = as.Date(paste(year_month, "-01", sep = ""))) %>%  # Create a date column for the beginning of each month
    select(date, JPM366_EMBI366) 
  
  df <- left_join(df_sorted, df_spread, by = "date")
  df_filtered <- subset(df, date >= as.Date("2010-05-01") & date < as.Date("2023-12-31"))
  df_filtered <- df_filtered  %>% select_if(~ !any(is.na(.)))
  
  return(df_filtered)
}


