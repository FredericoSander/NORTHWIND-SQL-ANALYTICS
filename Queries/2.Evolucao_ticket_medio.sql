-- 2. Qual foi a evolução do ticket médio (valor médio dos pedidos) por mês/ano?

SELECT 
    EXTRACT(YEAR FROM order_date) AS ano,
    EXTRACT(MONTH FROM order_date) AS mes,
	(SUM((od.unit_price * od.quantity)*(1 - od.discount)) / COUNT(*)) AS ticket_medio
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id 
GROUP BY 
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY 
    ano, mes;