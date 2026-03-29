
USE ecommerce_analysis;

WITH pedidos AS (
    SELECT 
        c.customer_unique_id,
        o.order_id,
        DATE(o.order_purchase_timestamp) AS data_pedido,
        SUM(p.payment_value) AS valor_pedido
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c 
        ON o.customer_id = c.customer_id
    JOIN olist_order_payments_dataset p 
        ON o.order_id = p.order_id
    GROUP BY 
        c.customer_unique_id,
        o.order_id,
        DATE(o.order_purchase_timestamp)
),

resumo_cliente AS (
    SELECT
        customer_unique_id,
        COUNT(order_id) AS total_pedidos,
        SUM(valor_pedido) AS valor_total
    FROM pedidos
    GROUP BY customer_unique_id
)

SELECT 
    customer_unique_id,
    total_pedidos,
    valor_total,

    CASE 
        WHEN total_pedidos = 1 THEN 'NOVO'
        WHEN total_pedidos <= 5 THEN 'RECORRENTE'
        ELSE 'FIEL'
    END AS tipo_cliente

FROM resumo_cliente;