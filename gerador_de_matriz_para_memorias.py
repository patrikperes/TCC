# -*- coding: utf-8 -*-
"""
-- file gerador_de_matriz_para_memorias.py
-- Propose: Creates a matrix of linhas lines and colunas_aleatorias columns
-- filled with random values between 0 and 1 
-- Obs: Adapted to use on Google Colab
-- Obs2: check the lenght of the variables
-- Designer: Patrik Loff Peres
-- Date: 26/08/2025
    
"""

from google.colab import files
files.download("saida.csv")

import csv
import random
from google.colab import files

# Nome do arquivo de saída
nome_arquivo = "saida.csv"

# Número de linhas e colunas
linhas = 64
colunas_aleatorias = 8

# Cria o arquivo CSV
with open(nome_arquivo, mode='w', newline='') as arquivo:
    escritor = csv.writer(arquivo)

    # Escreve o cabeçalho (opcional)
    #cabecalho = ["Indice"] + [f"Col{i+1}" for i in range(colunas_aleatorias)]
    #escritor.writerow(cabecalho)

    # Gera as linhas
    for i in range(linhas):
        linha = [i] + [random.randint(0, 1) for _ in range(colunas_aleatorias)]
        escritor.writerow(linha)

print(f"Arquivo '{nome_arquivo}' criado com sucesso!")

# Baixa o arquivo para o seu computador
files.download(nome_arquivo)

