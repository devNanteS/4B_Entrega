/*
============================================================
  Arquivo: 03_insercoes_casos_teste.sql
  Autor(es):
    Leonardo Giannoccaro Nantes
    Pietro di Luca Monte Souza Balbino
    Matheus Gonçalves Domingues Geraldi
    Guilherme Liyuji Aoki Uehara

  Trabalho: Locação de Veículos
  Curso/Turma: DS 213
  SGBD: MySQL Versão: 8.0
  Objetivo: Inserção de dados específicos para
            exercitar regras de negócio e relatórios.
  Execução esperada: rodar após o 02_insercoes_basicas.sql
==========================================================
*/

USE locadora;

-- CENÁRIO A: Cliente com CNH vencida
-- Objetivo: Testar o bloqueio (via Trigger) de novas locações.

INSERT INTO endereco (id_endereco, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES
(11, 'Rua da Validade', '999', NULL, 'Documentos', 'Recife', 'PE', '50010-000');

INSERT INTO cnh (id_cnh, numero_registro, categoria, data_validade) VALUES
(6, '98765432100', 'B', '2020-01-01'); -- Data de validade no passado

INSERT INTO cliente (id_cliente, nome_completo, cpf, data_nascimento, telefone, email, tempo_habilitacao_anos, id_endereco, id_cnh) VALUES
(6, 'Joaozin do Erro', '666.666.666-66', '1980-01-01', '(81) 96666-6666', 'safado@gov.com', 25, 11, 6);

-- CENÁRIO B: Cliente com tempo de habilitação insuficiente
-- Objetivo: Testar a regra de negócio (não-trigger) de bloqueio.

INSERT INTO endereco (id_endereco, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES
(12, 'Rua do Novato', '10', 'Casa B', 'Iniciante', 'Curitiba', 'PR', '80010-000');

INSERT INTO cnh (id_cnh, numero_registro, categoria, data_validade) VALUES
(7, '87654321099', 'B', '2030-12-31'); -- CNH válida

INSERT INTO cliente (id_cliente, nome_completo, cpf, data_nascimento, telefone, email, tempo_habilitacao_anos, id_endereco, id_cnh) VALUES
(7, 'Bianca Novata', '777.777.777-77', '2003-05-10', '(41) 97777-7777', 'bbianca@email.com', 1, 12, 7); -- Apenas 1 ano de CNH

-- CENÁRIO C: Veículo com histórico extenso de manutenção (para Relatório)
-- Objetivo: Popular dados para o Relatório de Histórico de Veículo

-- (O Veículo 1 já tinha uma manutenção no arquivo 02)

INSERT INTO manutencao (data_entrada, data_saida, descricao_servico, custo, id_veiculo, status) VALUES
('2025-01-10', '2025-01-11', 'Troca de pastilhas de freio.', 450.00, 1, 'Concluída'),
('2025-04-22', '2025-04-22', 'Alinhamento e Balanceamento.', 180.00, 1, 'Concluída'),
('2025-09-05', '2025-09-07', 'Reparo no ar-condicionado.', 620.00, 1, 'Concluída');

-- CENÁRIO D: Cliente "Premium" com múltiplas locações (para Relatório)
-- Objetivo: Popular dados para o Relatório de Top Clientes.

-- (O Cliente 1 já tinha 2 locações no arquivo 02)

INSERT INTO locacao (id_locacao, data_retirada, data_devolucao_prevista, data_devolucao_real, valor_total_previsto, valor_final, quilometragem_retirada, quilometragem_devolucao, id_cliente, id_veiculo, id_funcionario) VALUES
(6, '2025-02-01 08:00:00', '2025-02-03 08:00:00', '2025-02-03 08:00:00', 361.00, 361.00, 4501, 4750, 1, 2, 1), -- Locação do Virtus
(7, '2025-07-10 12:00:00', '2025-07-17 12:00:00', '2025-07-17 11:30:00', 1750.00, 1750.00, 21001, 22500, 1, 3, 4); -- Locação da X3

INSERT INTO pagamento (data_pagamento, valor, id_locacao, id_forma_pagamento) VALUES
('2025-02-01 08:05:00', 361.00, 6, 1),
('2025-07-10 12:05:00', 1750.00, 7, 3);

-- CENÁRIO E: Locação ativa para Teste de Trigger (Cálculo de Atraso/Multa)
-- Objetivo: Preparar uma locação ativa (ID 8) para ser usada no arquivo 20_triggers.sql.

INSERT INTO locacao (id_locacao, data_retirada, data_devolucao_prevista, data_devolucao_real, valor_total_previsto, valor_final, quilometragem_retirada, quilometragem_devolucao, id_cliente, id_veiculo, id_funcionario) VALUES
(8, '2025-10-25 10:00:00', '2025-10-30 10:00:00', NULL, 600.00, NULL, 15501, NULL, 2, 1, 1); -- Cliente 2 (Matheus) aluga Veículo 1 (Kwid)

INSERT INTO pagamento (data_pagamento, valor, id_locacao, id_forma_pagamento) VALUES
('2025-10-25 10:05:00', 600.00, 8, 2);

-- Atualiza o status do veículo para 'Alugado' (Status 2)
UPDATE veiculo SET id_status_veiculo = 2 WHERE id_veiculo = 1;

-- CENÁRIO F: Teste de Conflito de Locação (Procedure)
-- Objetivo: Preparar dados para o arquivo 21_procedures.sql.
-- (O Veículo 5 - Toro - já está 'Alugado' (Status 2) pelo script 02,
-- então ele está pronto para o teste de falha da procedure.)

-- CENÁRIO G : Teste da função da fração de combustível (Trigger 3)
-- Objetivo : preparar dados para o arquivo 20_triggers.sql.alter

-- Adiciona seguros 11 e 12 para os carros de teste
INSERT INTO seguro (id_seguro, companhia, vencimento) VALUES
(11, 'Porto Seguro', '2027-08-01'),
(12, 'Allianz', '2027-09-01');

-- Inserindo Veículo 11 (Tanque 40L)
-- O valor_fracao = 0.00 será sobrescrito pela TRIGGER
INSERT INTO veiculo (id_veiculo, placa, ano, cor, chassi, quilometragem, transmissao, data_compra, valor_compra, data_vencimento, tanque, tanque_fracao, valor_fracao, id_modelo, id_status_veiculo, id_combustivel, id_seguro
) VALUES (
    11, 'TEST1A11', 2025, 'Roxo', '9BWZTESTETRIGGER1', 10, 'Manual', '2025-11-15', 80000.00, '2026-11-15', 40, 1.0, 0.00,
    -- Tanque=40, valor_fracao=0 (Trigger deve corrigir) 
    6, 1, 3, 11 -- (Modelo 6-Uno, Status 1-Disp, Comb 3-Flex, Seguro 11)
);

-- Inserindo Veículo 12 (Tanque 60L)
-- O valor_fracao = 0.00 será sobrescrito pela TRIGGER

INSERT INTO veiculo (
    id_veiculo, placa, ano, cor, chassi, quilometragem,
    transmissao, data_compra, valor_compra, data_vencimento,
    tanque, tanque_fracao, valor_fracao,
    id_modelo, id_status_veiculo, id_combustivel, id_seguro
) VALUES (
    12, 'TEST2B22', 2025, 'Verde', '9BWZTESTETRIGGER2', 10,
    'Automático', '2025-11-15', 290000.00, '2026-11-15',
    60, 1.0, 0.00, -- Tanque=60, valor_fracao=0 (Trigger deve corrigir)
    7, 1, 5, 12 -- (Modelo 7-Seal, Status 1-Disp, Comb 5-Elétrico, Seguro 12)
);



-- FIM DO SCRIPT