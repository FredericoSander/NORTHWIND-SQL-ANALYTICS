-- 8. Quais são os 10 clientes com maior valor total de compras (TOP 10 Total Sales)?

SELECT c.company_name,
	SUM((od.unit_price * od.quantity)*(1 - od.discount))AS Total_vendas
FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
INNER JOIN order_details od ON od.order_id = o.order_id
GROUP BY c.company_name
ORDER BY Total_vendas DESC 
LIMIT 10;