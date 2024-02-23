import pandas as pd
import numpy as np
import requests
import time
import datetime
import re
import string
import matplotlib.pyplot as plt
import nltk
from textblob import TextBlob
from nltk.corpus import stopwords
from nltk.stem import SnowballStemmer
from nltk.tokenize import word_tokenize
from bs4 import BeautifulSoup




def tokenize_text(text):
    if isinstance(text, str):
        return word_tokenize(text)
    else:
        return []




def init_token(dataset_noticias):
    # Aplicar a tokenização à coluna 'texto'
    dataset_noticias['token'] = dataset_noticias['Texto'].apply(tokenize_text)

    # Replicar as linhas para cada palavra
    dataset_token = dataset_noticias.explode('token')
    dataset_token.drop(['Texto', 'endereco', 'Num_Palavras-Chave'], axis=1, inplace=True)
    dataset_token.reset_index(drop=True, inplace=True)
    
    return dataset_token




def sentiment_analysis_br(dataset_token, q):
    Loughan_Mc = pd.read_excel(r"C:\Users\eusou\OneDrive\Documentos\TCC\06. Dicionários\Loughran_McDonald_pt.xlsx")

    Loughan_Mc = Loughan_Mc.loc[(Loughan_Mc['sentimento'] == 'positivo') | (Loughan_Mc['sentimento'] == 'negativo')]
    
    sentiment_analysis = None
    sentiment_analysis = pd.merge(dataset_token, Loughan_Mc, on='token')
    sentiment_analysis['Data'] = pd.to_datetime(sentiment_analysis['Data'], format='%d/%m/%Y')
    sentiment_analysis = sentiment_analysis.groupby(['Data', 'sentimento']).size().unstack(fill_value=0)
    sentiment_analysis['Sentimento'] = ((sentiment_analysis['positivo'] - sentiment_analysis['negativo']) / (sentiment_analysis['positivo'] + sentiment_analysis['negativo']))

    sentiment_analysis.to_excel(f'Sentiment_Analysis_{q}_br.xlsx')

    return sentiment_analysis





def sentiment_analysis_en(dataset_token, q):
    Loughan_Mc = pd.read_excel(r"C:\Users\eusou\OneDrive\Documentos\TCC\06. Dicionários\Loughran_McDonald_en.xlsx")
    Loughan_Mc = Loughan_Mc.loc[(Loughan_Mc['sentiment'] == 'positive') | (Loughan_Mc['sentiment'] == 'negative')]
    
    sentiment_analysis = None
    sentiment_analysis = pd.merge(dataset_token, Loughan_Mc, on='token')
    sentiment_analysis['Data'] = pd.to_datetime(sentiment_analysis['Data'], format='%d/%m/%Y')
    sentiment_analysis = sentiment_analysis.groupby(['Data', 'sentiment']).size().unstack(fill_value=0)
    sentiment_analysis['sentiment'] = ((sentiment_analysis['positive'] - sentiment_analysis['negative']) / (sentiment_analysis['positive'] + sentiment_analysis['negative']))
    
    sentiment_analysis.to_excel(f'Sentiment_Analysis_{q}_en.xlsx')

    return sentiment_analysis




def normalize_sentiment(sentiment_analysis, q):
    mean = np.mean(sentiment_analysis['Sentimento'])
    std = np.std(sentiment_analysis['Sentimento'])
    sentiment_analysis['SS_NORMALIZE'] = ((sentiment_analysis['Sentimento'] - mean)) / std

    sentiment_analysis.to_excel(f'Sentiment_Analysis_{q}_br.xlsx')
    
    return sentiment_analysis




def resample(sentiment_analysis):

    sentiment_analysis['Data'] = pd.to_datetime(sentiment_analysis['Data'])
    sentiment_analysis.set_index('Data', inplace=True)
    sentiment_analysis = sentiment_analysis.resample('W').mean()

    return sentiment_analysis