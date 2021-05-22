DROP TRIGGER IF EXISTS verify_stock_and_update;

CREATE TRIGGER verify_stock_and_update
BEFORE INSERT ON "order"
FOR EACH ROW
WHEN TRUE
BEGIN
    select
    CASE WHEN FALSE THEN raise(abort, "quantidade baixa")
    ELSE 0
    END;
    SELECT raise(abort, "funcemina totil nice");

END;

DROP VIEW IF EXISTS current;
CREATE VIEW current AS SELECT 4;

SELECT * FROM 
    (SELECT storage_id, count(*) as prods FROM stock JOIN cart_quantity 
        ON stock.product_id=cart_quantity.product_id
        JOIN storage ON stock.storage_id=storage.id
        WHERE cart_quantity.cart_id=(SELECT * from current) AND cart_quantity.amount<=stock.amount
        GROUP BY storage_id
        ORDER BY storage_id)
    WHERE prods=
        (SELECT count(*) FROM cart_quantity 
            WHERE cart_quantity.cart_id=(SELECT * from current))
    ;

SELECT * FROM cart_quantity
    WHERE cart_id=(select * from current);

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
