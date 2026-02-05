-- Criando banco de dados

create database eccomerce;
use eccomerce;

create table cliente (
  clienteid int auto_increment primary key,
  primeironome varchar(50) not null,
  ultimonome varchar(50) not null,
  cpf varchar(11) not null unique,
  tipo enum('pf', 'pj') not null
);

create table produto (
  produtoid int auto_increment primary key,
  nome varchar(50) not null,
  tipo enum('Roupa','Livro','Decoração','Eletrônico','Outro') not null,
  valor decimal(10,2) not null,
  check (valor > 0)
);

create table pedido (
  pedidoid int auto_increment primary key,
  clienteid int not null,
  origem varchar(30) not null,
  data_pedido date not null,
  foreign key (clienteid) references cliente(clienteid)
);

create table pedido_item (
  itemid int auto_increment primary key,
  pedidoid int not null,
  produtoid int not null,
  foreign key (pedidoid) references pedido(pedidoid) on delete cascade,
  foreign key (produtoid) references produto(produtoid)
);

create table estoque (
  estoqueid int auto_increment primary key,
  nome varchar(50) not null,
  localizacao varchar(50) not null
);

create table estoque_produto (
  estoqueid int not null,
  produtoid int not null,
  primary key (estoqueid, produtoid),
  foreign key (estoqueid) references estoque(estoqueid) on delete cascade,
  foreign key (produtoid) references produto(produtoid)
);

create table cliente_pagamento (
  cliente_pagamentoid int auto_increment primary key,
  clienteid int not null,
  tipo enum('Pix','Cartao','Boleto') not null,
  foreign key (clienteid) references cliente(clienteid)
);

create table pagamento (
  pagamentoid int auto_increment primary key,
  pedidoid int not null,
  cliente_pagamentoid int not null,
  status enum('Pendente','Pago','Cancelado') not null,
  foreign key (pedidoid) references pedido(pedidoid),
  foreign key (cliente_pagamentoid) references cliente_pagamento(cliente_pagamentoid)
);

create table vendedor (
  vendedorid int auto_increment primary key,
  primeironome varchar(50) not null,
  ultimonome varchar(50) not null,
  cpf varchar(11) unique not null,
  avaliacao tinyint check (avaliacao between 1 and 5)
);

create table vendedor_produto (
  vendedorid int not null,
  produtoid int not null,
  primary key (vendedorid, produtoid),
  foreign key (vendedorid) references vendedor(vendedorid) on delete cascade,
  foreign key (produtoid) references produto(produtoid)
);

create table fornecedorpessoa (
  fornecedorpessoaid int auto_increment primary key,
  primeironome varchar(50) not null,
  ultimonome varchar(50) not null,
  cpf varchar(11) unique not null
);

create table fornecedorpessoa_produto (
  fornecedorpessoaid int not null,
  produtoid int not null,
  primary key (fornecedorpessoaid, produtoid),
  foreign key (fornecedorpessoaid) references fornecedorpessoa(fornecedorpessoaid) on delete cascade,
  foreign key (produtoid) references produto(produtoid)
);

create table entrega (
  entregaid int auto_increment primary key,
  pedidoid int not null,
  transportadora varchar(50),
  codigo_rastreio varchar(30) unique,
  status enum('Em preparo','A caminho','Entregue','Pausada') not null,
  data_envio date,
  data_entrega date,
  foreign key (pedidoid) references pedido(pedidoid)
);

-- Adicionando dados
INSERT INTO cliente (primeironome, ultimonome, cpf, tipo) VALUES
('Joao','Silva','11111111111','PF'),
('Maria','Souza','22222222222','PF'),
('Carlos','Pereira','33333333333','PF'),
('Ana','Oliveira','44444444444','PF'),
('Bruno','Lima','55555555555','PF'),
('Paula','Costa','66666666666','PF'),
('Ricardo','Alves','77777777777','PF'),
('Fernanda','Rocha','88888888888','PF'),
('Lucas','Martins','99999999999','PF'),
('Empresa','TechPlus','12121212121','PJ');

INSERT INTO produto (nome, tipo, valor) VALUES
('Camisa Polo','Roupa',79.90),
('Calca Jeans','Roupa',129.90),
('Livro SQL','Livro',59.90),
('Headset Gamer','Eletrônico',299.90),
('Mouse Sem Fio','Eletrônico',89.90),
('Vaso Decorativo','Decoração',49.90),
('Teclado Mecânico','Eletrônico',399.90),
('Livro Python','Livro',69.90),
('Jaqueta','Roupa',199.90),
('Luminaria LED','Decoração',39.90);

INSERT INTO pedido (clienteid, origem, data_pedido) VALUES
(1,'Site','2026-01-10'),
(2,'App','2026-01-11'),
(3,'Site','2026-01-12'),
(4,'App','2026-01-12'),
(5,'Site','2026-01-13'),
(6,'Site','2026-01-14'),
(7,'App','2026-01-14'),
(8,'Site','2026-01-15'),
(9,'App','2026-01-15'),
(10,'Site','2026-01-16'),
(1,'App','2026-01-17'),
(2,'Site','2026-01-18'),
(3,'App','2026-01-18'),
(4,'Site','2026-01-19'),
(5,'App','2026-01-20');

INSERT INTO pedido_item (pedidoid, produtoid) VALUES
(1,1),(1,3),
(2,2),(2,4),
(3,5),
(4,1),(4,6),
(5,7),(5,2),
(6,3),
(7,4),(7,5),
(8,6),
(9,7),(9,8),
(10,9),
(11,1),(11,10),
(12,2),
(13,3),(13,4),
(14,5),
(15,6),(15,9);

