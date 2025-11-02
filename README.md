# Análise de dados com SQL do projeto Northwind - Em desenvolvimento

## Sumário

1. [Objetivo ](#Objetivo)
2. [Contexto](#instalação-e-configuração)
3. [Tecnologias Utilizadas](#arquitetura-do-projeto)
4. [Questões a serem analisadas](#questões-a-serem-analisadas)
5. [Configuração inicial](#configuração-inicial)
6. [Autor](#Autor)

---

## Objetivo

Este projeto apresenta o cenário de uma empresa fictícia chamada Northwind Trades, em que gerencia as atividades de comercio por meio de sistema ERP. Por meio dos dados disponibilizados o desafio é apresentar um relatório com indicadores de performance para entender os desafios estratégicos da empresa, que incluem em aumentar o ticket médio e reduzir o churn. Para a realização das análises será utilizada a linguagem SQL. Aas análises aqui desenvolvidas podem ser aplicadas em empreasas de de todos os tamanha e que desejam se tronarem mais análiticas. O relatório possibilitara a extração de insights aprtir dos dados para tomada de decisões mais estratégicas.

---

## Contexto

A Northwind Traders é uma loja fictícia que gerencia pedidos, produtos, clientes, fornecedores e muitos outros aspectos de uma pequena empresa. Hoje a empresa possui cerca de 30 funcionários e um faturamento mensal de 1 milhão e meio de reais. Seus clientes e fornecedores estão distribuídos em diversos países. Seus principais produtos hoje são alimentos, bebidas e utilidades domésticas. A empresa deseja entender melhor seus dados para aumentar o ticket médio e reduzir o churn, dois objetivos considerados estratégicos no médio e longo prazo. O banco de dados do ERP da empresa é um sistema PostgreSQL em um servidor nuvem. Os dados estão disponíveis na pasta data e no arquivo northiwind.sql.

---

## Tecnologias Utilizadas
- **Docker**: Plataforma de código aberto para executar aplicações em contêineres.  
- **Postgres**: Sistema gerenciador de banco de dados relacional de código aberto.
- **pgAdmin**: Ferramenta para administração e desenvolvimento de banco de dados Postgres
- **Github**: Repositório online de código.
- **Git**: Ferramenta de versionamento de código.

---

## Questões a serem analisadas.

#### Sales Report

1. Qual a quantidade de pedidos por mês/ano no período?

```sql
SELECT 
    EXTRACT(YEAR FROM order_date) AS ano,
    EXTRACT(MONTH FROM order_date) AS mes,
    COUNT(*) AS total_pedidos
FROM orders
GROUP BY 
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY 
    ano, mes;
```

2. Qual foi a evolução do ticket médio (valor médio dos pedidos) por mês/ano?

```sql
SELECT 
    EXTRACT(YEAR FROM order_date) AS ano,
    EXTRACT(MONTH FROM order_date) AS mes,
	(SUM((od.unit_price * od.quantity)*(1 - od.discount)) / COUNT(DISTINCT o.order_id)) AS ticket_medio
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id 
GROUP BY 
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY 
    ano, mes;
```

3. Como está a distribuição de pedidos por país ao longo do tempo?

```sql
SELECT 
	ship_country,
	EXTRACT(YEAR FROM order_date) AS ano,
	EXTRACT(MONTH FROM order_date) AS mes,
	COUNT(DISTINCT order_id)
FROM orders
GROUP BY 
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date),
	ship_country
ORDER BY 
   ship_country, ano, mes;
```

4. Qual foi o valor total concedido em descontos para cada categoria de produto?
```sql
SELECT c.category_name,
	SUM((od.unit_price * od.quantity * od.discount))AS Total_descontos
FROM categories c
INNER JOIN products p ON p.category_id = c.category_id
INNER JOIN order_details od ON od.product_id = p.product_id
GROUP BY category_name
ORDER BY Total_descontos;
```
5. Crie uma consulta que mostre o tempo médio (em dias) entre a data do pedido e a data de envio, agrupado por transportadora.
```sql
SELECT c.company_name,
	AVG (o.shipped_date - o.order_date) AS avg_delivery_days
FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
WHERE o.shipped_date IS NOT NULL
GROUP BY c.company_name
ORDER BY avg_delivery_days;
```

6. Quais clientes não realizaram compras nos últimos 6 meses (potencial churn)?

```sql
SELECT c.company_name, o.customer_id
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
	AND o.order_date BETWEEN '1997-12-06' AND '1998-05-06'
WHERE o.order_id IS NULL;
```

7. Quais são os 10 clientes com maior valor total de compras (TOP 10 Total Sales)?

```sql
SELECT c.company_name,
	SUM((od.unit_price * od.quantity)*(1 - od.discount))AS Total_vendas
FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
INNER JOIN order_details od ON od.order_id = o.order_id
GROUP BY c.company_name
ORDER BY Total_vendas DESC 
LIMIT 10;
```

---

## Configuração inicial

### Utilizando o Docker 

1. Instale o Docker e o Docker compose na sua máquina caso ainda possua. Procure sempre pelo site oficial do docker para obter as imagens oficial do programa.
2. Crie uma pasta local e clone o repositório do projeto para maquina local.
3. Abra o repositorio **VSCode** "opcional" e no terminal execute o comando.

    ``docker-compose up``
 
    O **Docker** o irá configurar ambiente e as aplicações e aguarde as mensagens de configuração, como:
    
    Creating network "northwind_psql_db" with driver "bridge"
    Creating volume "northwind_psql_db" with default driver
    Creating volume "northwind_psql_pgadmin" with default driver
    Creating pgadmin ... done
    Creating db      ... done
    
4. **Conect-se ao PgAdmin** acessado a URL: http://localhost:5050, com a senha ``postgres``.

   Configure um novo seridor no PgAdmin.
   Clique com botão direito na opção **Servers** depois: **Registre** e em seguida; **Server**
   Na caixa diálogo preencha os campos das abasconforme segue.

   Aba **General**:

        Nome:db

   Aba **Connection**:

         Nome do Host:db
         Port:5432
         database: postgres
         Nome de usuário: postgres
         Senha: postgres

5. Em seguida selecione em **Server** o banco de dados **Northwind**.
6. Após a utilização faça **logout no PgAdmin** e utilize os para para a aplicação e remover os contêineres criados.

        docker compose down

7. O arquivos de dados e as alterações realizadas no banco de dados Postgres serão persistidas no volume Docker``postgres_data`` e poderão ser reaproveitadas reiciando os contêineres por meio do ``docker-compose up``.
8. Para deletar o banco de dados completo execute:

        docker-compose down -v

### Manualmente

1. Para configurar manualmente, utilize o arquivo [northwin.sql](https://github.com/FredericoSander/NORTHWIND-SQL-ANALYTICS/blob/main/northwind.sql), que irá configurar do banco de dados **Northwind** no PostgreSQL.
2. Após a configuração do banco de dados utilize as query disponíveis na pasta ``Relatorios`` para visualização das consultas.

---

## Autor
| [<img loading="lazy" src="https://avatars.githubusercontent.com/u/136928502?s=96&v=4" width=115><br><sub>Frederico Sander</sub>](https://github.com/FredericoSander)
| :---: |

*Documentação gerada para o projeto Análise de dados com SQL do projeto Northwind - Versão 1.0*