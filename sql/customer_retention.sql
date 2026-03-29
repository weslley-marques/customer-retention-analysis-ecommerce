-- Análise de clientes recorrentes (comportamento)

WITH pedidos AS (
    SELECT 
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        SUM(p.payment_value) AS valor_pedido
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c 
        ON o.customer_id = c.customer_id
    JOIN olist_order_payments_dataset p 
        ON o.order_id = p.order_id
    GROUP BY 
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp
),

resumo_cliente AS (
    SELECT
        customer_unique_id,
        COUNT(order_id) AS total_pedidos,
        SUM(valor_pedido) AS valor_total,
        MAX(order_purchase_timestamp) AS ultimo_pedido,
        MIN(order_purchase_timestamp) AS primeiro_pedido
    FROM pedidos
    GROUP BY customer_unique_id
)

SELECT 
    customer_unique_id,
    total_pedidos,
    valor_total,
    DATEDIFF(DATE(ultimo_pedido), DATE(primeiro_pedido)) AS tempo_vida_cliente

FROM resumo_cliente
WHERE total_pedidos > 1;