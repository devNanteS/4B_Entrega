/*
============================================================
  Arquivo: 90_verificacoes_pos_execucao.sql
  Autor(es):
    Leonardo Giannoccaro Nantes
    Pietro di Luca Monte Souza Balbino
    Matheus Gonçalves Domingues Geraldi
    Guilherme Liyuji Aoki Uehara
  Trabalho: Locação de Veículos
  Curso/Turma: DS 213
  SGBD: MySQL Versão: 8.0
  Objetivo: Checagens rápidas para validar a base
            pós-execução de todos os scripts.
==========================================================
*/

USE locadora;

-- Verificação 1: Contagem de Linhas
-- O que comprova: Que todos os scripts de inserção (02 e 03) rodaram.

SELECT 'cliente' AS tabela, COUNT(*) AS total_linhas FROM cliente
UNION ALL
SELECT 'veiculo' AS tabela, COUNT(*) FROM veiculo
UNION ALL
SELECT 'locacao' AS tabela, COUNT(*) FROM locacao
UNION ALL
SELECT 'funcionario' AS tabela, COUNT(*) FROM funcionario
UNION ALL
SELECT 'manutencao' AS tabela, COUNT(*) FROM manutencao
UNION ALL
SELECT 'endereco' AS tabela, COUNT(*) FROM endereco
UNION ALL
SELECT 'seguro' AS tabela, COUNT(*) FROM seguro -- <-- NOVA TABELA
UNION ALL
SELECT 'combustivel' AS tabela, COUNT(*) FROM combustivel -- <-- NOVA TABELA
UNION ALL
SELECT 'usuario' AS tabela, COUNT(*) FROM usuario; -- <-- NOVA TABELA

-- Resultado esperado (aproximado, com base nos scripts):
-- cliente (7), veiculo (12), locacao (10), funcionario (5), manutencao (5)
-- endereco (12), seguro (12), combustivel (5), usuario (5)


-- Verificação 2: Status da Frota
-- O que comprova: Que os scripts de teste (02, 03) definiram os status.

SELECT
    sv.descricao_status,
    COUNT(v.id_veiculo) AS quantidade
FROM veiculo v
JOIN status_veiculo sv ON v.id_status_veiculo = sv.id_status_veiculo
GROUP BY sv.descricao_status;

-- Resultado esperado:
-- 1 (Kwid): 'Alugado' (pelo Cenário E)
-- 2 (Virtus): 'Disponível'
-- 3 (X3): 'Disponível'
-- 4 (Dolphin): 'Em Manutenção' (pelo script 02)
-- 5 (Toro): 'Alugado' (pelo script 02)
-- 6-10 (Novos): 'Disponível'
-- 11-12 (carros do teste da valor_combustivel) : 'Alugado' ( para o Cenário G )
-- TOTAL: Disponível (7), Alugado (4), Em Manutenção (1)


-- Verificação 3: Cliente de Teste de CNH (Cenário A)
-- O que comprova: Que o cliente "armadilha" ('Joaozin do Erro') para a trigger 1 está cadastrado.
SELECT
    cl.id_cliente,
    cl.nome_completo,
    c.data_validade
FROM cliente cl
JOIN cnh c ON cl.id_cnh = c.id_cnh
WHERE cl.nome_completo = 'Joaozin do Erro';
-- Resultado esperado: 'Joaozin do Erro' com data_validade '2020-01-01'.

-- Verificação 4: Funcionários com Novos Dados
-- O que comprova: Que os funcionários foram inseridos com endereços e CPFs (colunas novas).
SELECT
    f.nome,
    f.cpf,
    e.logradouro
FROM funcionario f
JOIN endereco e ON f.id_endereco = e.id_endereco;
-- Resultado esperado: 5 funcionários, cada um com um CPF e um Endereço.

-- Verificação 5: Cálculo Automático (Trigger 3)
-- O que comprova: Que a Trigger 3 ('trg_calcula_valor_fracao_veiculo')
--               funcionou durante o script 02.

SELECT
    placa,
    tanque,
    valor_fracao,
    (tanque * 6) / 8 + 5 AS calculo_esperado
FROM veiculo
WHERE id_veiculo IN (1, 2, 3, 5, 6, 8, 9, 10); -- (Excluindo elétricos/manutenção)

-- Resultado esperado: As colunas 'valor_fracao' e 'calculo_esperado' devem ter valores idênticos (ou muito próximos).
