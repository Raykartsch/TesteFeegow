
/* Desafio Estágio de Banco de Dados Feegow
Nome: Italo da Silva Ventura
- Código feito no SQL Server Management Studio 18

OBS: Caso haja erros na execução ao executar o arquivo todo de uma vez, tente executar cada bloco um por um
*/

-- 1) Cite os comandos necessários para a criação das tabelas abaixo.

CREATE DATABASE TesteFeegow

CREATE TABLE banco(
	Codigo int PRIMARY KEY not null ,
	Nome varchar(150) not null,
)

CREATE TABLE agencia(
	Codbanco int not null FOREIGN KEY REFERENCES banco(Codigo) ON UPDATE CASCADE ON DELETE CASCADE,
	Numero_agencia varchar(4) PRIMARY KEY not null ,
	Endereco varchar(300) not null
)

CREATE TABLE cliente (
	cpf varchar(14) PRIMARY KEY not null ,
	Nome varchar(150) not null,
	Sexo varchar(1) not null,
	Endereco varchar(300) not null
)

CREATE TABLE conta(
	Numero_conta varchar(7) PRIMARY KEY not null ,
	Saldo float not null,
	Tipo_conta int not null,
	Num_agencia varchar(4) not null FOREIGN KEY REFERENCES agencia(Numero_agencia) ON UPDATE CASCADE ON DELETE CASCADE,
)

CREATE TABLE historico (
	cpf_cliente varchar(14) not null FOREIGN KEY REFERENCES cliente(cpf) ON UPDATE CASCADE ON DELETE CASCADE,
	Num_conta varchar(7) not null FOREIGN KEY REFERENCES conta(Numero_conta) ON UPDATE CASCADE ON DELETE CASCADE,
	Data_inicio Date not null
)

CREATE TABLE telefone_cliente(
	Cpf_cli varchar(14) not null FOREIGN KEY REFERENCES cliente(cpf) ON UPDATE CASCADE ON DELETE CASCADE,
	Telefone varchar(10) PRIMARY KEY not null
)

/* 
2) 
Descreva todos os comandos para 
acrescentar as tuplas das relações mostrada na figura abaixo de um 
possível estado de banco de dados.
*/

INSERT INTO banco (Codigo, Nome) 
VALUES 
(1, 'Banco do Brasil'), (4, 'CEF')

INSERT INTO agencia (Codbanco, Numero_agencia, Endereco) 
VALUES (1, '3153', 'Av. Marcelino Pires, 1960'), (4, '0562', 'Rua Joaquim Teixeira Alves, 1555')

INSERT INTO cliente (cpf, Nome, Sexo, Endereco)
VALUES (11122233344, 'Jennifer B Souza', 'F', 'Rua Cuiabá, 1050'),
(66677788899, 'Caetano K Lima', 'M', 'Rua Ivinhema, 879'),
(55544477733, 'Silvia Macedo', 'F', 'Rua Estados Unidos, 735')

INSERT INTO conta(Numero_conta, Saldo, Tipo_conta, Num_agencia)
VALUES ('235847', 3879.12, 1, '0562'),
('863402', 763.05, 2, '3153')

INSERT INTO historico(cpf_cliente, Num_conta, Data_inicio) 
VALUES(11122233344, 235847, '1997-12-17'), (66677788899, 235847, '1997-12-17'), (55544477733, 863402, '2010-11-29')

INSERT INTO telefone_cliente (Cpf_cli, Telefone) 
VALUES (11122233344, 6734227788), (66677788899, 6734239900), (66677788899, 6781218833)

--- FIM Inserção

-- Criando funções para facilitar na visualização dos dados

--Função de formatação de CPF
CREATE FUNCTION Formated_Cpf(@CPF VARCHAR(14))
RETURNS VARCHAR(14)
BEGIN
	RETURN CONCAT(SUBSTRING(@CPF,1,3),'.',SUBSTRING(@CPF,4,3),'.',SUBSTRING(@CPF,7,3),'-', SUBSTRING(@CPF,10,2))
END
--FIM
--Função de formatação de Numero da conta
CREATE FUNCTION Formated_Num_Acc(@Num_acc VARCHAR(7))
RETURNS VARCHAR(7)
BEGIN 
	RETURN CONCAT(SUBSTRING(@Num_acc,1,5),'-', SUBSTRING(@Num_acc,6,1))
END
--FIM
--Função de formatação de Telefone
CREATE FUNCTION Formated_Telefon(@Phone VARCHAR(10))
RETURNS VARCHAR(13)
BEGIN 
	RETURN CONCAT('(',SUBSTRING(@Phone,1, 2),')',SUBSTRING(@Phone,3,4), '-', SUBSTRING(@Phone,7, 4))
END
--- FIM

