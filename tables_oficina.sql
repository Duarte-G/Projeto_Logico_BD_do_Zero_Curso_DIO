-- Criação do banco de dados para oficina
-- CREATE DATABASE oficina;

-- Criar tabela de clientes
CREATE TABLE customers (
    idCustomer SERIAL PRIMARY KEY,
    firstName VARCHAR(15) NOT NULL,
    middleName VARCHAR(3),
    lastName VARCHAR(20) NOT NULL,
    CPF CHAR(11) NOT NULL,
    address VARCHAR(50),
    email VARCHAR(50),
    CONSTRAINT unique_cpf_customer UNIQUE (CPF)
);

-- Criar tabela de veículos
CREATE TABLE vehicles (
    idVehicle SERIAL PRIMARY KEY,
    idCustomer INT NOT NULL,
    brand VARCHAR(20) NOT NULL,
    model VARCHAR(20) NOT NULL,
    yearManufacture INT NOT NULL,
    color VARCHAR(10),
    CONSTRAINT fk_vehicle_customer FOREIGN KEY (idCustomer) REFERENCES customers(idCustomer)
);

-- Criar tabela de mecânicos
CREATE TABLE mechanics (
    idMechanic SERIAL PRIMARY KEY,
    firstName VARCHAR(15) NOT NULL,
    lastName VARCHAR(20) NOT NULL,
    address VARCHAR(50),
    CPF CHAR(11) NOT NULL,
    CONSTRAINT unique_cpf_mechanic UNIQUE (CPF)
);

-- Criar tabela de serviços oferecidos
CREATE TABLE services (
    idService SERIAL PRIMARY KEY,
    serviceName VARCHAR(50) NOT NULL,
    description TEXT,
    standardPrice DECIMAL(10,2) NOT NULL DEFAULT 0
);

-- Criar tabela de peças
CREATE TABLE parts (
    idPart SERIAL PRIMARY KEY,
    partName VARCHAR(50) NOT NULL,
    description TEXT,
    stockQuantity INT NOT NULL DEFAULT 0,
    unitPrice DECIMAL(10,2) NOT NULL DEFAULT 0
);

-- Criar tabela de ordens de serviço
CREATE TABLE serviceOrders (
    idServiceOrder SERIAL PRIMARY KEY,
    idVehicle INT NOT NULL,
    issueDate DATE NOT NULL,
    completionDate DATE,
    status VARCHAR(15) NOT NULL CHECK (status IN ('Aguardando', 'Em andamento', 'Concluído', 'Cancelado')),
    diagnosisDescription TEXT,
    totalAmount DECIMAL(10,2),
    CONSTRAINT fk_service_order_vehicle FOREIGN KEY (idVehicle) REFERENCES vehicles(idVehicle)
);

-- Criar tabela de relacionamento entre ordens de serviço e mecânicos
CREATE TABLE orderMechanics (
    idServiceOrder INT,
    idMechanic INT,
    PRIMARY KEY (idServiceOrder, idMechanic),
    CONSTRAINT fk_order_mechanic_so FOREIGN KEY (idServiceOrder) REFERENCES serviceOrders(idServiceOrder),
    CONSTRAINT fk_order_mechanic_mech FOREIGN KEY (idMechanic) REFERENCES mechanics(idMechanic)
);

-- Criar tabela de serviços realizados nas ordens de serviço
CREATE TABLE orderServices (
    idServiceOrder INT,
    idService INT,
    serviceQuantity INT NOT NULL DEFAULT 1,
    servicePrice DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idServiceOrder, idService),
    CONSTRAINT fk_order_service_so FOREIGN KEY (idServiceOrder) REFERENCES serviceOrders(idServiceOrder),
    CONSTRAINT fk_order_service_service FOREIGN KEY (idService) REFERENCES services(idService)
);

-- Criar tabela de peças utilizadas nas ordens de serviço
CREATE TABLE orderParts (
    idServiceOrder INT,
    idPart INT,
    partQuantity INT NOT NULL DEFAULT 1,
    partPrice DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idServiceOrder, idPart),
    CONSTRAINT fk_order_part_so FOREIGN KEY (idServiceOrder) REFERENCES serviceOrders(idServiceOrder),
    CONSTRAINT fk_order_part_part FOREIGN KEY (idPart) REFERENCES parts(idPart)
);

-- Criar tabela de pagamentos
CREATE TABLE payments (
    idPayment SERIAL PRIMARY KEY,
    idServiceOrder INT NOT NULL,
    paymentDate DATE NOT NULL,
    paymentMethod VARCHAR(15) CHECK (paymentMethod IN ('Dinheiro', 'Crédito', 'Débito', 'Pix')),
    paidAmount DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_payment_so FOREIGN KEY (idServiceOrder) REFERENCES serviceOrders(idServiceOrder)
);

-- Criar tabela para histórico de manutenções
CREATE TABLE maintenanceHistory (
    idHistory SERIAL PRIMARY KEY,
    idVehicle INT,
    serviceDate DATE NOT NULL,
    mileage INT,
    description TEXT NOT NULL,
    idServiceOrder INT,
    CONSTRAINT fk_history_vehicle FOREIGN KEY (idVehicle) REFERENCES vehicles(idVehicle),
    CONSTRAINT fk_history_service_order FOREIGN KEY (idServiceOrder) REFERENCES serviceOrders(idServiceOrder)
);

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;