-- 4. Qual foi o valor total concedido em descontos para cada categoria de produto?

SELECT c.category_name,
	SUM((od.unit_price * od.quantity * od.discount))AS Total_descontos
FROM categories c
INNER JOIN products p ON p.category_id = c.category_id
INNER JOIN order_details od ON od.product_id = p.product_id
GROUP BY category_name
ORDER BY Total_descontos;