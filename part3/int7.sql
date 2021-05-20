SELECT * FROM

    (SELECT DISTINCT category_id as cat
    FROM cart_quantity JOIN product_category_applied
        ON cart_quantity.product_id = product_category_applied.product_id
    where cart_id = 4)
    JOIN product_category_applied JOIN product 
    ON product_category_applied.product_id=product.id 
        AND product_category_applied.category_id=cat
        AND product_id NOT IN (SELECT product_id FROM cart_quantity);

    -- Nao escolher os mesmos produtos

SELECT DISTINCT category_id as cat
    FROM cart_quantity JOIN product_category_applied
        ON cart_quantity.product_id = product_category_applied.product_id
    where cart_id = 4
    ORDER BY category_id;

SELECT * FROM cart_quantity where cart_id = 4;

-- Apenas de compras terminadas (precisamos do trigger) tambem ignorando o carrinho atual
SELECT avg(price) FROM cart JOIN
    (SELECT client.id as cid FROM client JOIN cart ON client.id=cart.client_id WHERE cart.id=4)
        JOIN cart_quantity
        ON cart.client_id=cid AND cart.id=cart_quantity.cart_id WHERE cart.id <> 4 AND price IS NOT NULL;
