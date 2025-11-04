-- 6. Quais clientes não realizaram compras nos últimos 6 meses (potencial churn)?

SELECT c.company_name, o.customer_id
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
	AND o.order_date BETWEEN '1997-12-06' AND '1998-05-06'
WHERE o.order_id IS NULL;
