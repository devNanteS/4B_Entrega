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

INSERT INTO cargo (id_cargo, nome_cargo, descricao_permissoes) VALUES
(1, 'Atendente', 'Registrar locações, devoluções e pagamentos.'),
(2, 'Gerente', 'Acesso total ao sistema, gerenciar frota e funcionários.'),
(3, 'Mecânico', 'Registrar manutenções e atualizar status de veículos.');

INSERT INTO status_veiculo (id_status_veiculo, descricao_status) VALUES
(1, 'Disponível'),
(2, 'Alugado'), 
(3, 'Em Manutenção'); 

INSERT INTO forma_pagamento (id_forma_pagamento, descricao_pagamento) VALUES
(1, 'Cartão de Crédito'), 
(2, 'Cartão de Débito'), 
(3, 'PIX'), 
(4, 'Dinheiro'); 

INSERT INTO marca (id_marca, nome_marca) VALUES
(1, 'Renault'), 
(2, 'Volkswagen'),
(3, 'BYD'), -- Elétricos
(4, 'FIAT'), 
(5, 'BMW');

INSERT INTO categoria_veiculo (id_categoria_veiculo, nome_categoria, valor_diaria) VALUES
(1, 'Compacto', 120.00),
(2, 'Sedan Médio', 180.50),
(3, 'SUV', 250.00),
(4, 'Picape', 300.00),
(5, 'Elétrico', 350.75);

