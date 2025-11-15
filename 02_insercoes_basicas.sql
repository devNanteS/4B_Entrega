/*
============================================================
  Arquivo: 02_insercoes_basicas.sql
  Autor(es):
   
Leonardo Giannoccaro Nantes
Pietro di Luca Monte Souza Balbino
Matheus Gonçalves Domingues Geraldi
Guilherme Liyuji Aoki Uehara

  Trabalho: Locação de Veículos
  Curso/Turma: DS 213
  SGBD: MySQL Versão: 8.0
  Objetivo: Inserção de dados básicos e coerentes
            para popular o sistema.
  Execução esperada: rodar após o 01_modelo_fisico.sql
==========================================================
*/

USE locadora;

-- ---
-- Bloco 1: Tabelas de "Lookup" (Sem dependências externas)
-- Dados que servem como "opções" para outras tabelas.
-- ---

-- Insere os cargos dos funcionários
INSERT INTO cargo (id_cargo, nome_cargo, descricao_permissoes) VALUES
(1, 'Atendente', 'Registrar locações, devoluções e pagamentos.'),
(2, 'Gerente', 'Acesso total ao sistema, gerenciar frota e funcionários.'),
(3, 'Mecânico', 'Registrar manutenções e atualizar status de veículos.');

-- Insere os status possíveis para um veículo
INSERT INTO status_veiculo (id_status_veiculo, descricao_status) VALUES
(1, 'Disponível'),
(2, 'Alugado'),
(3, 'Em Manutenção');

-- Insere as formas de pagamento aceitas
INSERT INTO forma_pagamento (id_forma_pagamento, descricao_pagamento) VALUES
(1, 'Cartão de Crédito'),
(2, 'Cartão de Débito'),
(3, 'PIX'),
(4, 'Dinheiro');

-- Insere as marcas de veículos
INSERT INTO marca (id_marca, nome_marca) VALUES
(1, 'Renault'),
(2, 'Volkswagen'),
(3, 'BYD'), -- Elétricos
(4, 'FIAT'),
(5, 'BMW');

-- Insere as categorias de veículos e seus valores de diária
INSERT INTO categoria_veiculo (id_categoria_veiculo, nome_categoria, valor_diaria) VALUES
(1, 'Compacto', 120.00),
(2, 'Sedan Médio', 180.50),
(3, 'SUV', 250.00),
(4, 'Picape', 300.00),
(5, 'Elétrico', 350.75);

-- Insere os tipos de combustível
INSERT INTO combustivel (id_combustivel, tipo_combustivel) VALUES
(1, 'Gasolina'),
(2, 'Etanol'),
(3, 'Flex (Gasolina/Etanol)'),
(4, 'Diesel'),
(5, 'Elétrico');

-- Insere 5 usuários de sistema 
INSERT INTO usuario (id_usuario, email, senha, perfil) VALUES
(1, 'cliente1@email.com', 'hash_senha', 'Cliente'),
(2, 'cliente2@email.com', 'hash_senha', 'Cliente'),
(3, 'cliente3@email.com', 'hash_senha', 'Cliente'),
(4, 'cliente4@email.com', 'hash_senha', 'Cliente'),
(5, 'cliente5@email.com', 'hash_senha', 'Cliente');


-- ---
-- Bloco 2: Entidades semi-dependentes (Endereços, CNHs, Seguros)
-- ---

