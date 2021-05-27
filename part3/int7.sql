DROP VIEW IF EXISTS avg_price_client_bought;
CREATE VIEW avg_price_client_bought AS
-- Apenas de compras terminadas (precisamos do trigger) tambem ignorando o carrinho atual
SELECT avg(price) FROM cart JOIN
    (SELECT client.id as cid FROM client JOIN cart ON client.id=cart.client_id WHERE cart.id=4)
        JOIN cart_quantity
        ON cart.client_id=cid AND cart.id=cart_quantity.cart_id WHERE cart.id <> 4 AND price IS NOT NULL;


SELECT
        category.name as category_name,
        product.name, price, description,
        manufacturer.name as manufacturer_name,
        (SELECT * FROM avg_price_client_bought) AS client_avg_price
    FROM
        (SELECT DISTINCT category_id as cat
            FROM cart_quantity JOIN product_category_applied
                ON cart_quantity.product_id = product_category_applied.product_id
            where cart_id = 4)
        JOIN product_category_applied ON product_category_applied.category_id=cat
        JOIN product ON product_category_applied.product_id=product.id 
        JOIN category ON category.id=cat
        JOIN manufacturer ON product.manufacturer_id=manufacturer.id
            WHERE 
                product_id NOT IN (SELECT product_id FROM cart_quantity) AND
                (price
                    BETWEEN 0.7*(SELECT * FROM avg_price_client_bought) AND 1.3*(SELECT * FROM avg_price_client_bought))
                    OR (SELECT * FROM avg_price_client_bought) IS NULL; 
