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
import WebScraping
import Tratamento
import SentimentAnalysis


q = 'Agronegócio'
#dataset_text = pd.read_excel(r'C:\Users\eusou\OneDrive\Documentos\TCC\08. G1 Dataset\3.noticicas_tratadas_agronegocio.xlsx')
#noticias_tratadas = Tratamento.tratamento(dataset_text, q)
noticias_tratadas = pd.read_excel(r'C:\Users\eusou\OneDrive\Documentos\TCC\08. G1 Dataset\3.noticicas_tratadas_agronegocio.xlsx')
tokens = SentimentAnalysis.init_token(noticias_tratadas)
sentiment_analysis_pt = SentimentAnalysis.sentiment_analysis_br(tokens, q)
sentiment_analysis_pt = SentimentAnalysis.normalize_sentiment(sentiment_analysis_pt, q)


def g1_agronegocio():
    dataset,q = WebScraping.initialize_g1(start='2012-01-01', q = 'Agronegócio', source= 'g1')
    dataset_text = WebScraping.get_http_text(dataset,q)
    noticias_tratadas = Tratamento.tratamento(dataset_text, q)
    tokens = SentimentAnalysis.init_token(noticias_tratadas)
    sentiment_analysis_pt = SentimentAnalysis.sentiment_analysis_br(tokens, q)
    sentiment_analysis_pt = SentimentAnalysis.normalize_sentiment(sentiment_analysis_pt, q)

    return sentiment_analysis_pt





def g1_industria():
    dataset, q = WebScraping.initialize_g1(start='2012-01-01', q = 'Indústria', source= 'g1')
    dataset_text = WebScraping.get_http_text(dataset,q)
    noticias_tratadas = Tratamento.tratamento(dataset_text, q)
    tokens = SentimentAnalysis.init_token(noticias_tratadas,q)
    sentiment_analysis_pt = SentimentAnalysis.sentiment_analysis_br(tokens, q)
    sentiment_analysis_pt = SentimentAnalysis.normalize_sentiment(sentiment_analysis_pt, q)

    return sentiment_analysis_pt






def g1_mercado_trabalho():
    dataset,q = WebScraping.initialize_g1(start='2012-01-01', q = 'Mercado de Trabalho', source= 'g1')
    dataset_text = WebScraping.get_http_text(dataset,q)
    noticias_tratadas = Tratamento.tratamento(dataset_text, q)
    tokens = SentimentAnalysis.init_token(noticias_tratadas,q)
    sentiment_analysis_pt = SentimentAnalysis.sentiment_analysis_br(tokens, q)
    sentiment_analysis_pt = SentimentAnalysis.normalize_sentiment(sentiment_analysis_pt, q)

    return sentiment_analysis_pt





def g1_mercado_financeiro():
    dataset,q = WebScraping.initialize_g1(start='2012-01-01', q = 'Mercado Financeiro', source= 'g1')
    dataset_text = WebScraping.get_http_text(dataset,q)
    noticias_tratadas = Tratamento.tratamento(dataset_text, q)
    tokens = SentimentAnalysis.init_token(noticias_tratadas,q)
    sentiment_analysis_pt = SentimentAnalysis.sentiment_analysis_br(tokens, q)
    sentiment_analysis_pt = SentimentAnalysis.normalize_sentiment(sentiment_analysis_pt, q)

    return sentiment_analysis_pt




def g1_servicos():
    dataset,q = WebScraping.initialize_g1(start='2012-01-01', q = 'Serviços', source= 'g1')
    dataset_text = WebScraping.get_http_text(dataset,q)
    noticias_tratadas = Tratamento.tratamento(dataset_text, q)
    tokens = SentimentAnalysis.init_token(noticias_tratadas,q)
    sentiment_analysis_pt = SentimentAnalysis.sentiment_analysis_br(tokens, q)
    sentiment_analysis_pt = SentimentAnalysis.normalize_sentiment(sentiment_analysis_pt, q)

    return sentiment_analysis_pt
