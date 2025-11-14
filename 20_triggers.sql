/*
============================================================
  Arquivo: 20_triggers.sql
  Autor(es):
    Leonardo Giannoccaro Nantes
    Matheus Gonçalves Domingues Geraldi
    Pietro di Luca Monte Souza Balbino
    Guilherme Liyuji Aoki Uehara

  Trabalho: Locação de Veículos
  Curso/Turma: DS 213
  SGBD: MySQL Versão: 8.0
  Objetivo: Criação de triggers (gatilhos) para
            automatizar/validar regras de negócio.
  Execução esperada: rodar após os scripts 01, 02 e 03.
==========================================================
*/

USE locadora;

DELIMITER //

-- Trigger 1: Bloqueio de Locação por CNH Vencida
--
-- Tabela: locacao
-- Evento: BEFORE INSERT (Antes de inserir uma nova locação)
-- O que faz: Verifica se a data de validade da CNH do cliente
--            é anterior à data de hoje (CURDATE()). Se for,
--            a inserção é bloqueada com uma mensagem de erro.
-- Teste usa: Cenário A (Cliente ID 6, Joaozin do Erro)

CREATE TRIGGER trg_bloqueia_locacao_cnh_vencida
BEFORE INSERT ON locacao
FOR EACH ROW
BEGIN
    DECLARE data_vencimento_cnh DATE;

    SELECT c.data_validade INTO data_vencimento_cnh
    FROM cliente cl
    JOIN cnh c ON cl.id_cnh = c.id_cnh
    WHERE cl.id_cliente = NEW.id_cliente;

    IF data_vencimento_cnh < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'ERRO: A CNH deste cliente está vencida. Locação bloqueada.';
    END IF;
END;
//


-- Trigger 2 Cálculo de Multa por Atraso
--
-- Tabela: locacao
-- Evento: BEFORE UPDATE
-- O que faz: Se a 'data_devolucao_real' for maior que a
--            'data_devolucao_prevista', calcula um novo
--            'valor_final' com base em:
--            1. Valor Previsto +
--            2. Multa Fixa (20% sobre o previsto) +
--            3. Multa Diária (R$ 400,00 * dias_em_atraso)
-- Teste usa: Cenário E (Locação ID 8)

CREATE TRIGGER trg_calcula_multa_atraso
BEFORE UPDATE ON locacao
FOR EACH ROW
BEGIN
    DECLARE dias_de_atraso INT DEFAULT 0;
    DECLARE valor_multa_fixa DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE valor_multa_diaria DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE taxa_diaria_atraso DECIMAL(10, 2) DEFAULT 400.00;
    DECLARE percentual_multa_fixa DECIMAL(4, 2) DEFAULT 0.20; 

    IF NEW.data_devolucao_real IS NOT NULL AND
       OLD.data_devolucao_real IS NULL AND
       NEW.data_devolucao_real > OLD.data_devolucao_prevista
	THEN
        SET dias_de_atraso = CEILING(
            TIMESTAMPDIFF(HOUR, OLD.data_devolucao_prevista, NEW.data_devolucao_real) / 24.0
        );

        SET valor_multa_fixa = OLD.valor_total_previsto * percentual_multa_fixa;
        SET valor_multa_diaria = dias_de_atraso * taxa_diaria_atraso;

        SET NEW.valor_final = OLD.valor_total_previsto + valor_multa_fixa + valor_multa_diaria;

    ELSEIF NEW.data_devolucao_real IS NOT NULL AND
           OLD.data_devolucao_real IS NULL
    THEN
        SET NEW.valor_final = OLD.valor_total_previsto;
    END IF;
END;
//

DELIMITER ;


-- TESTE DA TRIGGER 1 (CNH Vencida - Cenário A)

-- Insira uma locação para o Cliente 6 (Joaozin do Erro),
-- que tem uma CNH vencida desde 2020.

-- RESULTADO ESPERADO: O comando deve FALHAR e mostrar a
-- mensagem de erro: "ERRO: A CNH deste cliente está vencida."

INSERT INTO locacao (data_retirada, data_devolucao_prevista, valor_total_previsto,
quilometragem_retirada, id_cliente, id_veiculo, id_funcionario)
VALUES
('2025-11-05 10:00:00', '2025-11-10 10:00:00', 600.00, 16000, 6, 1, 1);


-- TESTE DA TRIGGER 2 (Multa por Atraso - Cenário E)

-- 1. A Locação 8 (Matheus Geraldi) está em aberto.
SELECT * FROM locacao WHERE id_locacao = 8;
-- (valor_final e data_devolucao_real estão NULL)

-- 2. O carro em atraso será devolvido
-- Previsto: 2025-10-30 10:00:00
-- Real: 2025-11-01 12:00:00

UPDATE locacao
SET
    data_devolucao_real = '2025-11-01 12:00:00',
    quilometragem_devolucao = 16500
WHERE
    id_locacao = 8;

-- 3. RESULTADO ESPERADO: A trigger deve ter calculado o novo
-- valor_final para R$ 1.920,00 (600 + 120 + 1200).

SELECT * FROM locacao WHERE id_locacao = 8;
