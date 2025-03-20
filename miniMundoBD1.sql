CREATE DATABASE IF NOT EXISTS miniMundo;

USE miniMundo;
SHOW TABLES;

CREATE TABLE IF NOT EXISTS cliente(
    cpf CHAR(11) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    genero CHAR(1) NULL CHECK (genero IN ('M', 'F')),
    numero  INT NOT NULL,
    rua VARCHAR(150) NOT NULL,
    bairro VARCHAR(150) NOT NULL,
    cidade VARCHAR(150) NOT NULL,
    mes INT NOT NULL,
    dia INT NOT NULL,
    ano INT NOT NULL,
    CONSTRAINT PK_CLIENTE PRIMARY KEY (cpf)
);

CREATE TABLE IF NOT EXISTS telefone(
	numero CHAR(11) NOT NULL,
    cpf_cliente CHAR(11) NOT NULL,
    CONSTRAINT FK_CPF_CLIENTE FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf),
    CONSTRAINT PK_TELEFONE PRIMARY KEY (numero, cpf_cliente)
);


CREATE TABLE IF NOT EXISTS funcionario(
	cpf CHAR(11) NOT NULL,
	nome VARCHAR(150) NOT NULL,
    telefone VARCHAR(45) NOT NULL,
    numero  INT NOT NULL,
    rua VARCHAR(150) NOT NULL,
    bairro VARCHAR(150) NOT NULL,
    cidade VARCHAR(150) NOT NULL,
    cpf_dependente CHAR(11),
    grau_parentesco VARCHAR(150),
    chefe CHAR(11),
	CONSTRAINT PK_CPF_FUNCIONARIO PRIMARY KEY (cpf),
    CONSTRAINT FK_CHEFE FOREIGN KEY (chefe) REFERENCES funcionario(cpf)  ON DELETE SET NULL,
    CONSTRAINT CHK_GRAU_PARENTESCO CHECK (
    (cpf_dependente IS NOT NULL AND grau_parentesco IS NOT NULL) OR (cpf_dependente IS NULL AND grau_parentesco IS NULL)
    )
);


CREATE TABLE IF NOT EXISTS cozinheiro(
	area_preparo INT NOT NULL,
    funcionario_cpf CHAR(11) NOT NULL,
    CONSTRAINT PK_COZINHEIRO PRIMARY KEY(funcionario_cpf),
    CONSTRAINT FK_COZINHEIRO FOREIGN KEY (funcionario_cpf) REFERENCES funcionario(cpf)
);

CREATE TABLE IF NOT EXISTS entregador(
	cnh CHAR(45) NOT NULL,
	funcionario_cpf CHAR(11) NOT NULL,
    CONSTRAINT PK_ENTREGADOR PRIMARY KEY(funcionario_cpf),
    CONSTRAINT FK_ENTREGADOR FOREIGN KEY (funcionario_cpf) REFERENCES funcionario(cpf)
);

CREATE TABLE IF NOT EXISTS sac(
	escolaridade VARCHAR(45),
	funcionario_cpf CHAR(11) NOT NULL,
    CONSTRAINT PK_SAC PRIMARY KEY(funcionario_cpf),
    CONSTRAINT FK_SAC FOREIGN KEY (funcionario_cpf) REFERENCES funcionario(cpf)
);


CREATE TABLE IF NOT EXISTS produto(
	codigo INT NOT NULL,
    preco DECIMAL(8,2) NOT NULL CHECK(preco >= 0),
    CONSTRAINT PK_CODIGO_PRODUTO PRIMARY KEY(codigo)
);

CREATE TABLE IF NOT EXISTS preparo(
	produto_codigo INT NOT NULL,
    data_hora DATETIME NOT NULL,
    status_pedido VARCHAR(45) NOT NULL CHECK(status_pedido IN('preparando', 'finalizado')),
    cozinheiro_cpf CHAR(11) NOT NULL,
    CONSTRAINT FK_PRODUTO_CODIGO FOREIGN KEY (produto_codigo) REFERENCES produto(codigo),
    CONSTRAINT FK_COZINHEIRO_CPF FOREIGN KEY (cozinheiro_cpf) REFERENCES cozinheiro(funcionario_cpf),
	CONSTRAINT PK_PREPARO PRIMARY KEY (produto_codigo, data_hora, cozinheiro_cpf)
);

