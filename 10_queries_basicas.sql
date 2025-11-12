/*
============================================================
  Arquivo: 11_queries_relatorios.sql
  Autor(es):
   
	Leonardo Giannoccaro Nantes
	Pietro di Luca Monte Souza Balbino
	Matheus Gonçalves Domingues Geraldi
	Guilherme Liyuji Aoki Uehara

  Trabalho: Locação de Veículos
  Curso/Turma: DS 213
  SGBD: MySQL Versão: 8.0
  Objetivo: Consultas "de relatório" que respondem
            a perguntas de negócio.
  Execução esperada: rodar após os scripts 01, 02 e 03.
==========================================================
*/

USE locadora;

-- Relatório 1: Histórico de Manutenção de um Veículo Específico
--
-- Problema que responde:
-- "Qual é o histórico completo de manutenções de um veículo específico
-- (ex: Placa 'RBC1A23') e quanto já gastamos com ele?"
--
-- Abordagem:
-- Filtramos pelo ID_Veiculo (ou Placa) e usamos SUM() para totalizar
-- o custo das manutenções que JÁ FORAM CONCLUÍDAS (DataSaida não é nula).
-- ---
SELECT
    v.placa,
    mo.nome_modelo,
    m.data_entrada,
    m.data_saida,
    m.descricao_servico,
    m.custo
FROM
    manutencao AS m
JOIN
    veiculo AS v ON m.id_veiculo = v.id_veiculo
JOIN
    modelo AS mo ON v.id_modelo = mo.id_modelo
WHERE
    v.placa = 'RBC1A23' -- (Veículo do Cenário C)
ORDER BY
    m.data_entrada DESC;

-- Relatório 1 (Complemento): Custo total de manutenção concluída do veículo
SELECT
    v.placa,
    SUM(m.custo) AS custo_total_manutencoes_concluidas
FROM
    manutencao AS m
JOIN
    veiculo AS v ON m.id_veiculo = v.id_veiculo
WHERE
    v.placa = 'RBC1A23'
    AND m.data_saida IS NOT NULL
GROUP BY
    v.placa;


-- ---
-- Relatório 2: Top 5 Clientes (Clientes "Premium")
--
-- Problema que responde:
-- "Quem são nossos 5 clientes mais valiosos? (que mais gastaram
-- em locações concluídas)"
--
-- Abordagem:
-- Somamos (SUM) o 'valor_final' da tabela 'locacao' para todas as
-- locações que já foram concluídas (data_devolucao_real IS NOT NULL).
-- Agrupamos por cliente e ordenamos do maior para o menor, limitando a 5.
-- (Usando dados do Cenário D)
-- ---
SELECT
    c.nome_completo,
    c.email,
    c.telefone,
    COUNT(l.id_locacao) AS total_de_locacoes_concluidas,
    SUM(l.valor_final) AS valor_total_gasto
FROM
    locacao AS l
JOIN
    cliente AS c ON l.id_cliente = c.id_cliente
WHERE
    l.data_devolucao_real IS NOT NULL
    AND l.valor_final IS NOT NULL
GROUP BY
    c.id_cliente, c.nome_completo, c.email, c.telefone
ORDER BY
    valor_total_gasto DESC
LIMIT 5;

-- ---
-- Relatório 3: Visão Geral da Frota (Status e Taxa de Ocupação)
--
-- Problema que responde:
-- "Quantos carros temos em cada status (Disponível, Alugado, Manutenção)?
-- E qual a taxa de ocupação da frota?"
--
-- Abordagem:
-- Usamos um JOIN entre 'status_veiculo' e 'veiculo' e agrupamos (GROUP BY)
-- pelo status, contando (COUNT) os veículos em cada um.
-- O (SELECT ... / total_veiculos) é uma SubQuery para calcular o percentual.
-- ---
SELECT
    sv.descricao_status,
    COUNT(v.id_veiculo) AS quantidade_de_veiculos,
    (COUNT(v.id_veiculo) / (SELECT COUNT(*) FROM veiculo)) * 100 AS porcentagem_da_frota
FROM
    status_veiculo AS sv
JOIN
    veiculo AS v ON sv.id_status_veiculo = v.id_status_veiculo
GROUP BY
    sv.id_status_veiculo, sv.descricao_status
ORDER BY
    quantidade_de_veiculos DESC;

