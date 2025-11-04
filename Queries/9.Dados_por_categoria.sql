-- 9. Qual foi o número de pedidos, quantidades de produtos e o valor total de receita gerada por cada categoria de produto por mes e ano?
SELECT 
	TO_CHAR(o.order_date, 'MM/YYYY') AS mes_ano,
	EXTRACT(YEAR FROM order_date) AS ano,
	EXTRACT(MONTH FROM order_date) AS mes,
	c.category_name,
	SUM((od.unit_price * od.quantity)*(1 - od.discount)) AS valor_total,
	COUNT(DISTINCT o.order_id) AS quant_pedidos,
	COUNT(p.product_id) AS quant_produtos
FROM 
	categories c
	INNER JOIN products p ON c.category_id = p.category_id
	INNER JOIN order_details od ON od.product_id = p.product_id
	INNER JOIN orders o ON o.order_id = od.order_id
GROUP BY
	TO_CHAR(o.order_date, 'MM/YYYY'),
	EXTRACT(YEAR FROM order_date),
	EXTRACT(MONTH FROM order_date),
	c.category_name
ORDER BY 
	 c.category_name,
	 ano,
	 mes;