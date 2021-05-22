DROP VIEW IF EXISTS count_valid_stock;
CREATE VIEW count_valid_stock AS
SELECT storage_id, cart_id,count(*) as prods FROM stock JOIN cart_quantity 
            ON stock.product_id=cart_quantity.product_id
            JOIN storage ON stock.storage_id=storage.id
            WHERE cart_quantity.amount<=stock.amount
            GROUP BY storage_id, cart_id
            ORDER BY storage_id;

DROP TRIGGER IF EXISTS verify_stock_and_update;

CREATE TRIGGER verify_stock_and_update
BEFORE INSERT ON "order"
FOR EACH ROW
BEGIN
    select
    CASE WHEN NOT EXISTS (
        SELECT * FROM count_valid_stock 
            WHERE cart_id=new.id
                AND prods=(SELECT count(*) FROM cart_quantity 
                    WHERE cart_quantity.cart_id=new.id)
    )
        THEN raise(abort, "No warehouse with stock available to send package")
    ELSE
        0
    END;
    SELECT raise(abort, "funcemina totil nice");

END;

DROP VIEW IF EXISTS current;
CREATE VIEW current AS SELECT 11;

SELECT storage_id, count(*) as prods FROM stock JOIN cart_quantity 
        ON stock.product_id=cart_quantity.product_id
        JOIN storage ON stock.storage_id=storage.id
        WHERE cart_quantity.cart_id=(SELECT * from current) AND cart_quantity.amount<=stock.amount
        GROUP BY storage_id
        ORDER BY storage_id;


CREATE TABLE temp_valid_storages(storage_id, prods);

INSERT INTO temp_valid_storages 
    SELECT storage_id, prods FROM
        (SELECT storage_id, count(*) as prods FROM stock JOIN cart_quantity 
            ON stock.product_id=cart_quantity.product_id
            JOIN storage ON stock.storage_id=storage.id
            WHERE cart_quantity.cart_id=(SELECT * from current) AND cart_quantity.amount<=stock.amount
            GROUP BY storage_id
            ORDER BY storage_id)
        WHERE prods=
            (SELECT count(*) FROM cart_quantity 
                WHERE cart_quantity.cart_id=(SELECT * from current));


SELECT * FROM count_valid_stock 
    WHERE cart_id=(SELECT * FROM current)
        AND prods=(SELECT count(*) FROM cart_quantity 
                WHERE cart_quantity.cart_id=(SELECT * from current));

SELECT * FROM temp_valid_storages;

SELECT count(*) > 0 FROM temp_valid_storages;

DROP TABLE temp_valid_storages;
