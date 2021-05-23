DROP VIEW IF EXISTS avg_price_client_bought;
CREATE VIEW avg_price_client_bought AS
-- Apenas de compras terminadas (precisamos do trigger) tambem ignorando o carrinho atual
SELECT avg(price) FROM cart JOIN
    (SELECT client.id as cid FROM client JOIN cart ON client.id=cart.client_id WHERE cart.id=4)
        JOIN cart_quantity
        ON cart.client_id=cid AND cart.id=cart_quantity.cart_id WHERE cart.id <> 4 AND price IS NOT NULL;

SELECT * FROM avg_price_client_bought;

SELECT * FROM
    (SELECT DISTINCT category_id as cat
    FROM cart_quantity JOIN product_category_applied
        ON cart_quantity.product_id = product_category_applied.product_id
    where cart_id = 4)
    JOIN product_category_applied JOIN product 
    ON product_category_applied.product_id=product.id 
        AND product_category_applied.category_id=cat
        AND product_id NOT IN (SELECT product_id FROM cart_quantity)
        WHERE (price
                BETWEEN 0.8*(SELECT * FROM avg_price_client_bought) AND 1.2*(SELECT * FROM avg_price_client_bought))
                OR (SELECT * FROM avg_price_client_bought) IS NULL; 

    -- Nao escolher os mesmos produtos

SELECT DISTINCT category_id as cat
    FROM cart_quantity JOIN product_category_applied
        ON cart_quantity.product_id = product_category_applied.product_id
    where cart_id = 4
    ORDER BY category_id;

select 7 BETWEEN 0.8*(SELECT 10 FROM avg_price_client_bought) AND 1.2*(SELECT 10 FROM avg_price_client_bought);
