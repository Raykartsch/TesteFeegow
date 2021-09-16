
/* 4)

a) Qual comando para criar a base de dados winestore?*/
CREATE DATABASE WineStore

-- Populando a base de dados
CREATE TABLE Regiao (
	id_regiao int PRIMARY KEY IDENTITY(1, 1),
	nome varchar(100)
)

CREATE TABLE Vinicula(
	id int PRIMARY KEY IDENTITY(1, 1),
	nome varchar(100) not null,
	pais varchar(70) not null,
	fk_id_regiao int not null FOREIGN KEY REFERENCES regiao(id_regiao)
)

CREATE TABLE Tipo(
	id int PRIMARY KEY IDENTITY(1, 1),
	tipo varchar(50)
)

CREATE TABLE Vinho(
	id int PRIMARY KEY IDENTITY(1, 1),
	nome varchar(100) not null,
	ano Date not null,
	valor NUMERIC(8, 4) not null,
	fk_id_vinicula int not null FOREIGN KEY REFERENCES Vinicula(id),
	fk_id_tipo int not null FOREIGN KEY REFERENCES Tipo(id)
)

CREATE TABLE Cliente(
	id int PRIMARY KEY IDENTITY(1, 1),
	nome varchar(100),
	endereco varchar(200),
	cidade varchar(70),
	estado varchar(50)
)

CREATE TABLE Reserva(
	id int PRIMARY KEY IDENTITY(1, 1),
	qtd int DEFAULT 1,
	data_r Date not null,
	fk_id_cliente int not null FOREIGN KEY REFERENCES Cliente(id),
	fk_id_vinho int not null FOREIGN KEY REFERENCES Vinho(id)
)

INSERT INTO Regiao (nome) 
VALUES 
('Guadalupe'), 
('Stuttgart'), 
('Venezia Giulia')

INSERT INTO Regiao (nome)
VALUES
('Petropolis'),
('Veneza')


INSERT INTO Vinicula (fk_id_regiao, nome, pais) 
VALUES 
(1,'Vin Doux', 'França'), 
(2,'WeinHaus', 'Alemanha'), 
(3, 'Uccello', 'Italia'),
(4,'Vinhedo do Corvo Bianco', 'Brasil'), 
(4,'Casa do Vinho', 'Brasil'), 
(5, 'Vinhezart', 'Italia')

INSERT INTO Tipo (tipo) VALUES ('Vinho tinto'), ('Vinho branco')

INSERT INTO Vinho (nome, ano, valor, fk_id_vinicula, fk_id_tipo) 
VALUES 
('Vermentino', '2016-10-29', 250, 1, 1), 
('Beelgard', '2017-08-27', 300, 2, 1), 
('Bell Monte', '2019-10-30', 275, 3, 2),
('Pergola', '2021-02-21', 250, 4, 2), 
('Coronata', '2011-07-27', 900, 5, 2), 
('Chateau', '2009-11-13', 1200, 6, 1) 

INSERT INTO Cliente (nome, endereco, cidade, estado)
VALUES 
('Italo', 'Rua da Barra, 0', 'Rio de Janeiro', 'Rio de Janeiro'),
('Francisca', 'Rua dos Passaros, 7', 'Uberlandia', 'Minas Gerais'),
('Eilane', 'Estrada Miguel Salazar, 200', 'Rio de Janeiro', 'Rio de Janeiro'),
('Gustavo', 'Rua Salomao, 240', 'Sao Paulo', 'Sao Paulo')


INSERT INTO Reserva (qtd, data_r, fk_id_cliente, fk_id_vinho)
VALUES 
(3, '2019-01-18', 1, 1),
(1, '2018-10-18', 2, 3),
(4, '2017-10-18', 2, 2),
(2, '2021-01-18', 1, 1)

INSERT INTO Reserva (qtd, data_r, fk_id_cliente, fk_id_vinho)
VALUES 
(5, '2018-10-18', 1, 1)

-- Fim>


-- b) Comando para exibir a união entre os clientes e vinhos.
SELECT cl.id AS Id_Cliente, cl.Nome AS Nome_Cliente, rsv.qtd AS Qtd_Reserva, v.nome AS Nome_Vinho, v.ano AS Ano_Fabricação, rsv.data_r AS Data_Reserva
FROM Cliente AS cl
INNER JOIN Reserva as rsv ON cl.id = rsv.fk_id_cliente
INNER JOIN Vinho as v ON rsv.fk_id_vinho = v.id

--c) Mostrar as reservas realizadas antes de 21/01/2019.
SELECT 
rsv.id AS ID_Reserva, 
rsv.qtd AS Qtd_Reserva,
cl.nome AS Nome_Cliente,
v.nome AS Nome_Vinho,
rsv.data_r AS Data_Reserva
FROM Reserva as rsv
INNER JOIN Vinho AS v ON rsv.fk_id_vinho = v.id 
INNER JOIN Cliente as cl ON rsv.fk_id_cliente = cl.id
WHERE rsv.data_r <= '2019-01-21'

-- d)Exibir todos os clientes que não possuem reservas
SELECT Nome from Cliente
WHERE id NOT IN (SELECT fk_id_cliente FROM Reserva)

--e) Mostrar as reservas realizadas somente no mês de Outubro de 2018.
SELECT rsv.id AS Id_Reserva,
rsv.qtd AS Qtd_Reserva, 
cl.nome AS Nome_Cliente, 
rsv.data_r AS Data_Reserva, 
v.nome AS Nome_Vinho,
tp.tipo AS Tipo_Vinho 
FROM Reserva AS rsv 
INNER JOIN Cliente as cl ON cl.id = rsv.fk_id_cliente 
INNER JOIN Vinho as v ON rsv.fk_id_vinho = v.id
INNER JOIN Tipo as tp ON tp.id = v.fk_id_tipo WHERE YEAR(rsv.data_r) = '2018' AND MONTH(rsv.data_r) = '10'

--f) Crie uma visão que contenha o nome, ano e a qual vinícola pertence todos os vinhos.
CREATE VIEW [vwWines] 
AS SELECT v.id AS ID_Vinho, 
v.nome AS Nome_Vinho, 
tp.id AS Tipo_Vinho, 
v.ano AS Ano_Fabricação, 
vnc.nome AS Nome_Vinicula,
rg.nome AS Regiao_Vinicula
FROM Vinho AS v
INNER JOIN Vinicula as vnc ON vnc.id = v.fk_id_vinicula
INNER JOIN Tipo as tp ON v.fk_id_tipo = tp.id
INNER JOIN Regiao as rg ON vnc.fk_id_regiao = rg.id_regiao

SELECT * FROM vwWines

- FIM