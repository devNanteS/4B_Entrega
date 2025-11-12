/*
============================================================
  Arquivo: 10_queries_basicas.sql
  Autor(es):
   
Leonardo Giannoccaro Nantes
Pietro di Luca Monte Souza Balbino
Matheus Gonçalves Domingues Geraldi
Guilherme Liyuji Aoki Uehara

  Trabalho: Locação de Veículos
  Curso/Turma: DS 213
  SGBD: MySQL Versão: 8.0
  Objetivo: Consultas (queries) básicas para
            verificação dos dados inseridos.
  Execução esperada: rodar após os scripts 01, 02 e 03.
==========================================================
*/

USE locadora;

-- CENÁRIO A: Cliente com CNH vencida
-- Objetivo: Testar o bloqueio (via Trigger ou Procedure nos arquivos 20/21)
-- de novas locações para clientes com CNH inválida (data_validade < HOJE).

INSERT INTO endereco (id_endereco, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES
(6, 'Rua da Validade', '999', NULL, 'Documentos', 'Recife', 'PE', '50010-000');

INSERT INTO cnh (id_cnh, numero_registro, categoria, data_validade) VALUES
(6, '98765432100', 'B', '2020-01-01'); -- Data de validade no passado

INSERT INTO cliente (id_cliente, nome_completo, cpf, data_nascimento, telefone, email, tempo_habilitacao_anos, id_endereco, id_cnh) VALUES
(6, 'Joaozin do Erro', '666.666.666-66', '1980-01-01', '(81) 96666-6666', 'safado@gov.com', 25, 6, 6);


-- CENÁRIO B: Cliente com tempo de habilitação insuficiente
-- Objetivo: Testar a regra de negócio (via Trigger/Procedure 20/21) que
-- bloqueia locações para motoristas com menos de 2 anos de CNH.

INSERT INTO endereco (id_endereco, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES
(7, 'Rua do Novato', '10', 'Casa B', 'Iniciante', 'Curitiba', 'PR', '80010-000');

INSERT INTO cnh (id_cnh, numero_registro, categoria, data_validade) VALUES
(7, '87654321099', 'B', '2030-12-31'); -- CNH válida

INSERT INTO cliente (id_cliente, nome_completo, cpf, data_nascimento, telefone, email, tempo_habilitacao_anos, id_endereco, id_cnh) VALUES
(7, 'Bianca Novata', '777.777.777-77', '2003-05-10', '(41) 97777-7777', 'bbianca@email.com', 1, 7, 7); -- Apenas 1 ano de CNH


-- CENÁRIO C: Veículo com histórico extenso de manutenção (para Relatório)
-- Objetivo: Popular dados para o Relatório de Histórico de Veículo

-- (O Veículo 1 já tinha uma manutenção de 2025-06-15 no arquivo 02)
INSERT INTO manutencao (data_entrada, data_saida, descricao_servico, custo, id_veiculo) VALUES
('2025-01-10', '2025-01-11', 'Troca de pastilhas de freio.', 450.00, 1),
('2025-04-22', '2025-04-22', 'Alinhamento e Balanceamento.', 180.00, 1),
('2025-09-05', '2025-09-07', 'Reparo no ar-condicionado.', 620.00, 1);


-- CENÁRIO D: Cliente "Premium" com múltiplas locações (para Relatório)
-- Objetivo: Popular dados para o Relatório de Top Clientes
-- (arquivo 11_queries_relatorios.sql), focando no Cliente ID 1 (Rodrigo).

-- (A Cliente 1 já tinha 2 locações no arquivo 02: IDs 1 e 5)
INSERT INTO locacao (id_locacao, data_retirada, data_devolucao_prevista, data_devolucao_real, valor_total_previsto, valor_final, quilometragem_retirada, quilometragem_devolucao, id_cliente, id_veiculo, id_funcionario) VALUES
(6, '2025-02-01 08:00:00', '2025-02-03 08:00:00', '2025-02-03 08:00:00', 361.00, 361.00, 4501, 4750, 1, 2, 1), -- Locação do Virtus
(7, '2025-07-10 12:00:00', '2025-07-17 12:00:00', '2025-07-17 11:30:00', 1750.00, 1750.00, 21001, 22500, 1, 3, 4); -- Locação da X3

INSERT INTO pagamento (data_pagamento, valor, id_locacao, id_forma_pagamento) VALUES
('2025-02-01 08:05:00', 361.00, 6, 1),
('2025-07-10 12:05:00', 1750.00, 7, 3);


-- CENÁRIO E: Locação ativa para Teste de Trigger (Cálculo de Atraso/Multa)
-- Objetivo: Preparar uma locação ativa (ID 8) para ser usada no arquivo 20_triggers.sql.
-- O teste em '20_triggers.sql' irá EXECUTAR o UPDATE desta locação,
-- definindo uma 'data_devolucao_real' POSTERIOR à 'data_devolucao_prevista'.
-- A trigger de UPDATE deverá, então, calcular o 'valor_final' automaticamente
-- (ex: aplicando uma multa sobre o valor previsto).

INSERT INTO locacao (id_locacao, data_retirada, data_devolucao_prevista, data_devolucao_real, valor_total_previsto, valor_final, quilometragem_retirada, quilometragem_devolucao, id_cliente, id_veiculo, id_funcionario) VALUES
(8, '2025-10-25 10:00:00', '2025-10-30 10:00:00', NULL, 600.00, NULL, 15501, NULL, 2, 1, 1); -- Cliente 2 (Matheus) aluga Veículo 1 (Kwid)

INSERT INTO pagamento (data_pagamento, valor, id_locacao, id_forma_pagamento) VALUES
('2025-10-25 10:05:00', 600.00, 8, 2);

-- Como o Veículo 1 (Kwid) estava 'Disponível' (1) e foi alugado acima,
-- seu status deve ser atualizado para 'Alugado' (2) para manter a coerência dos dados.
-- (No futuro, uma trigger de INSERT em 'locacao' poderia fazer isso automaticamente).
UPDATE veiculo SET id_status_veiculo = 2 WHERE id_veiculo = 1;


-- CENÁRIO F: Teste de Conflito de Locação (Trigger de Disponibilidade)
-- Objetivo: Preparar dados para o arquivo 20_triggers.sql.
-- O teste em '20_triggers.sql' tentará inserir uma NOVA locação para o
-- Veículo ID 5 (Hilux), que JÁ ESTÁ ALUGADO (Locação ID 4, do arquivo 02).
-- A trigger de INSERT em 'locacao' deverá BLOQUEAR esta nova inserção.

-- Nenhuns INSERTs são necessários aqui. Os dados do arquivo 02
-- (Locação 4 e Veículo 5, ambos "Alugado") já preparam este cenário.
-- Apenas documentamos que este cenário será testado.
-- FIM DO SCRIPT



