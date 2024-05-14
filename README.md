# fiap.tech-challenge.fast-food.infra.database

Este repositório é responsável por manter a infraestrutura do Banco de Dados da aplicação [**_Fast Food API_**](https://github.com/leandrocamara/fiap.tech-challenge.fast-food.api).

A infraestrutura é mantida com o [**_Terraform_**](https://www.terraform.io/) e provisionada na _AWS_.

## Execução

Após a execução dos [_Workflows_](https://github.com/leandrocamara/fiap.tech-challenge.fast-food.infra.database/actions) (GitHub Actions), um banco de dados [**_RDS_**](https://docs.aws.amazon.com/eks/) (_Relational Database Service_) é provisionado na _AWS_.

Há duas maneiras de executar e criar o banco de dados:

1. Realizando um `push` na `main`, por meio de um `Merge Pull Request`;

2. Executando o [_Manual Deployment_](https://github.com/leandrocamara/fiap.tech-challenge.fast-food.infra.database/actions/workflows/manual-deployment.yaml) (_Workflow_)

    ![Manual Deployment](./docs/manual-deployment.png)

    2.1. Por padrão, o _Workflow_ utilizará as `Secrets` configuradas no projeto. Caso esteja utilizando o `AWS Academy`, recomenda-se informar as credencias da conta. **Obs.:** Cada sessão do _AWS Academy_ dura **4 horas**.

Independentemente do caminho escolhido, ao final do **_CD_** (após a execução do `$ terraform apply`), é criado uma [**_Issue_**](https://github.com/leandrocamara/fiap.tech-challenge.fast-food.infra.database/issues), que aguarda por uma aprovação, para **destruir** a infraestrutura criada. Esta etapa é útil para evitar gastos desnecessários na conta da _AWS (Academy)_.

  **Obs.:** Por padrão, o tempo aguardado é de **60 minutos**. Apenas os colaboradores do repositório possuem permissão para aprovação.

Ao final da execução do `$ terraform apply`, é impresso o **_Endpoint_** do _RDS_, que pode ser configurado na variável `DB_ENDPOINT` (sem a porta) da [**_Fast Food API_**](https://github.com/leandrocamara/fiap.tech-challenge.fast-food.api).

  ![DB_ENDPOINT](./docs/db-endpoint.png)

## Documentação

O banco escolhido foi o PostgreSQL que é um banco de dados relacional.

A escolha do banco se deu por algun fatores:
- Conhecimento do grupo de trabalho sobre o banco de dados;
- Licença *opensource*;
- Bom desempenho com grandes volumes de dados e com carga de requisições altas;
- Comunidade ativa, com lançamento de patchs e novas versões constantemente;
- Suporte a replicação;
- Aderente ao padrão SQL ANSI;
- Suporte a transações ACID (Atomicity, Consistency, Isolation and Durability)

Nosso banco de dados ainda possui poucas tabelas, mas todas elas com os devidos relacionamentos e definições de chave primária e chaves estrangeiras.
![ER](./docs/er.png)
Diagrama ER do banco de dados PostgreSQL no status atual do projeto.


## Tabelas

### Tabela "customers"

A tabela `customers` armazena informações sobre os clientes do sistema.

| Campo    | Tipo         | Restrições         | Observações                      |
|----------|--------------|---------------------|----------------------------------|
| Id       | UUID         | Chave Primária      | Identificador único do cliente   |
| Cpf      | VARCHAR(11)  | Não Nulo            | Número de CPF do cliente         |
| Name     | VARCHAR(100) | Não Nulo            | Nome completo do cliente          |
| Email    | VARCHAR(100) | Não Nulo            | Endereço de email do cliente      |

### Tabela "products"

A tabela `products` armazena informações sobre os produtos disponíveis no sistema.

| Campo       | Tipo          | Restrições         | Observações                                      |
|-------------|---------------|---------------------|--------------------------------------------------|
| Id          | UUID          | Chave Primária      | Identificador único do produto                   |
| Name        | VARCHAR(100)  | Não Nulo            | Nome do produto                                  |
| Category    | SMALLINT      | Não Nulo            | Categoria do produto (Meal = 0, Side = 1, Drink = 2, Dessert = 3) |
| Price       | NUMERIC(10, 2)| Não Nulo            | Preço do produto                                |
| Description | VARCHAR(200)  | Não Nulo            | Descrição do produto                            |
| Images      | JSONB         |                     | Lista com as URLs das imagens do produto    |

### Tabela "orders"

A tabela `orders` registra os pedidos feitos pelos clientes.

| Campo          | Tipo         | Restrições         | Observações                                     |
|----------------|--------------|---------------------|-------------------------------------------------|
| Id             | UUID         | Chave Primária      | Identificador único do pedido                    |
| CustomerId     | UUID         | Chave Estrangeira (Referencia "customers") | ID do cliente que fez o pedido      |
| OrderNumber    | INT          | Não Nulo            | Número do pedido                                 |
| Status         | SMALLINT     | Não Nulo            | Status do pedido (PaymentPending = 0, PaymentRefused = 1, Received = 2, Preparing = 3, Ready = 4, Completed = 5) |
| CreatedAt      | TIMESTAMPTZ  | Não Nulo            | Data e hora de criação do pedido                  |
| TotalPrice     | DECIMAL      |                     | Preço total do pedido                          |
| QrCodePayment  | VARCHAR(1000)|                     | Código QR para pagamento (gerado pelo MercadoPago)         |
| PaymentStatusDate | TIMESTAMPTZ |                     | Data e hora da última atualização do status de pagamento |

### Tabela "orderItems"

A tabela `orderItems` relaciona os produtos aos pedidos e registra os itens de cada pedido.

| Campo       | Tipo         | Restrições         | Observações                                          |
|-------------|--------------|---------------------|------------------------------------------------------|
| Id          | UUID         | Chave Primária      | Identificador único do item de pedido                  |
| OrderId     | UUID         | Chave Estrangeira (Referencia "orders") | ID do pedido ao qual o item está relacionado  |
| ProductId   | UUID         | Chave Estrangeira (Referencia "products") | ID do produto associado ao item de pedido   |
| Quantity    | SMALLINT     | Não Nulo            | Quantidade do produto no pedido                      |
| TotalPrice  | DECIMAL      | Não Nulo            | Preço total do item de pedido                        |

### Relacionamentos

1. **Tabela "orders" e "customers"**: A tabela "orders" possui uma chave estrangeira "CustomerId" que referencia a tabela "customers", representando a relação de que um pedido pertence a um cliente específico.

2. **Tabela "orderItems", "orders" e "products"**: A tabela "orderItems" possui chaves estrangeiras "OrderId" e "ProductId" que referenciam as tabelas "orders" e "products", respectivamente. Isso estabelece a relação de que um item de pedido está associado a um pedido específico e a um produto específico.


## Tech Challenge
Projeto para a curso de [Pós Graduação FIAP - Software Architecture](https://postech.fiap.com.br/curso/software-architecture/).

O grupo (19) é composto por:
- [Danilo Queiroz da Silva](https://github.com/DaniloQueirozSilva)
- [Elton Douglas Souza](https://github.com/eltonds88)
- [Leandro da Silva Câmara](https://github.com/leandrocamara)
- [Marcelo Patricio da Silva](https://github.com/mpatricio007)