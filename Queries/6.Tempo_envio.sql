-- 6. Crie uma consulta que mostre o tempo médio (em dias) entre a data do pedido e a data de envio, agrupado por transportadora.

SELECT c.company_name,
	AVG (o.shipped_date - o.order_date) AS avg_delivery_days
FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
WHERE o.shipped_date IS NOT NULL
GROUP BY c.company_name
ORDER BY avg_delivery_days;
