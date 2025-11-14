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