CREATE TABLE IF NOT EXISTS pedido(
	cliente_cpf CHAR(11) NOT NULL,
    produto_codigo INT NOT NULL,
    status_entrega VARCHAR(45) NOT NULL CHECK(status_entrega IN ('Aguardando preparo', 'saiu para entrega', 'entregue')),
    data_hora_entrega DATETIME DEFAULT NULL,
    atendimento_id INT UNIQUE,
    data_hora DATETIME NOT NULL,
    entregador_cpf CHAR(11) NOT NULL,
    atendente_cpf CHAR(11),
    CONSTRAINT FK_CLIENTE_CPF FOREIGN KEY (cliente_cpf) REFERENCES cliente(cpf),
    CONSTRAINT FK_PRODUTO_CODIGO_PEDIDO FOREIGN KEY (produto_codigo) REFERENCES produto(codigo),
    CONSTRAINT FK_ENTREGADOR_CPF FOREIGN KEY (entregador_cpf) REFERENCES entregador(funcionario_cpf),
    CONSTRAINT FK_ATENDENTE_CPF FOREIGN KEY (atendente_cpf) REFERENCES sac(funcionario_cpf),
    CONSTRAINT PK_PEDIDO PRIMARY KEY (cliente_cpf, produto_codigo, data_hora, entregador_cpf)
);

CREATE TABLE IF NOT EXISTS observacao(
    pedido_cliente_cpf CHAR(11) NOT NULL,
    pedido_produto_codigo INT NOT NULL,
    pedido_data_hora DATETIME NOT NULL,
    pedido_entregador_cpf CHAR(11) NOT NULL,
    observacao VARCHAR(150) NOT NULL,
    CONSTRAINT FK_OBSERVACAO FOREIGN KEY (pedido_cliente_cpf, pedido_produto_codigo, pedido_data_hora, pedido_entregador_cpf)
    REFERENCES pedido(cliente_cpf, produto_codigo, data_hora, entregador_cpf),
    CONSTRAINT PK_OBSERVACAO PRIMARY KEY (pedido_cliente_cpf, pedido_produto_codigo, pedido_data_hora, pedido_entregador_cpf)
);

-- insercoes 
INSERT INTO cliente VALUES 
('11111111111', 'Ana Clara', 'F', 123, 'Rua das Flores', 'Centro', 'Campina Grande', 5, 20, 1995),
('22222222222', 'Bruno Souza', 'M', 456, 'Av. Brasil', 'Liberdade', 'João Pessoa', 8, 15, 1990),
('33333333333', 'Carlos Silva', 'M', 789, 'Rua Verde', 'Bela Vista', 'Patos', 2, 10, 1985),
('44444444444', 'Daniela Lima', 'F', 101, 'Rua Azul', 'Centro', 'Campina Grande', 12, 1, 2000),
('55555555555', 'Eduardo Costa', 'M', 202, 'Rua Marrom', 'Monte Castelo', 'Cajazeiras', 7, 30, 1992);


INSERT INTO telefone VALUES 
('83911111111', '11111111111'),
('83922222222', '22222222222'),
('83933333333', '33333333333'),
('83944444444', '44444444444'),
('83955555555', '55555555555');


INSERT INTO funcionario VALUES 
('66666666666', 'Fernanda Lopes', '83966666666', 301, 'Rua A', 'Centro', 'Campina Grande', NULL, NULL, NULL),
('77777777777', 'Gabriel Lima', '83977777777', 302, 'Rua B', 'Centro', 'Campina Grande', NULL, NULL, '66666666666'),
('88888888888', 'Helena Rocha', '83988888888', 303, 'Rua C', 'Centro', 'Campina Grande', NULL, NULL, '66666666666'),
('99999999999', 'Igor Martins', '83999999999', 304, 'Rua D', 'Centro', 'Campina Grande', NULL, NULL, NULL),
('00000000000', 'Joana Silva', '83900000000', 305, 'Rua E', 'Centro', 'Campina Grande', '99999999999', 'filho(a)', NULL);


INSERT INTO cozinheiro VALUES 
(1, '66666666666'),
(2, '77777777777'),
(3, '88888888888'),
(4, '99999999999'),
(5, '00000000000');


