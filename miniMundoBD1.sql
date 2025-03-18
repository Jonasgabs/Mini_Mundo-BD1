CREATE DATABASE miniMundo;

USE miniMundo;
SHOW TABLES;

CREATE TABLE cliente(
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

CREATE TABLE telefone(
	numero CHAR(11) NOT NULL,
    cpf_cliente CHAR(11) NOT NULL,
    CONSTRAINT PK_TELEFONE PRIMARY KEY (numero),
    CONSTRAINT FK_CPF_CLIENTE FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf)
);


CREATE TABLE funcionario(
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
    CONSTRAINT FK_CHEFE FOREIGN KEY (chefe) REFERENCES funcionario(cpf),
    CONSTRAINT CHK_GRAU_PARENTESCO CHECK (
    (cpf_dependente IS NOT NULL AND grau_parentesco IS NOT NULL) OR (cpf_dependente IS NULL AND grau_parentesco IS NULL)
    )
);


CREATE TABLE cozinheiro(
	area_preparo INT NOT NULL,
    funcionario_cpf CHAR(11) NOT NULL,
    CONSTRAINT PK_COZINHEIRO PRIMARY KEY(funcionario_cpf),
    CONSTRAINT FK_COZINHEIRO FOREIGN KEY (funcionario_cpf) REFERENCES funcionario(cpf)
);

CREATE TABLE entregador(
	cnh CHAR(45) NOT NULL,
	funcionario_cpf CHAR(11) NOT NULL,
    CONSTRAINT PK_ENTREGADOR PRIMARY KEY(funcionario_cpf),
    CONSTRAINT FK_ENTREGADOR FOREIGN KEY (funcionario_cpf) REFERENCES funcionario(cpf)
);

CREATE TABLE sac(
	escolaridade VARCHAR(45),
	funcionario_cpf CHAR(11) NOT NULL,
    CONSTRAINT PK_SAC PRIMARY KEY(funcionario_cpf),
    CONSTRAINT FK_SAC FOREIGN KEY (funcionario_cpf) REFERENCES funcionario(cpf)
);


CREATE TABLE produto(
	codigo INT NOT NULL,
    preco DECIMAL(8,2) NOT NULL,
    CONSTRAINT PK_CODIGO_PRODUTO PRIMARY KEY(codigo)
);

CREATE TABLE preparo(
	produto_codigo INT NOT NULL,
    data_hora DATETIME NOT NULL,
    status_pedido VARCHAR(45) NOT NULL CHECK(status_pedido IN('preparando', 'finalizado')),
    cozinheiro_cpf CHAR(11) NOT NULL,
    CONSTRAINT FK_PRODUTO_CODIGO FOREIGN KEY (produto_codigo) REFERENCES produto(codigo),
    CONSTRAINT FK_COZINHEIRO_CPF FOREIGN KEY (cozinheiro_cpf) REFERENCES cozinheiro(funcionario_cpf),
	CONSTRAINT PK_PREPARO PRIMARY KEY (produto_codigo, data_hora, cozinheiro_cpf)
);

CREATE TABLE pedido(
	cliente_cpf CHAR(11) NOT NULL,
    produto_codigo INT NOT NULL,
    status_entrega VARCHAR(45) NOT NULL CHECK(status_entrega IN ('Aguardando preparo', 'saiu para entrega', 'entregue')),
    data_hora_entrega DATETIME NOT NULL,
    atendimento_id INT,
    data_hora DATETIME NOT NULL,
    entregador_cpf CHAR(11) NOT NULL,
    atendente_cpf CHAR(11),
    CONSTRAINT FK_CLIENTE_CPF FOREIGN KEY (cliente_cpf) REFERENCES cliente(cpf),
    CONSTRAINT FK_PRODUTO_CODIGO FOREIGN KEY (produto_codigo) REFERENCES produto(codigo),
    CONSTRAINT FK_ENTREGADOR_CPF FOREIGN KEY (entregador_cpf) REFERENCES entregador(funcionario_cpf),
    CONSTRAINT FK_ATENDENTE_CPF FOREIGN KEY (atendente_cpf) REFERENCES sac(funcionario_cpf),
    CONSTRAINT PK_PEDIDO PRIMARY KEY (cliente_cpf, produto_codigo, data_hora, entregador_cpf)
);

CREATE TABLE observacao(
    pedido_cliente_cpf CHAR(11) NOT NULL,
    pedido_produto_codigo INT NOT NULL,
    pedido_data_hora DATETIME NOT NULL,
    pedido_entregador_cpf CHAR(11) NOT NULL,
    id INT NOT NULL,
    observacao VARCHAR(150) NOT NULL,
    CONSTRAINT FK_OBSERVACAO FOREIGN KEY (pedido_cliente_cpf, pedido_produto_codigo, pedido_data_hora, pedido_entregador_cpf)
    REFERENCES pedido(cliente_cpf, produto_codigo, data_hora, entregador_cpf),
    CONSTRAINT PK_OBSERVACAO PRIMARY KEY (pedido_cliente_cpf, pedido_produto_codigo, pedido_data_hora, pedido_entregador_cpf, id)
);
