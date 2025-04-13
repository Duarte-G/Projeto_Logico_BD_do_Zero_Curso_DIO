-- Inserir clientes
INSERT INTO customers (firstName, middleName, lastName, CPF, address, email)
VALUES 
    ('João', 'A', 'Silva', '12345678901', 'Rua das Flores, 123', 'joao.silva@email.com'),
    ('Maria', 'B', 'Santos', '23456789012', 'Av. Principal, 456', 'maria.santos@email.com'),
    ('Pedro', 'C', 'Oliveira', '34567890123', 'Rua do Comércio, 789', 'pedro.oliveira@email.com'),
    ('Ana', 'D', 'Pereira', '45678901234', 'Av. Central, 1010', 'ana.pereira@email.com'),
    ('Carlos', 'E', 'Ferreira', '56789012345', 'Rua das Palmeiras, 222', 'carlos.ferreira@email.com');

-- Inserir veículos
INSERT INTO vehicles (idCustomer, brand, model, yearManufacture, color)
VALUES 
    (1, 'Toyota', 'Corolla', 2018, 'Prata'),
    (1, 'Honda', 'Civic', 2020, 'Preto'),
    (2, 'Volkswagen', 'Golf', 2019, 'Branco'),
    (3, 'Ford', 'Focus', 2017, 'Azul'),
    (4, 'Chevrolet', 'Onix', 2021, 'Vermelho'),
    (5, 'Hyundai', 'HB20', 2022, 'Cinza');

-- Inserir mecânicos
INSERT INTO mechanics (firstName, lastName, address, CPF)
VALUES 
    ('Roberto', 'Almeida', 'Rua dos Mecânicos, 100', '67890123456'),
    ('Luiz', 'Costa', 'Av. das Oficinas, 200', '78901234567'),
    ('Marcelo', 'Lima', 'Rua da Manutenção, 300', '89012345678'),
    ('Fernando', 'Gomes', 'Av. dos Técnicos, 400', '90123456789');

-- Inserir serviços
INSERT INTO services (serviceName, description, standardPrice)
VALUES 
    ('Troca de óleo', 'Troca de óleo do motor e filtro de óleo', 150.00),
    ('Revisão de freios', 'Verificação e manutenção do sistema de freios', 200.00),
    ('Alinhamento', 'Alinhamento das rodas', 120.00),
    ('Balanceamento', 'Balanceamento das rodas', 100.00),
    ('Diagnóstico elétrico', 'Verificação do sistema elétrico', 180.00),
    ('Troca de correia dentada', 'Substituição da correia dentada', 350.00),
    ('Troca de amortecedores', 'Substituição dos amortecedores', 600.00);

-- Inserir peças
INSERT INTO parts (partName, stockQuantity, unitPrice)
VALUES 
    ('Óleo de motor 5W30', 50, 45.00),
    ('Filtro de óleo', 40, 25.00),
    ('Pastilha de freio dianteira', 30, 120.00),
    ('Amortecedor dianteiro', 20, 250.00),
    ('Correia dentada', 25, 85.00),
    ('Bateria 60Ah', 15, 350.00),
    ('Filtro de ar', 35, 40.00);

-- Inserir ordens de serviço
INSERT INTO serviceOrders (idVehicle, issueDate, completionDate, status, diagnosisDescription)
VALUES 
    (1, '2023-05-10', '2023-05-11', 'Concluído', 'Manutenção preventiva'),
    (2, '2023-05-15', '2023-05-16', 'Concluído', 'Freios com ruído'),
    (3, '2023-05-20', '2023-05-22', 'Concluído', 'Problema elétrico no painel'),
    (4, '2023-06-01', '2023-06-02', 'Concluído', 'Vibração na direção'),
    (5, '2023-06-10', NULL, 'Em andamento', 'Motor falhando'),
    (6, '2023-06-12', NULL, 'Aguardando', 'Revisão periódica');

-- Associar mecânicos às ordens de serviço
INSERT INTO orderMechanics (idServiceOrder, idMechanic)
VALUES 
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (4, 1),
    (5, 3),
    (5, 2),
    (6, 1);

-- Associar serviços às ordens de serviço
INSERT INTO orderServices (idServiceOrder, idService, serviceQuantity, servicePrice)
VALUES 
    (1, 1, 1, 150.00),
    (2, 2, 1, 200.00),
    (3, 5, 1, 180.00),
    (4, 3, 1, 120.00),
    (4, 4, 1, 100.00),
    (5, 5, 1, 180.00),
    (5, 6, 1, 350.00),
    (6, 1, 1, 150.00);

-- Associar peças às ordens de serviço
INSERT INTO orderParts (idServiceOrder, idPart, partQuantity, partPrice)
VALUES 
    (1, 1, 4, 45.00),
    (1, 2, 1, 25.00),
    (2, 3, 1, 120.00),
    (3, 6, 1, 350.00),
    (4, 4, 2, 250.00),
    (5, 5, 1, 85.00),
    (5, 7, 1, 40.00),
    (6, 1, 4, 45.00),
    (6, 2, 1, 25.00);

-- Inserir pagamentos
INSERT INTO payments (idServiceOrder, paymentDate, paymentMethod, paidAmount)
VALUES 
    (1, '2023-05-11', 'Crédito', 355.00),
    (2, '2023-05-16', 'Dinheiro', 320.00),
    (3, '2023-05-22', 'Pix', 530.00),
    (4, '2023-06-02', 'Débito', 720.00);

-- Inserir histórico de manutenções
INSERT INTO maintenanceHistory (idVehicle, serviceDate, mileage, description, idServiceOrder)
VALUES 
    (1, '2023-05-11', 45000, 'Troca de óleo e filtros', 1),
    (2, '2023-05-16', 30000, 'Troca de pastilhas de freio', 2),
    (3, '2023-05-22', 52000, 'Reparo no sistema elétrico', 3),
    (4, '2023-06-02', 28000, 'Alinhamento e balanceamento', 4);

-- Atualizar o valor total das ordens de serviço
UPDATE serviceOrders
SET totalAmount = (
    SELECT COALESCE(SUM(servicePrice * serviceQuantity), 0)
    FROM orderServices
    WHERE orderServices.idServiceOrder = serviceOrders.idServiceOrder
) + (
    SELECT COALESCE(SUM(partPrice * partQuantity), 0)
    FROM orderParts
    WHERE orderParts.idServiceOrder = serviceOrders.idServiceOrder
);