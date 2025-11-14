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
  Execução esperada: rodar por último (antes do reset).
==========================================================
*/

USE locadora;

-- Verificação 1: Contagem de Linhas
-- O que comprova: Que todos os scripts de inserção (02 e 03) rodaram.

SELECT 'cliente' AS tabela, COUNT(*) AS total_linhas FROM cliente
UNION
SELECT 'veiculo' AS tabela, COUNT(*) FROM veiculo
UNION
SELECT 'locacao' AS tabela, COUNT(*) FROM locacao
UNION
SELECT 'funcionario' AS tabela, COUNT(*) FROM funcionario
UNION
SELECT 'manutencao' AS tabela, COUNT(*) FROM manutencao;

-- Resultado esperado: cliente (7), veiculo (5), locacao (8), funcionario (5), manutencao (4)


-- Verificação 2: Status da Frota
-- O que comprova: Que os scripts de teste (02, 03) e as
-- procedures (21) atualizaram corretamente o status dos veículos.

SELECT
    v.id_veiculo,
    v.placa,
    s.descricao_status
FROM veiculo v
JOIN status_veiculo s ON v.id_status_veiculo = s.id_status_veiculo
ORDER BY v.id_veiculo;

-- Resultado esperado:
-- 1 (Kwid): Alugado (pelo Cenário E)
-- 2 (Virtus): Disponível (ou Alugado, se você rodar o teste da SP_Locacao)
-- 3 (X3): Disponível
-- 4 (Dolphin): Em Manutenção (pelo script 02)
-- 5 (Toro): Alugado (pelo script 02)


-- Verificação 3: Cliente de Teste de CNH (Cenário A)
-- O que comprova: Que o cliente "armadilha" para a
-- trigger 1 está cadastrado corretamente.

SELECT
    cl.id_cliente,
    cl.nome_completo,
    c.numero_registro,
    c.data_validade
FROM cliente cl
JOIN cnh c ON cl.id_cnh = c.id_cnh
WHERE cl.nome_completo = 'Joaozin do Erro';

-- Resultado esperado: Deve mostrar o 'Joaozin do Erro' com data_validade '2020-01-01'.

-- Verificação 4: Cliente de Teste de Habilitação (Cenário B)
-- O que comprova: Que o cliente "armadilha" para a
-- regra de negócio (não implementada em trigger) está correto.

SELECT nome_completo, tempo_habilitacao_anos
FROM cliente
WHERE nome_completo = 'Bianca Novata';

-- Resultado esperado: Deve mostrar 'Bianca Novata' com '1' ano.
