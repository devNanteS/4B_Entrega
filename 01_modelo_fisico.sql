/*
============================================================
  Arquivo: 01_modelo_fisico.sql
  Autor(es):
	Leonardo Giannoccaro Nantes
    Pietro di Luca Monte Souza Balbino
    Matheus Gonçalves Domingues Geraldi
    Guilherme Liyuji Aoki Uehara

  Trabalho: Locação de Veículos
  Curso/Turma: DS 213
  SGBD: MySQL Versão: 8.0
  Objetivo: Criação do modelo físico (DDL) para o
            sistema de locação de veículos.
  Execução esperada: rodar primeiro, em BD vazio
==========================================================
*/

create database if not exists locadora;
use locadora;

CREATE TABLE IF NOT EXISTS usuario (
    id_usuario INT NOT NULL AUTO_INCREMENT,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    perfil VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS endereco (
    id_endereco     INT NOT NULL AUTO_INCREMENT,
    logradouro      VARCHAR(255) NOT NULL,
    numero          VARCHAR(10) NOT NULL,
    complemento     VARCHAR(100) NULL,
    bairro          VARCHAR(100) NOT NULL,
    cidade          VARCHAR(100) NOT NULL,
    estado          CHAR(2) NOT NULL,
    cep             VARCHAR(9) NOT NULL,
    PRIMARY KEY (id_endereco)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS cnh (
    id_cnh            INT NOT NULL AUTO_INCREMENT,
    numero_registro   VARCHAR(20) NOT NULL,
    categoria         VARCHAR(5) NOT NULL,
    data_validade     DATE NOT NULL,
    PRIMARY KEY (id_cnh)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS cliente (
    id_cliente              INT NOT NULL AUTO_INCREMENT,
    nome_completo           VARCHAR(255) NOT NULL,
    cpf                     VARCHAR(14) NOT NULL UNIQUE, 
    data_nascimento         DATE NOT NULL,
    telefone                VARCHAR(20) NOT NULL,
    email                   VARCHAR(100) NOT NULL UNIQUE, 
    tempo_habilitacao_anos  INT NOT NULL,
    id_endereco             INT NOT NULL,
    id_cnh                  INT NOT NULL UNIQUE, 
    PRIMARY KEY (id_cliente),
    FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco),
    FOREIGN KEY (id_cnh) REFERENCES cnh(id_cnh)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS cargo (
    id_cargo                INT NOT NULL AUTO_INCREMENT,
    nome_cargo              VARCHAR(100) NOT NULL,
    descricao_permissoes    TEXT NOT NULL,
    PRIMARY KEY (id_cargo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS funcionario (
    id_usuario      INT NOT NULL AUTO_INCREMENT, 
    nome            VARCHAR(255) NOT NULL,
    cpf             VARCHAR(14) NOT NULL UNIQUE,
    rg				VARCHAR(9) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    senha           VARCHAR(255) NOT NULL, 
    id_cargo        INT NOT NULL,
    id_endereco		INT NOT NULL,
    PRIMARY KEY (id_usuario),
    FOREIGN KEY (id_cargo) REFERENCES cargo(id_cargo),
    FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS marca (
    id_marca INT NOT NULL AUTO_INCREMENT,
    nome_marca VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_marca)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS categoria_veiculo (
    id_categoria_veiculo INT NOT NULL AUTO_INCREMENT,
    nome_categoria VARCHAR(100) NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_categoria_veiculo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS modelo (
    id_modelo INT NOT NULL AUTO_INCREMENT,
    nome_modelo VARCHAR(100) NOT NULL,
    id_marca INT NOT NULL,
    id_categoria_veiculo INT NOT NULL,
    PRIMARY KEY (id_modelo),
    FOREIGN KEY (id_marca) REFERENCES marca(id_marca),
    FOREIGN KEY (id_categoria_veiculo) REFERENCES categoria_veiculo(id_categoria_veiculo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS status_veiculo (
    id_status_veiculo INT NOT NULL AUTO_INCREMENT,
    descricao_status VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_status_veiculo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS combustivel (
	id_combustivel INT NOT NULL AUTO_INCREMENT,
    tipo_combustivel VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_combustivel)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS seguro (
	id_seguro INT NOT NULL AUTO_INCREMENT,
    companhia VARCHAR(100) NOT NULL,
    vencimento DATE NOT NULL,
    PRIMARY KEY (id_seguro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS veiculo (
    id_veiculo INT NOT NULL AUTO_INCREMENT,
    placa VARCHAR(8) NOT NULL UNIQUE,
    ano INT NOT NULL,
    cor VARCHAR(50) NOT NULL,
    chassi VARCHAR(17) NOT NULL UNIQUE,
    quilometragem INT NOT NULL,
    transmissao VARCHAR(100) NOT NULL,
    data_compra DATE NOT NULL,
    valor_compra DECIMAL(10,2) NOT NULL,
    data_vencimento DATE NOT NULL,
    tanque INT NOT NULL,
    tanque_fracao DECIMAL(5,4) NOT NULL,
    valor_fracao DECIMAL(10,2) NOT NULL,
    id_modelo INT NOT NULL,
    id_status_veiculo INT NOT NULL,
    id_combustivel INT NOT NULL,
    id_seguro INT NULL,
    PRIMARY KEY (id_veiculo),
    FOREIGN KEY (id_modelo) REFERENCES modelo(id_modelo),
    FOREIGN KEY (id_status_veiculo) REFERENCES status_veiculo(id_status_veiculo),
    FOREIGN KEY (id_combustivel) REFERENCES combustivel(id_combustivel),
    FOREIGN KEY (id_seguro) REFERENCES seguro(id_seguro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE manutencao (
    id_manutencao INT NOT NULL AUTO_INCREMENT,
    data_entrada DATE NOT NULL,
    data_saida DATE NULL,
    descricao_servico TEXT NOT NULL,
    custo DECIMAL(10,2) NOT NULL,
    id_veiculo INT NOT NULL,
    status ENUM('Em andamento', 'Concluída') NOT NULL DEFAULT 'Em andamento',
    PRIMARY KEY (id_manutencao),
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS locacao (
    id_locacao                INT NOT NULL AUTO_INCREMENT,
    data_retirada             DATETIME NOT NULL,
    data_devolucao_prevista   DATETIME NOT NULL,
    data_devolucao_real       DATETIME NULL,
    valor_total_previsto      DECIMAL(10, 2) NOT NULL,
    valor_final               DECIMAL(10, 2) NULL,
    quilometragem_retirada    INT NOT NULL,
    quilometragem_devolucao   INT NULL,
    id_cliente                INT NOT NULL,
    id_veiculo                INT NOT NULL,
    id_usuario                INT NOT NULL,
    PRIMARY KEY (id_locacao),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
    FOREIGN KEY (id_usuario) REFERENCES funcionario(id_usuario) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS forma_pagamento (
    id_forma_pagamento      INT NOT NULL AUTO_INCREMENT,
    descricao_pagamento     VARCHAR(100) NOT NULL, 
    PRIMARY KEY (id_forma_pagamento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS pagamento (
    id_pagamento            INT NOT NULL AUTO_INCREMENT,
    data_pagamento          DATETIME NOT NULL,
    valor                   DECIMAL(10, 2) NOT NULL,
    id_locacao              INT NOT NULL,
    id_forma_pagamento      INT NOT NULL,
    PRIMARY KEY (id_pagamento),
    FOREIGN KEY (id_locacao) REFERENCES locacao(id_locacao),
    FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento(id_forma_pagamento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS opcional (
    id_opcional     INT NOT NULL AUTO_INCREMENT,
    descricao       VARCHAR(255) NOT NULL,
    valor_diaria    DECIMAL(10, 2) NOT NULL,
    quantidade      DECIMAL(10, 2) NOT NULL,
    id_locacao      INT NOT NULL,
    PRIMARY KEY (id_opcional),
    FOREIGN KEY (id_locacao) REFERENCES locacao(id_locacao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