-- Seleção e visualização de todas as tabelas do banco de dados
SELECT * FROM banco

--Tabela Agencia
SELECT Numero_agencia, Endereco, Codbanco FROM agencia ORDER BY Codbanco DESC

-- Tabela Cliente
SELECT
DBO.Formated_Cpf(cliente.cpf) AS CPF, 
Nome, 
Sexo, 
Endereco
FROM cliente ORDER BY CONVERT(INTEGER,(SUBSTRING(Endereco, PATINDEX('%[0-9]%', Endereco), LEN(Endereco)))) DESC

select SUBSTRING(Endereco, PATINDEX('%[0-9]%', Endereco), LEN(Endereco)) FROM cliente

-- Tabela Conta
SELECT 
DBO.Formated_Num_Acc(conta.Numero_conta) AS Numero_Conta,
Saldo, 
Tipo_Conta, 
Num_Agencia
FROM conta ORDER BY Saldo ASC

-- Tabela Histórico
SELECT DBO.Formated_Cpf(historico.cpf_cliente) AS CPF,
DBO.Formated_Num_Acc(historico.Num_conta) AS Numero_conta, 
CONVERT(varchar,historico.Data_inicio,105) AS Data_Inicio FROM historico

-- Telefone Contato
SELECT DBO.Formated_Cpf(telefone_cliente.Cpf_cli) AS CPF,
DBO.Formated_Telefon(telefone_cliente.Telefone) AS Telefone
FROM telefone_cliente

--- FIM

/*3) Utilizando as tabelas e campos do exercício 2, responda:*/

-- a) Criar o campo email na tabela CLIENTE
ALTER TABLE cliente
ADD email varchar(50)

SELECT 
DBO.Formated_CPF(cliente.cpf) 
AS CPF, Nome, Sexo, Endereco FROM cliente

-- b) Apagar o campo email da tabela CLIENTE
ALTER TABLE cliente
DROP COLUMN email

SELECT 
DBO.Formated_CPF(cliente.cpf)  
AS CPF, Nome, Sexo, Endereco FROM cliente

-- c) Na tabela cliente altere o CPF da Silvia Macedo para 222.444.777-33

UPDATE cliente
SET cpf = 22244477733
WHERE Nome = 'Silvia Macedo'

-- d) Exclua a conta 86340-2

DELETE FROM conta WHERE Numero_conta = 863402

-- e) Qual o comando sql para exibir o cpf e o endereço do(s) cliente(s) cujo nome seja Caetano K Lima?

SELECT DBO.Formated_CPF(cliente.cpf) AS CPF, 
Endereco 
FROM cliente WHERE Nome = 'Caetano K Lima'

-- f) Comando para listar o número da sua conta, o número da agência que a controla e o nome do cliente.

USE [TesteFeegow]
GO
CREATE PROCEDURE Busca
@CampoBusca VARCHAR (7)
AS
SELECT 
DBO.Formated_Num_Acc(h.Num_conta) -- Número da Conta
AS Numero_Conta, 
c.Num_agencia, --- Agencia
DBO.Formated_Cpf(cl.cpf) -- CPF
AS CPF --- >
FROM historico AS h
INNER JOIN conta AS c ON h.Num_conta = c.Numero_conta
INNER JOIN cliente as cl ON h.cpf_cliente = cl.cpf 
WHERE Num_conta = @CampoBusca --- Utilizando variável como filtro para a consulta

EXECUTE Busca 235847;

--g) Recupere todos os valores de atributo de qualquer cliente que é do sexo masculino.
SELECT 
cl.Nome, cl.Endereco, cl.Sexo, 
DBO.Formated_CPF(cl.cpf) AS CPF, 
DBO.Formated_Telefon(tc.telefone) AS Telefone,
h.Data_inicio AS Data_Inicio,
b.Nome AS Nome_Banco, 
ag.Numero_agencia AS Numero_Agencia, 
ag.Codbanco AS Código_Banco,
DBO.Formated_Num_Acc(c.Numero_conta) AS Número_Conta_Cl, 
c.Tipo_conta,
c.Saldo AS Saldo
FROM telefone_cliente as tc
INNER JOIN historico AS h ON h.cpf_cliente = tc.Cpf_cli
INNER JOIN conta AS c ON h.Num_Conta = c.Numero_Conta 
INNER JOIN cliente AS cl ON tc.Cpf_cli = cl.cpf 
INNER JOIN agencia AS ag ON c.Num_agencia = ag.Numero_agencia
INNER JOIN banco AS b ON b.Codigo = ag.Codbanco WHERE cl.Sexo = 'M'

-- h) Qual o comando para listar a quantidade de clientes.
SELECT (COUNT(Nome)) AS Contagem FROM cliente

/* Respostas da questão 4 se encontram no arquivo WineStore.sql/*
