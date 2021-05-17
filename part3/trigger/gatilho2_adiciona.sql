DROP TRIGGER IF EXISTS verify_stock_and_update;

CREATE TRIGGER verify_stock_and_update
BEFORE INSERT ON "order"
FOR EACH ROW
WHEN NOT
    (SELECT count (*) from (
    SELECT * FROM cart_quantity
    WHERE cart_id=13 AND  
        NOT (SELECT count(*) as count FROM stock 
            WHERE stock.product_id=cart_quantity.product_id
                AND cart_quantity.amount <= stock.amount
            GROUP BY stock.storage_id) = 0
    GROUP BY product_id))
    =
    (SELECT count(*) FROM (
        SELECT * FROM cart_quantity
            WHERE cart_id=13))

BEGIN
    select raise(abort, "quantidade baixa");
END;

-- SELECT count (*) from (
--     SELECT * FROM cart_quantity
--     WHERE cart_id=13 AND  
--         NOT (SELECT count(*) as count FROM stock 
--             WHERE stock.product_id=cart_quantity.product_id
--                 AND cart_quantity.amount <= stock.amount
--             GROUP BY stock.storage_id) = 0
--     GROUP BY product_id);

-- SELECT count(*) FROM (
--     SELECT * FROM cart_quantity
--         WHERE cart_id=13);
