-- 4. Como está a distribuição de pedidos por país ao longo do tempo?

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
