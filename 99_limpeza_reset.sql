/*
============================================================
  Arquivo: 99_limpeza_reset.sql
  Autor(es):
    Leonardo Giannoccaro Nantes
    Pietro di Luca Monte Souza Balbino
    Matheus Gonçalves Domingues Geraldi
    Guilherme Liyuji Aoki Uehara

  Trabalho: Locação de Veículos
  Curso/Turma: DS 213
  SGBD: MySQL Versão: 8.0
  Objetivo: Limpar (TRUNCATE/DROP) o banco de dados
            para reiniciar os testes.
  Execução esperada: rodar por último, apaga TUDO.
==========================================================
*/

use locadora;
DROP DATABASE IF EXISTS locadora;
SELECT 'Banco de dados "locadora" removido com sucesso.' AS Resultado;
