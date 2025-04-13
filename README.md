# Projeto Lógico de Banco de Dados para Oficina Mecânica
Este projeto implementa um banco de dados relacional para uma oficina mecânica, com funcionalidades para gerenciamento de clientes, veículos, serviços, peças e ordens de serviço.

## Descrição do Projeto
O esquema lógico deste banco de dados abrange:

- Cadastro de clientes
- Registro de veículos
- Cadastro de mecânicos
- Catálogo de serviços e peças
- Gerenciamento de ordens de serviço
- Controle de pagamentos
- Histórico de manutenções

## Modelo de Relacionamento
- Um cliente pode ter múltiplos veículos
- Um veículo pode ter múltiplas ordens de serviço
- Uma ordem de serviço pode:
  * Envolver múltiplos mecânicos
  * Incluir múltiplos serviços
  * Utilizar múltiplas peças
  * Ter múltiplos pagamentos
- Cada veículo possui um histórico de manutenções
