-- criação do banco de dados para o cenário de E-comerce
create database if not exists ecommerce;
use ecommerce;

-- criar tabela cliente
	create table clients(
			idclient int auto_increment primary key,
			Fname varchar(10),
			Minit char(3),
			Lname varchar(20),
			Address varchar(30)
	);

insert into clients (Fname, Minit, Lname, Address)
	values 
	('Marcelo', 'L', 'Custodio', 'Rua Poços, 192'),
	('Marina', 'D', 'Queiroz', 'Av. Caldas, 291'),
	('Casa', 'do', 'Criador', 'Rua 7 de Setembro, 37');

-- criar tabela clientePF
	create table clientPF (
		idClient int primary key,
		CPF char(11) not null unique,
		foreign key (idClient) references clients(idClient)
);

insert into clientPF (idClient, CPF)
	values
	(4, '12345678901'),
	(5, '98765432100');

-- criar tabela clientePJ
	create table clientPJ (
		idClient int primary key,
		CNPJ char(14) not null unique,
		foreign key (idClient) references clients(idClient)
);


insert into clientPJ (idClient, CNPJ)
	values
	(6, '11222333000199');

-- criar tabela produto
	create table product(
		idProduct int auto_increment primary key,
		Pname varchar(10),
		classification_kids bool default false,
		category enum('Eletrônico', 'Vestimenta', 'Brinquedos','Alimentos'),
		avaliação float default 0,
		size varchar(10)
	);
    
insert into product (Pname, classification_kids, category, avaliação, size)
	values 
	('SmartTV', false, 'Eletrônico', 4.5, '50pol'),
	('Camiseta', false, 'Vestimenta', 4.1, 'M'),
	('Bolatenis', true, 'Brinquedos', 4.9, '5cm');

-- criar tabela payments
	create table payments(
		idPayment int auto_increment primary key,
		idClient int,
        typePayment enum('Boleto', 'Cartão', 'Dois cartões'),
		limitAvailable float,
        foreign key (idClient) references clients(idClient)
	);

insert into payments (idClient, typePayment, limitAvailable)
	values 
	(4, 'Cartão', 2000),
	(4, 'Boleto', 3000),
	(6, 'Dois cartões', 10000),
	(5, 'Cartão', 5000);

-- criar tabela pedido
	create table orders(
		idOrder int auto_increment primary key,
		idOrderClient int,
		orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
		orderDescription varchar(255),
		sendValue float default 10,
		paymentCash boolean default false,
		constraint fk_orders_client foreign key (idOrderClient) references clients(idclient)
	);

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
	values 
	(4, 'Confirmado', 'SmartTV', 20, false),
	(5, 'Em processamento', 'Compra de camiseta', 15, true);

-- criar tabela delivery
	create table delivery (
		idDelivery int auto_increment primary key,
		idOrder int,
		trackingCode varchar(50),
		status enum('Em trânsito', 'Entregue', 'Atrasado') default 'Em trânsito',
		foreign key (idOrder) references orders(idOrder)
);

insert into delivery (idOrder, trackingCode, status)
	values 
	(1, 'TR123456BR', 'Entregue'),
	(2, 'TR654321BR', 'Em trânsito');

-- criar tabela estoque
	create table productStorage(
		idProdStorage int auto_increment primary key,
		storageLocation varchar(255),
		quantity int default 0
	);

insert into productStorage (storageLocation, quantity)
	values 
	('CD1400', 100),
	('CD1404', 50);

-- criar tabela fornecedor
	create table supplier(
		idSupplier int auto_increment primary key,
		SocialName varchar(255) not null,
		CNPJ char(15) not null,
		contact char(11) not null
	);
	
insert into supplier (SocialName, CNPJ, contact)
	values 
	('Fuzil', '22334455000188', '35999990000'),
	('Tambasa', '33445566000177', '35988880000');

-- criar tabela vendedor
	create table seller(
		idSeller int auto_increment primary key,
		SocialName varchar(255) not null,
		AbstName varchar(255),
		CNPJ char(15) not null,
		CPF char(9),
		location varchar(255),
		contact char(11) not null
	);
    
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact)
	values 
	('Olivia', 'Liv', '55667788000166', null, 'Minas Gerais', '35888887777'),
	('Renato', null, '25896314758', '123123123', 'Minas Gerais', '35777776666');

-- criar tabela produto vendedor
	create table productSeller(
		idPseller int,
		idPproduct int,
		prodQuantity int default 1,
		primary key (idPseller, idPproduct),
		constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
		constraint fk_product_product foreign key (idPproduct) references product(idProduct)
	);

insert into productSeller (idPseller, idPproduct, prodQuantity)
	values 
	(5, 1, 5),
	(6, 2, 10),
	(5, 3, 15);

-- criar table ordem produto			
	create table productOrder(
		idPOproduct int,
		idPOorder int,
		poQuantity int default 1,
		poStatus enum('Disponível', 'Sem estoque') default 'Disponivel',
		primary key (idPOproduct, idPOorder),
		constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
		constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
	);

insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus)
	values 
	(1, 1, 1, 'Disponível'),
	(2, 2, 1, 'Disponível');
    
-- criar tabela produto x estoque
	create table storageLocation(
		idLproduct int,
		idLstorage int,
		location varchar(255) not null,
		primary key (idLproduct, idLstorage),
		constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
		constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
	);

insert into storageLocation (idLproduct, idLstorage, location)
	values 
	(1, 1, 'A1'),
	(2, 2, 'B1'),
	(3, 2, 'C1');

-- criar tabela produto fornecedor
	create table productSupplier(
		idPsSupplier int,
		idPsProduct int,
		quantity int not null,
		primary key (idPsSupplier, idPsProduct),
		constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
		constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
	);

insert into productSupplier (idPsSupplier, idPsProduct, quantity)
	values 
	(1, 1, 20),
	(1, 2, 30),
	(2, 3, 40);

-- Quantos pedidos foram feitos por cada cliente?
SELECT c.idClient, CONCAT(c.Fname, ' ', c.Lname) AS nome_cliente, COUNT(o.idOrder) AS total_pedidos
FROM clients c
LEFT JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient
ORDER BY total_pedidos DESC;

-- Algum vendedor também é fornecedor?
SELECT s.SocialName
FROM seller s
JOIN supplier f ON s.CNPJ = f.CNPJ;

-- Relação de produtos fornecedores e estoques;
SELECT 
    p.Pname AS produto,
    s.SocialName AS fornecedor,
    ps.quantity AS qtd_fornecida,
    st.storageLocation,
    sl.location
FROM product p
JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
JOIN supplier s ON ps.idPsSupplier = s.idSupplier
LEFT JOIN storageLocation sl ON p.idProduct = sl.idLproduct
LEFT JOIN productStorage st ON sl.idLstorage = st.idProdStorage;

-- Produtos com avaliação maior que 4 ordenados pela avaliação
SELECT Pname, avaliação
FROM product
WHERE avaliação > 4
ORDER BY avaliação DESC;

-- Valor total de envio por cliente (atributo derivado)
SELECT o.idOrderClient, SUM(o.sendValue) AS total_envio
FROM orders o
GROUP BY o.idOrderClient
HAVING total_envio > 20;

-- Qual cliente fez qual pedido e qual o status da entrega?
select 
	concat(c.Fname, ' ', c.Lname) as cliente,
    o.idOrder,
    o.orderStatus,
    d.trackingCode,
    d.status as status_entrega
from orders o
join clients c on c.idClient = o.idOrderClient
join delivery d on d.idOrder = o.idOrder;
