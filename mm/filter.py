def drop_duplicate_news(dataset):
    dataset= dataset.groupby('Texto', as_index=False).first()
    dataset = dataset.sort_values(by=['Data'])
    dataset = dataset[['Data', 'endereco', 'Texto', 'Num_Palavras-Chave']]
    return dataset




def remove_useless(dataset, q, min_crit=1):

    if q == 'Agronegócio':
        palavras_chave = ['Agronegócio',
                          'Agricultura',
                          'Pecuária',
                          'Agroindústria',
                          'Produção Agrícola',
                          'Cultivo',
                          'Plantio',
                          'Colheita',
                          'Agropecuária',
                          'Gestão Rural',
                          'Tecnologia no Campo',
                          'Irrigação',
                          'Fertilizantes',
                          'Defensivos Agrícolas',
                          'Mercado Agrícola',
                          'Exportação Agrícola',
                          'Logística Agrícola',
                          'Sustentabilidade no Agronegócio',
                          'Agrobusiness',
                          'Cadeia Produtiva']

    elif q == 'Indústria':
        palavras_chave = ['Indústria',
                          'Produção',
                          'Manufatura',
                          'Fábrica',
                          'Produção Industrial',
                          'Processo Industrial',
                          'Tecnologia Industrial',
                          'Automatização',
                          'Máquinas',
                          'Equipamentos Industriais',
                          'Engenharia Industrial',
                          'Logística',
                          'Supply Chain',
                          'Qualidade',
                          'Padrões Industriais',
                          'Operações',
                          'Eficiência',
                          'Inovação Industrial',
                          'Sustentabilidade Industrial',
                          'Energia Industrial']
    
    elif q == 'Mercado de Trabalho':
        palavras_chave = ['Mercado de Trabalho',
                          'Emprego',
                          'Desemprego',
                          'Salário',
                          'Vagas',
                          'Recrutamento',
                          'Carreira',
                          'Oportunidades',
                          'RH',
                          'Entrevista',
                          'Currículo',
                          'Contratação',
                          'Estágio',
                          'Desenvolvimento Profissional',
                          'Competências',
                          'Treinamento',
                          'Benefícios',
                          'Trabalho Remoto',
                          'Flexibilidade',
                          'Empregabilidade']
            
    elif q == 'Mercado Financeiro':
        palavras_chave = ['Mercado Financeiro', 
                          'Mercado de Capitais', 
                          'Bolsa de Valores', 
                          'IBOV',
                          'índice Bovespa', 
                          'Câmbio' 
                          'Ações', 
                          'Corretora', 
                          'Economia', 
                          'Finanças',
                          'Tesouro Direto',
                          'Derivativos', 
                          'Análise Financeira', 
                          'Capital', 
                          'Dividendos']
    
    elif q == 'Serviços':
        palavras_chave = ['Setor de Serviços',
                          'Serviços',
                          'Atendimento ao Cliente',
                          'Consultoria',
                          'Tecnologia da Informação',
                          'TI',
                          'Software',
                          'SaaS (Software as a Service)',
                          'Infraestrutura',
                          'Logística',
                          'Transporte',
                          'Telecomunicações',
                          'E-commerce',
                          'Turismo',
                          'Hotelaria',
                          'Restaurante',
                          'Educação',
                          'Saúde',
                          'Financeiro',
                          'Seguros',
                          'Gestão de Projetos']

    dataset['Texto'] = dataset['Texto'].astype(str)
    
    # Função para contar o número de palavras-chave encontradas em cada texto
    def count_keywords(text):
        return sum(keyword.lower() in text.lower() for keyword in palavras_chave)
    
    # Criar uma nova coluna com o número de palavras-chave encontradas para cada texto
    dataset['Num_Palavras-Chave'] = dataset['Texto'].apply(count_keywords)
    
    # Aplicar a máscara para manter apenas os textos relevantes
    mask = dataset['Num_Palavras-Chave'] >= min_crit
    dataset = dataset[mask]
    
    dataset.reset_index(drop=True, inplace=True)
    
    return dataset
