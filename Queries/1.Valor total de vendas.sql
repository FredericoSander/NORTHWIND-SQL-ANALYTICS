-- 1. Qual o valor total de vendas por mês/ano do período?

SELECT 
	EXTRACT(YEAR FROM order_date) AS ano,
	EXTRACT(MONTH FROM order_date) AS mes,
	SUM((od.unit_price * od.quantity)*(1 - od.discount)) AS vendas_totais
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
GROUP BY
	EXTRACT(YEAR FROM order_date),
	EXTRACT(MONTH FROM order_date)
ORDER BY
	ano, mes;