-- Insere 5 endereços para os CLIENTES (IDs 1-5)
INSERT INTO endereco (id_endereco, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES
(1, 'Rua do Limoeiro', '123', 'Apto 101', 'Centro', 'São Paulo', 'SP', '01001-000'),
(2, 'Canindé', '1500', 'Sala 502', 'IFSP', 'São Paulo', 'SP', '01310-100'),
(3, 'Morumbi', '800', NULL, 'Morumbis', 'São Paulo', 'SP', '01220-000'),
(4, 'Praça da Sé', '10', NULL, 'Sé', 'São Paulo', 'SP', '01001-001'),
(5, 'Avenida Faria Lima', '4500', 'Andar 10', 'Itaim Bibi', 'São Paulo', 'SP', '04538-133');

-- Insere 5 endereços para os FUNCIONÁRIOS (IDs 6-10)
INSERT INTO endereco (id_endereco, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES
(6, 'Rua dos Atendentes', '10', NULL, 'Centro', 'Jundiaí', 'SP', '13201-001'),
(7, 'Avenida dos Gerente', '501', 'Bloco 1', 'Tatuapé', 'São Paulo', 'SP', '13208-002'),
(8, 'Rua do Design', '30', 'Moderno 123 ', 'Vila JS', 'Campinas', 'SP', '13202-003'),
(9, 'Rua do pão de queijo', '2000', 'SGBD 3', 'Vila do café', 'Belo Horizonte', 'MG', '13219-005'),
(10, 'Avenida da BGS', '112', 'LOL', 'Vila Mariana', 'São Paulo', 'SP', '13209-004');


-- Insere 5 CNHs para os CLIENTES (IDs 1-5)
INSERT INTO cnh (id_cnh, numero_registro, categoria, data_validade) VALUES
(1, '01234567890', 'B', '2028-05-10'),
(2, '12345678901', 'B', '2026-11-20'),
(3, '23456789012', 'D', '2027-02-15'),
(4, '34567890123', 'AB', '2029-09-30'),
(5, '45678901234', 'B', '2025-12-25');

-- Insere 10 apólices de seguro
INSERT INTO seguro (id_seguro, companhia, vencimento) VALUES
(1, 'Porto Seguro', '2026-10-01'),
(2, 'Azul Seguros', '2026-10-15'),
(3, 'Allianz', '2026-11-30'),
(4, 'Tokio Marine', '2027-01-10'),
(5, 'Bradesco Seguros', '2026-09-01'),
(6, 'Porto Seguro', '2027-02-01'),
(7, 'Allianz', '2027-02-10'),
(8, 'Azul Seguros', '2027-03-05'),
(9, 'Tokio Marine', '2027-04-15'),
(10, 'Bradesco Seguros', '2027-05-20');

-- ---
-- Bloco 3: Entidades principais (Cliente, Funcionário, Modelo, Veículo)
-- ---

-- Insere os 5 modelos de veículos
INSERT INTO modelo (id_modelo, nome_modelo, id_marca, id_categoria_veiculo) VALUES
(1, 'Kwid', 1, 1),       -- Renault, compacto
(2, 'Virtus', 2, 2),     -- VW, Sedan
(3, 'X3', 5, 3),         -- BMW, SUV
(4, 'Dolphin', 3, 5),    -- BYD, elétrico
(5, 'Toro', 4, 4),       -- Fiat, Picape
(6, 'Uno', 4, 1),        -- Fiat, compacto
(7, 'Seal', 3, 2),       -- BYD, Elétrico
(8, 'Captur', 1, 3),     -- Renault, SUV
(9, 'Saveiro', 2, 4),    -- VW , Picape
(10, 'Pulse', 4, 2);     -- Fiat, Sedan

-- Insere 5 clientes
INSERT INTO cliente (id_cliente, nome_completo, cpf, data_nascimento, telefone, email, tempo_habilitacao_anos, id_endereco, id_cnh) VALUES
(1, 'Rodrigo Nantes', '111.111.111-11', '1983-04-14', '(11) 91111-1111', 'sr.rodrigo@hotmail.com', 20, 1, 1),
(2, 'Matheus Geraldi', '222.222.222-22', '2000-11-20', '(11) 92222-2222', 'chaveirinho@gmail.com', 2, 2, 2),
(3, 'Fabrizio San Felipe', '333.333.333-33', '1998-11-26', '(11) 93333-3333', 'fafa.san@aluno.ifsp.edu.br', 10, 3, 3),
(4, 'Japones Liuyji Uehara', '444.444.444-44', '1946-06-17', '(11) 94444-4444', 'gui.liuyji@aluno.ifsp.com.br', 40, 4, 4),
(5, 'Yuri de Argolo', '555.555.555-55', '2000-01-01', '(11) 95555-5555', 'yuri@aluno.ifsp.edu.br', 7, 5, 5);

-- Insere 5 funcionários
INSERT INTO funcionario (id_usuario, nome, cpf, rg, data_nascimento, email, senha, id_cargo, id_endereco) VALUES
(1, 'Pietro di Luca', '123.456.789-10', '123456789', '1995-05-10', 'jundiai.atendente@locadora.com', 'hash_senha_123', 1, 6),
(2, 'Leonardo Nantes', '234.567.890-11', '234567890', '1990-02-20', 'leleo.gerente@locadora.com', 'hash_senha_456', 2, 7),
(3, 'Claudete', '345.678.901-12', '345678901', '1985-07-15', 'claudete.mecanico@locadora.com', 'hash_senha_789', 3, 8),
(4, 'Leonardo Motta', '456.789.012-13', '456789012', '1998-03-05', 'motta.atendente@locadora.com', 'hash_senha_111', 1, 9),
(5, 'Ricardo Agostinho', '567.890.123-14', '567890123', '1988-12-25', 'agostinho.gerente@locadora.com', 'hash_senha_222', 2, 10);

-- Insere 10 veículos da frota
INSERT INTO veiculo (id_veiculo, placa, ano, cor, chassi, quilometragem, transmissao, data_compra, valor_compra, data_vencimento, tanque, tanque_fracao, valor_fracao, id_modelo, id_status_veiculo, id_combustivel, id_seguro) VALUES
(1, 'RBC1A23', 2024, 'Branco', '9BWDA08T0P1234567', 15000, 'Manual', '2024-01-10', 75000.00, '2025-01-10', 40, 1.0, 35.00, 1, 1, 3, 1), -- Kwid (Flex), Disponível
(2, 'SCD2B34', 2023, 'Preto', '9BWEA08T0P2345678', 5000, 'Automático', '2023-05-20', 110000.00, '2025-05-20', 52, 1.0, 44.00, 2, 1, 3, 2), -- Virtus (Flex), Disponível
(3, 'TDE3C45', 2022, 'Azul', '9BWFA08T0P3456789', 25000, 'Automático', '2022-07-15', 280000.00, '2025-07-15', 60, 1.0, 50.00, 3, 1, 1, 3), -- X3 (Gasolina), Disponível
(4, 'UFG4D56', 2021, 'Prata', '9BWGA08T0P4567890', 40000, 'Automático', '2021-11-01', 150000.00, '2025-11-01', 45, 1.0, 0.00, 4, 3, 5, 4), -- Dolphin (Elétrico), Em Manutenção
(5, 'VHI5E67', 2023, 'Vermelho', '9BWHA08T0P5678901', 10000, 'Automático', '2023-09-10', 180000.00, '2025-09-10', 60, 1.0, 65.00, 5, 2, 4, 5), -- Toro (Diesel), Alugado
(6, 'ABC1D23', 2022, 'Cinza', '9BWJB08T0P6789012', 22000, 'Manual', '2022-03-15', 65000.00, '2026-03-15', 47, 1.0, 40.00, 6, 1, 3, 6), -- Uno (Flex), Disponível
(7, 'DEF4E56', 2024, 'Preto', '9BWKC08T0P7890123', 2000, 'Automático', '2024-05-01', 280000.00, '2026-05-01', 50, 1.0, 0.00, 7, 1, 5, 7), -- Seal (Elétrico), Disponível
(8, 'GHI7F89', 2023, 'Branco', '9BWLD08T0P8901234', 12000, 'Automático', '2023-02-20', 130000.00, '2026-02-20', 50, 1.0, 42.00, 8, 1, 3, 8), -- Captur (Flex), Disponível
(9, 'JKL0G12', 2022, 'Prata', '9BWME08T0P9012345', 35000, 'Manual', '2022-04-10', 90000.00, '2026-04-10', 55, 1.0, 47.00, 9, 1, 3, 9), -- Saveiro (Flex), Disponível
(10, 'MNO3H45', 2023, 'Vermelho', '9BWNF08T0P0123456', 18000, 'Automático', '2023-06-30', 105000.00, '2026-06-30', 47, 1.0, 40.00, 10, 1, 3, 10); -- Pulse (Flex), Disponível

-- ---
-- Bloco 4: Registros de Atividades (Manutenções, Locações)
-- ---

-- Insere registros de manutenção
INSERT INTO manutencao (id_manutencao, data_entrada, data_saida, descricao_servico, custo, id_veiculo, status) VALUES
(1, '2025-10-28', NULL, 'Revisão dos 40.000km, troca de óleo e filtros.', 850.00, 4, 'Em andamento'), -- Manutenção ativa do Dolphin
(2, '2025-06-15', '2025-06-16', 'Troca de pneus dianteiros.', 1200.00, 1, 'Concluída'); -- Manutenção passada do Kwid

-- Insere 5 locações
INSERT INTO locacao (id_locacao, data_retirada, data_devolucao_prevista, data_devolucao_real, valor_total_previsto, valor_final, quilometragem_retirada, quilometragem_devolucao, id_cliente, id_veiculo, id_funcionario) VALUES
(1, '2025-10-01 10:00:00', '2025-10-05 10:00:00', '2025-10-05 09:30:00', 480.00, 480.00, 10000, 10500, 1, 1, 1), -- Locação passada (Kwid)
(2, '2025-10-10 14:00:00', '2025-10-15 14:00:00', '2025-10-15 14:10:00', 902.50, 902.50, 4000, 4500, 2, 2, 4), -- Locação passada (Virtus)
(3, '2025-10-20 09:00:00', '2025-10-25 09:00:00', '2025-10-25 09:00:00', 1250.00, 1250.00, 20000, 21000, 3, 3, 1), -- Locação passada (BMW)
(4, '2025-10-30 15:00:00', '2025-11-10 15:00:00', NULL, 3000.00, NULL, 10000, NULL, 4, 5, 2), -- Locação ativa (Toro, Status 2)
(5, '2025-10-22 11:00:00', '2025-10-24 11:00:00', '2025-10-24 18:00:00', 240.00, 300.00, 10500, 11000, 5, 1, 4); -- Locação passada (Kwid), devolveu com atraso

-- ---
-- Bloco 5: Registros dependentes de Locação (Pagamentos, Opcionais)
-- ---

-- Insere pagamentos para as locações
INSERT INTO pagamento (id_pagamento, data_pagamento, valor, id_locacao, id_forma_pagamento) VALUES
(1, '2025-10-01 10:05:00', 480.00, 1, 1), -- Pgto Locação 1 (Crédito)
(2, '2025-10-10 14:05:00', 902.50, 2, 2), -- Pgto Locação 2 (Débito)
(3, '2025-10-20 09:05:00', 1250.00, 3, 3), -- Pgto Locação 3 (PIX)
(4, '2025-10-30 15:05:00', 1500.00, 4, 1), -- Pgto Locação 4 (Sinal 50% no Crédito)
(5, '2025-10-24 18:05:00', 300.00, 5, 3); -- Pgto Locação 5 (PIX)

-- Insere itens opcionais para algumas locações
INSERT INTO opcional (id_opcional, descricao, valor_diaria, quantidade, id_locacao) VALUES
(1, 'Cadeira de Bebê', 25.00, 1, 2), -- Para Locação 2
(2, 'GPS', 15.00, 1, 3), -- Para Locação 3
(3, 'Cadeira de Bebê', 25.00, 2, 4), -- Para Locação 4
(4, 'Bagageiro de Teto', 40.00, 1, 4); -- Para Locação 4