INSERT INTO entregador VALUES 
('CNH001', '66666666666'),
('CNH002', '77777777777'),
('CNH003', '88888888888'),
('CNH004', '99999999999'),
('CNH005', '00000000000');


INSERT INTO sac VALUES 
('Superior', '66666666666'),
('Médio', '77777777777'),
('Fundamental', '88888888888'),
('Superior', '99999999999'),
('Médio', '00000000000');


INSERT INTO produto VALUES 
(1, 15.00),
(2, 25.50),
(3, 9.90),
(4, 30.00),
(5, 12.75);


INSERT INTO preparo VALUES 
(1, '2025-03-20 10:00:00', 'preparando', '66666666666'),
(2, '2025-03-20 10:10:00', 'finalizado', '77777777777'),
(3, '2025-03-20 10:20:00', 'finalizado', '88888888888'),
(4, '2025-03-20 10:30:00', 'preparando', '99999999999'),
(5, '2025-03-20 10:40:00', 'finalizado', '00000000000');


INSERT INTO pedido VALUES 
('11111111111', 1, 'Aguardando preparo', NULL, 101, '2025-03-20 10:50:00', '66666666666', '66666666666'),
('22222222222', 2, 'saiu para entrega', '2025-03-20 11:10:00', 102, '2025-03-20 11:00:00', '77777777777', '77777777777'),
('33333333333', 3, 'entregue', '2025-03-20 11:20:00', 103, '2025-03-20 11:05:00', '88888888888', '88888888888'),
('44444444444', 4, 'entregue', '2025-03-20 11:25:00', 104, '2025-03-20 11:15:00', '99999999999', '99999999999'),
('55555555555', 5, 'saiu para entrega', '2025-03-20 11:30:00', 105, '2025-03-20 11:20:00', '00000000000', '00000000000');


INSERT INTO observacao (pedido_cliente_cpf, pedido_produto_codigo, pedido_data_hora, pedido_entregador_cpf, observacao)
VALUES 
('11111111111', 1, '2025-03-20 10:50:00', '66666666666', 'Sem cebola'),
('22222222222', 2, '2025-03-20 11:00:00', '77777777777', 'Entrega no portão'),
('33333333333', 3, '2025-03-20 11:05:00', '88888888888', 'Não tocar campainha'),
('44444444444', 4, '2025-03-20 11:15:00', '99999999999', 'Cliente pagará com 50'),
('55555555555', 5, '2025-03-20 11:20:00', '00000000000', 'Entregar ao porteiro');


-- IN: Listar clientes das cidades Campina Grande ou Patos
SELECT nome, cidade FROM cliente
WHERE cidade IN ('Campina Grande', 'Patos');

-- BETWEEN: Produtos com preço entre R$10 e R$20
SELECT * FROM produto
WHERE preco BETWEEN 10 AND 20;

-- IS NOT NULL: Pedidos que já têm data de entrega
SELECT * FROM pedido
WHERE data_hora_entrega IS NOT NULL;

-- LIKE: Buscar clientes cujo nome começa com 'D'
SELECT nome FROM cliente
WHERE nome LIKE 'D%';

-- ORDER BY: Listar produtos ordenados por preço decrescente
SELECT * FROM produto
ORDER BY preco DESC;

-- COUNT: Quantidade total de pedidos
SELECT COUNT(*) AS total_pedidos FROM pedido;

-- SUM: Soma total dos preços dos produtos pedidos
SELECT SUM(produto.preco) AS total_arrecadado
FROM pedido
JOIN produto ON pedido.produto_codigo = produto.codigo;

-- MAX: Maior preço de produto
SELECT MAX(preco) AS maior_preco FROM produto;

-- GROUP BY: Número de pedidos por status
SELECT status_entrega, COUNT(*) AS total
FROM pedido
GROUP BY status_entrega;

-- HAVING: Mostrar status com mais de 1 pedido
SELECT status_entrega, COUNT(*) AS total
FROM pedido
GROUP BY status_entrega
HAVING COUNT(*) > 1;

-- JOIN: Mostrar nome do cliente e o nome do entregador (usando cpf)
SELECT c.nome AS cliente, f.nome AS entregador
FROM pedido p
JOIN cliente c ON p.cliente_cpf = c.cpf
JOIN funcionario f ON p.entregador_cpf = f.cpf;


