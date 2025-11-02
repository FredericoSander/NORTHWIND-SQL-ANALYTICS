-- 1. Qual a quantidade de pedidos por mês/ano no período?

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