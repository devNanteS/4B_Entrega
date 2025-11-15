/*
============================================================
  Arquivo: 21_procedures.sql
  Autor(es):
    Leonardo Giannoccaro Nantes
    Pietro di Luca Monte Souza Balbino
    Matheus Gonçalves Domingues Geraldi
    Guilherme Liyuji Aoki Uehara

  Trabalho: Locação de Veículos
  Curso/Turma: DS 213
  SGBD: MySQL Versão: 8.0
  Objetivo: Criação de procedures e functions (opcional).
  Execução esperada: rodar após o 01_modelo_fisico.sql
==========================================================
*/

USE locadora;

DELIMITER //

-- Procedure 1: Registrar uma Nova Locação com Segurança

-- Motivação:
-- Automatiza o processo de registrar uma locação, garantindo
-- que o veículo esteja 'Disponível' (Status 1) e
-- atualizando seu status para 'Alugado' (Status 2).


CREATE PROCEDURE sp_registrar_locacao (
    IN p_id_cliente INT,
    IN p_id_veiculo INT,
    IN p_id_funcionario INT,
    IN p_data_devolucao_prevista DATETIME
)
BEGIN
    DECLARE v_status_veiculo INT;
    DECLARE v_quilometragem_atual INT;
    DECLARE v_valor_diaria DECIMAL(10, 2);
    DECLARE v_total_dias INT;
    DECLARE v_valor_previsto DECIMAL(10, 2);

    SELECT id_status_veiculo, quilometragem INTO v_status_veiculo, v_quilometragem_atual
    FROM veiculo
    WHERE id_veiculo = p_id_veiculo;

    IF v_status_veiculo != 1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'ERRO: Veículo não está "Disponível". Locação cancelada.';
    ELSE

        SELECT cv.valor_diaria INTO v_valor_diaria
        FROM veiculo v
        JOIN modelo m ON v.id_modelo = m.id_modelo
        JOIN categoria_veiculo cv ON m.id_categoria_veiculo = cv.id_categoria_veiculo
        WHERE v.id_veiculo = p_id_veiculo;

        SET v_total_dias = CEILING(TIMESTAMPDIFF(HOUR, NOW(), p_data_devolucao_prevista) / 24.0);
        IF v_total_dias <= 0 THEN SET v_total_dias = 1; END IF;

        SET v_valor_previsto = v_total_dias * v_valor_diaria;

        INSERT INTO locacao (
            data_retirada, data_devolucao_prevista, valor_total_previsto,
            quilometragem_retirada, id_cliente, id_veiculo, id_funcionario
        ) VALUES (
            NOW(), p_data_devolucao_prevista, v_valor_previsto,
            v_quilometragem_atual, p_id_cliente, p_id_veiculo, p_id_funcionario
        );

        UPDATE veiculo
        SET id_status_veiculo = 2
        WHERE id_veiculo = p_id_veiculo;

        SELECT 'Locação registrada com sucesso!' AS Resultado;

    END IF;
END;
//

-- Function 1: Calcular Total de Dias de uma Locação

-- Motivação:
-- Cria uma função reutilizável para calcular o número de dias
-- de uma locação (real ou prevista), arredondando para cima.

CREATE FUNCTION fn_calcular_diarias (
    f_data_inicio DATETIME,
    f_data_fim DATETIME
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_total_dias INT;

    SET v_total_dias = CEILING(
        TIMESTAMPDIFF(HOUR, f_data_inicio, f_data_fim) / 24.0
    );

    IF v_total_dias <= 0 THEN
        SET v_total_dias = 1;
    END IF;

    RETURN v_total_dias;
END;
//

DELIMITER ;


-- TESTES PARA COMPROVAR O FUNCIONAMENTO

/*
-- TESTE DA PROCEDURE 1 (Registrar Locação)
-- Tenta alugar o Veículo 2 (Virtus), que está 'Disponível' (ID 1), para o Cliente 5 (Yuri de Argolo).
-- Aluga o Veículo 3 (X3), que está disponível (ID 1), para o Cliente 2 (Matheus Geraldi).

CALL sp_registrar_locacao(5, 2, 1, NOW() + INTERVAL 3 DAY);

SELECT * FROM locacao ORDER BY id_locacao DESC LIMIT 1;
SELECT id_veiculo, placa, id_status_veiculo FROM veiculo WHERE id_veiculo = 2;

CALL sp_registrar_locacao(2, 3, 1, NOW() + INTERVAL 2 DAY);

SELECT * FROM locacao ORDER BY id_locacao DESC LIMIT 1;
SELECT id_veiculo, placa, id_status_veiculo FROM veiculo WHERE id_veiculo = 3;

*/

/*
-- TESTE DA FUNCTION 1 (Calcular Diárias)
-- Vamos usar a função para calcular as diárias de locações existentes.

SELECT
    id_locacao,
    data_retirada,
    data_devolucao_prevista,
    fn_calcular_diarias(data_retirada, data_devolucao_prevista) AS dias_previstos,
    data_devolucao_real,
    fn_calcular_diarias(data_retirada, data_devolucao_real) AS dias_reais
FROM
    locacao
WHERE
    id_locacao IN (4, 5, 8);
*/
