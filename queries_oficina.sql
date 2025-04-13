-- ##### Recuperações simples com SELECT Statement
-- Listar todos os clientes
SELECT * FROM customers;

-- Listar todos os veículos
SELECT * FROM vehicles;

-- ##### Filtros com WHERE Statement
-- Listar veículos fabricados a partir de 2020
SELECT * FROM vehicles WHERE yearManufacture >= 2020;

-- Listar ordens de serviço em andamento
SELECT * FROM serviceOrders WHERE status = 'Em andamento';

-- ##### Expressões para gerar atributos derivados
-- Calcular valor total de serviços e peças para cada ordem de serviço
SELECT 
    so.idServiceOrder,
    so.issueDate,
    so.status,
    COALESCE(SUM(os.servicePrice * os.serviceQuantity), 0) AS total_services,
    COALESCE(SUM(op.partPrice * op.partQuantity), 0) AS total_parts,
    COALESCE(SUM(os.servicePrice * os.serviceQuantity), 0) + COALESCE(SUM(op.partPrice * op.partQuantity), 0) AS grand_total
FROM 
    serviceOrders so
LEFT JOIN 
    orderServices os ON so.idServiceOrder = os.idServiceOrder
LEFT JOIN 
    orderParts op ON so.idServiceOrder = op.idServiceOrder
GROUP BY 
    so.idServiceOrder, so.issueDate, so.status;

-- ##### Ordenações dos dados com ORDER BY
-- Listar mecânicos por número de ordens atendidas
SELECT 
    m.idMechanic,
    m.firstName || ' ' || m.lastName AS mechanic_name,
    COUNT(om.idServiceOrder) AS orders_count
FROM 
    mechanics m
LEFT JOIN 
    orderMechanics om ON m.idMechanic = om.idMechanic
GROUP BY 
    m.idMechanic, mechanic_name
ORDER BY 
    orders_count DESC;

-- ##### Condições de filtros aos grupos – HAVING Statement
-- Listar clientes com mais de um veículo
SELECT 
    c.idCustomer,
    c.firstName || ' ' || c.lastName AS customer_name,
    COUNT(v.idVehicle) AS vehicle_count
FROM 
    customers c
JOIN 
    vehicles v ON c.idCustomer = v.idCustomer
GROUP BY 
    c.idCustomer, customer_name
HAVING 
    COUNT(v.idVehicle) > 1;

-- ##### Junções entre tabelas para perspectiva mais complexa
-- Análise de rentabilidade: valor médio das ordens por marca de veículo
SELECT 
    v.brand,
    COUNT(so.idServiceOrder) AS order_count,
    AVG(so.totalAmount) AS average_order_value,
    SUM(so.totalAmount) AS total_revenue
FROM 
    serviceOrders so
JOIN 
    vehicles v ON so.idVehicle = v.idVehicle
WHERE 
    so.status = 'Concluído'
GROUP BY 
    v.brand
ORDER BY 
    total_revenue DESC;

-- Histórico completo de serviços por veículo
SELECT 
    v.idVehicle,
    v.brand,
    v.model,
    c.firstName || ' ' || c.lastName AS owner,
    mh.serviceDate,
    mh.mileage,
    mh.description,
    so.totalAmount
FROM 
    vehicles v
JOIN 
    customers c ON v.idCustomer = c.idCustomer
LEFT JOIN 
    maintenanceHistory mh ON v.idVehicle = mh.idVehicle
LEFT JOIN 
    serviceOrders so ON mh.idServiceOrder = so.idServiceOrder
ORDER BY 
    v.idVehicle, mh.serviceDate DESC;