INSERT INTO vendedor (primeironome, ultimonome, cpf, avaliacao) VALUES
('Pedro','Santos','90000000001',5),
('Juliana','Moraes','90000000002',4),
('Rafael','Nogueira','90000000003',5),
('Camila','Barros','90000000004',3),
('Thiago','Ribeiro','90000000005',4);

INSERT INTO vendedor_produto (vendedorid, produtoid) VALUES
(1,1),(1,2),
(2,3),(2,4),
(3,5),(3,6),
(4,7),(4,8),
(5,9),(5,10);

INSERT INTO fornecedorpessoa (primeironome, ultimonome, cpf) VALUES
('Pedro','Santos','90000000001'),
('Juliana','Moraes','90000000002'),
('Rafael','Nogueira','90000000003'),
('Marcos','Teixeira','90000000006'),
('Luciana','Paz','90000000007');

INSERT INTO fornecedorpessoa_produto (fornecedorpessoaid, produtoid) VALUES
(1,1),(1,3),
(2,2),(2,4),
(3,5),(3,6),
(4,7),(4,8),
(5,9),(5,10);

INSERT INTO estoque (nome, localizacao) VALUES
('Centro SP','São Paulo'),
('Filial RJ','Rio de Janeiro'),
('CD Minas','Belo Horizonte');

INSERT INTO estoque_produto (estoqueid, produtoid) VALUES
(1,1),(1,2),(1,3),(1,4),
(1,5),(1,6),

(2,3),(2,4),(2,7),(2,8),

(3,1),(3,9),(3,10),(3,6);

INSERT INTO cliente_pagamento (clienteid, tipo) VALUES
(1,'Pix'),
(1,'Cartao'),
(2,'Boleto'),
(3,'Cartao'),
(3,'Pix'),
(4,'Pix'),
(5,'Cartao'),
(6,'Boleto'),
(7,'Pix'),
(8,'Cartao'),
(9,'Pix'),
(10,'Boleto');

INSERT INTO pagamento (pedidoid, cliente_pagamentoid, status) VALUES
(1,1,'Pago'),
(2,3,'Pago'),
(3,4,'Pago'),
(4,6,'Pendente'),
(5,7,'Pago'),
(6,8,'Pago'),
(7,9,'Pago'),
(8,10,'Pendente'),
(9,11,'Pago'),
(10,12,'Pago'),
(11,2,'Pago'),
(12,3,'Pago'),
(13,5,'Pendente'),
(14,6,'Pago'),
(15,7,'Cancelado');

INSERT INTO entrega (pedidoid, transportadora, codigo_rastreio, status, data_envio, data_entrega) VALUES
(1,'Correios','BR10001','Entregue','2026-01-11','2026-01-14'),
(2,'Jadlog','BR10002','Entregue','2026-01-12','2026-01-15'),
(3,'Correios','BR10003','A caminho','2026-01-13',NULL),
(4,'Loggi','BR10004','Em preparo',NULL,NULL),
(5,'Correios','BR10005','Entregue','2026-01-14','2026-01-17'),
(6,'Jadlog','BR10006','Entregue','2026-01-15','2026-01-18'),
(7,'Loggi','BR10007','A caminho','2026-01-16',NULL),
(8,'Correios','BR10008','Em preparo',NULL,NULL),
(9,'Jadlog','BR10009','Entregue','2026-01-17','2026-01-20'),
(10,'Correios','BR10010','Entregue','2026-01-18','2026-01-21'),
(11,'Loggi','BR10011','Entregue','2026-01-19','2026-01-22'),
(12,'Correios','BR10012','A caminho','2026-01-20',NULL),
(13,'Jadlog','BR10013','Em preparo',NULL,NULL),
(14,'Correios','BR10014','Entregue','2026-01-21','2026-01-24'),
(15,'Loggi','BR10015','Pausada',NULL,NULL);

-- Pedidos por pessoa
select concat(primeironome, ' ', ultimonome) as nome, count(pedidoid) as total_pedidos from cliente natural join pedido group by nome;

-- Fornecedores que também são vendedores
select v.primeironome, v.ultimonome from vendedor v join fornecedorpessoa f on v.cpf = f.cpf;

-- Produtos já pedidos
select produtoid from produto natural join pedido_item;

-- Pedidos com status pendente
select p.pedidoid from pagamento natural join pedido p where status = "Pendente";

-- Custo total de cada pedido
select pedidoid, sum(valor) as valor_total from produto natural join pedido_item group by pedidoid order by pedidoid;

-- Os 5 produtos mais vendidos
select nome, count(nome) as vendidos from produto natural join pedido_item group by nome limit 5;

-- Receita de cada produto
select nome, sum(valor) from produto natural join pedido_item group by nome;

-- Clientes com mais de 1 forma de pagamento
select clienteid, count(tipo) as formas from cliente_pagamento group by clienteid having formas > 1;

-- Pedidos ainda não entregues
select pedidoid, status from entrega where status <> "Entregue";

-- Quantia de produtos vendidos por vendedor
select vendedorid, count(produtoid) as quantia from produto natural join vendedor_produto group by vendedorid;

-- Valor gasto por cliente
select concat(c.primeironome, ' ', c.ultimonome) as nome, sum(pr.valor) as gasto from pedido pe join cliente c on pe.clienteid = c.clienteid join pedido_item pi on pe.pedidoid = pi.pedidoid
join produto pr on pi.produtoid = pr.produtoid
group by c.primeironome, c.ultimonome;

-- Tempo médio da entrega de produtos
select round(avg(data_entrega - data_envio), 2) as tempo_medio from entrega;
