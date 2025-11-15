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

-- Consulta 1: Listagem Simples com Filtro (WHERE) e Ordenação (ORDER BY)
-- Objetivo: Listar todos os clientes que NÃO moram em 'São Paulo'
-- (para ver os clientes de teste que inserimos).

SELECT
    nome_completo,
    email,
    telefone,
    cpf,
    cidade,
    estado
FROM
    cliente
JOIN
    endereco ON cliente.id_endereco = endereco.id_endereco
WHERE
    endereco.cidade != 'São Paulo'
ORDER BY
    nome_completo ASC;

-- Consulta 2: JOIN entre 3 tabelas com Filtro (WHERE)
-- Objetivo: Mostrar todas as locações que ainda estão ativas
-- (sem data de devolução real).

SELECT
    l.id_locacao,
    l.data_retirada,
    l.data_devolucao_prevista,
    c.nome_completo AS nome_do_cliente,
    v.placa AS placa_do_veiculo,
    v.transmissao
FROM
    locacao AS l
JOIN
    cliente AS c ON l.id_cliente = c.id_cliente
JOIN
    veiculo AS v ON l.id_veiculo = v.id_veiculo
WHERE
    l.data_devolucao_real IS NULL;
-- Resultado esperado: Locação 4 (Japones Liuyji) e 8 (Matheus Geraldi)

-- Consulta 3: Agregação (GROUP BY) com JOIN
-- Objetivo: Contar quantos veículos da frota pertencem a cada marca.

SELECT
    m.nome_marca,
    COUNT(v.id_veiculo) AS quantidade_de_veiculos
FROM
    veiculo AS v
JOIN
    modelo AS mo ON v.id_modelo = mo.id_modelo
JOIN
    marca AS m ON mo.id_marca = m.id_marca
GROUP BY
    m.nome_marca
ORDER BY
    quantidade_de_veiculos DESC;
-- Resultado esperado: Renault, Volkswagen, BYD, FIAT, BMW

-- Consulta 4: Agregação (GROUP BY) com Filtro de Grupo (HAVING)
-- Objetivo: Calcular o valor total já pago por cada cliente,
-- mostrando apenas os clientes que gastaram mais de R$ 1000,00 no total.

SELECT
    c.nome_completo,
    SUM(p.valor) AS valor_total_gasto
FROM
    pagamento AS p
JOIN
    locacao AS l ON p.id_locacao = l.id_locacao
JOIN
    cliente AS c ON l.id_cliente = c.id_cliente
GROUP BY
    c.id_cliente, c.nome_completo
HAVING
    valor_total_gasto > 1000.00
ORDER BY
    valor_total_gasto DESC;
-- Resultado esperado: Rodrigo Nantes, Matheus Geraldi, Japones Liuyji, Fabrizio San Felipe


-- Consulta 5: JOIN Múltiplo com Filtros complexos (WHERE ... AND)
-- Objetivo: Listar detalhes do veículo elétrico (Categoria 'Elétrico')
-- da marca 'BYD'.

SELECT
	mo.nome_modelo,
	ma.nome_marca,
    v.placa,
    v.ano,
    v.cor,
    v.quilometragem,
    c.tipo_combustivel
FROM
    veiculo AS v
JOIN
    modelo AS mo ON v.id_modelo = mo.id_modelo
JOIN
    combustivel AS c ON v.id_combustivel = c.id_combustivel
JOIN
    marca AS ma ON mo.id_marca = ma.id_marca

WHERE
	ma.nome_marca = 'BYD';
-- Resultado esperado: Veículo 4 (Dolphin), Veículo 7 (Seal) e Veículo 12 (Seal).