INSERT INTO endereco (id_endereco, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES
(1, 'Rua do Limoeiro', '123', 'Apto 101', 'Centro', 'São Paulo', 'SP', '01001-000'),
(2, 'Canindé', '1500', 'Sala 502', 'IFSP', 'São Paulo', 'SP', '01310-100'),
(3, 'Morumbi', '800', NULL, 'Morumbis', 'São Paulo', 'SP', '01220-000'),
(4, 'Praça da Sé', '10', NULL, 'Sé', 'São Paulo', 'SP', '01001-001'),
(5, 'Avenida Faria Lima', '4500', 'Andar 10', 'Itaim Bibi', 'São Paulo', 'SP', '04538-133');

INSERT INTO cnh (id_cnh, numero_registro, categoria, data_validade) VALUES
(1, '01234567890', 'B', '2028-05-10'),
(2, '12345678901', 'B', '2026-11-20'),
(3, '23456789012', 'D', '2027-02-15'),
(4, '34567890123', 'AB', '2029-09-30'),
(5, '45678901234', 'B', '2025-12-25');

INSERT INTO cliente (id_cliente, nome_completo, cpf, data_nascimento, telefone, email, tempo_habilitacao_anos, id_endereco, id_cnh) VALUES
(1, 'Rodrigo Nantes', '111.111.111-11', '1983-04-14', '(11) 91111-1111', 'sr.rodrigo@hotmail.com', 20, 1, 1),
(2, 'Matheus Geraldi', '222.222.222-22', '2000-11-20', '(11) 92222-2222', 'chaveirinho@gmail.com', 2, 2, 2),
(3, 'Fabrizio San Felipe', '333.333.333-33', '1998-11-26', '(11) 93333-3333', 'fafa.san@aluno.ifsp.edu.br', 10, 3, 3),
(4, 'Japones Liuyji Uehara', '444.444.444-44', '1946-06-17', '(11) 94444-4444', 'gui.liuyji@aluno.ifsp.com.br', 40, 4, 4),
(5, 'Yuri de Argolo', '555.555.555-55', '2000-01-01', '(11) 95555-5555', 'yuri@aluno.ifsp.edu.br', 7, 5, 5);

INSERT INTO funcionario (id_usuario, nome, email, senha, id_cargo) VALUES
(1, 'Pietro di Luca', 'jundiai.atendente@locadora.com', 'hash_senha_123', 1),
(2, 'Leonardo Nantes', 'NanteS.gerente@locadora.com', 'hash_senha_456', 2),
(3, 'Claudete', 'Claudete.mecanico@locadora.com', 'hash_senha_789', 3),
(4, 'Leonardo Motta', 'motta.atendente@locadora.com', 'hash_senha_111', 1),
(5, 'Ricardo Agostinho', 'ricardinho.gerente@locadora.com', 'hash_senha_222', 2);

INSERT INTO modelo (id_modelo, nome_modelo, id_marca, id_categoria_veiculo) VALUES
(1, 'kwid', 1, 1),        -- Renault, compacto
(2, 'Virtus', 2, 2),     -- VW, Sedan
(3, 'X3', 5, 3),    -- BMW, SUV
(4, 'Dolphin', 3, 5),       -- byd, elétrico
(5, 'Toro', 4, 4);      -- Fiat, Picape



INSERT INTO veiculo (id_veiculo, placa, ano, cor, chassi, quilometragem, id_modelo, id_status_veiculo) VALUES
(1, 'RBC1A23', 2024, 'Branco', '9BWDA08T0P1234567', 15000, 1, 1), -- Kwid, Disponível
(2, 'SCD2B34', 2023, 'Preto', '9BWEA08T0P2345678', 5000, 2, 1),  -- Virtus, Disponível
(3, 'TDE3C45', 2022, 'Azul', '9BWFA08T0P3456789', 25000, 3, 1), -- BMW, Disponível
(4, 'UFG4D56', 2021, 'Prata', '9BWGA08T0P4567890', 40000, 4, 3), -- Dolphin, Em Manutenção
(5, 'VHI5E67', 2023, 'Vermelho', '9BWHA08T0P5678901', 10000, 5, 2); -- Toro, Alugado


INSERT INTO manutencao (id_manutencao, data_entrada, data_saida, descricao_servico, custo, id_veiculo) VALUES
(1, '2025-10-28', NULL, 'Revisão dos 40.000km, troca de óleo e filtros.', 850.00, 4), -- Manutenção ativa do Dolphin
(2, '2025-06-15', '2025-06-16', 'Troca de pneus dianteiros.', 1200.00, 1); -- Manutenção passada do kwid

INSERT INTO locacao (id_locacao, data_retirada, data_devolucao_prevista, data_devolucao_real, valor_total_previsto, valor_final, quilometragem_retirada, quilometragem_devolucao, id_cliente, id_veiculo, id_funcionario) VALUES
(1, '2025-10-01 10:00:00', '2025-10-05 10:00:00', '2025-10-05 09:30:00', 480.00, 480.00, 10000, 10500, 1, 1, 1), -- Locação passada (Kwid)
(2, '2025-10-10 14:00:00', '2025-10-15 14:00:00', '2025-10-15 14:10:00', 902.50, 902.50, 4000, 4500, 2, 2, 4), -- Locação passada (Virtus)
(3, '2025-10-20 09:00:00', '2025-10-25 09:00:00', '2025-10-25 09:00:00', 1250.00, 1250.00, 20000, 21000, 3, 3, 1), -- Locação passada (BMW)
(4, '2025-10-30 15:00:00', '2025-11-10 15:00:00', NULL, 3000.00, NULL, 10000, NULL, 4, 5, 2), -- Locação ativa (Toro, Status 2)
(5, '2025-10-22 11:00:00', '2025-10-24 11:00:00', '2025-10-24 18:00:00', 240.00, 300.00, 10500, 11000, 5, 1, 4); -- Locação passada (Kwid), devolveu com atraso

INSERT INTO pagamento (id_pagamento, data_pagamento, valor, id_locacao, id_forma_pagamento) VALUES
(1, '2025-10-01 10:05:00', 480.00, 1, 1), -- Pgto Locação 1 (Crédito)
(2, '2025-10-10 14:05:00', 902.50, 2, 2), -- Pgto Locação 2 (Débito)
(3, '2025-10-20 09:05:00', 1250.00, 3, 3), -- Pgto Locação 3 (PIX)
(4, '2025-10-30 15:05:00', 1500.00, 4, 1), -- Pgto Locação 4 (Sinal 50% no Crédito)
(5, '2025-10-24 18:05:00', 300.00, 5, 3); -- Pgto Locação 5 (PIX)

INSERT INTO opcional (id_opcional, descricao, valor_diaria, quantidade, id_locacao) VALUES
(1, 'Cadeira de Bebê', 25.00, 1, 2), -- Para Locação 2
(2, 'GPS', 15.00, 1, 3), -- Para Locação 3
(3, 'Cadeira de Bebê', 25.00, 2, 4), -- Para Locação 4
(4, 'Bagageiro de Teto', 40.00, 1, 4); -- Para Locação 4


