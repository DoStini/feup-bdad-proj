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

    -- Blocking orders without enough stock
    select
    CASE WHEN NOT EXISTS (
        SELECT * FROM count_valid_stock 
            WHERE cart_id=new.id
                AND prods=(SELECT count(*) FROM cart_quantity 
                    WHERE cart_quantity.cart_id=new.id)
    )
        THEN raise(abort, "No warehouse with stock available to send package")
    END;

    -- Updating the cart prices
    UPDATE cart_quantity 
        SET price = (SELECT price FROM product 
                        WHERE product.id = cart_quantity.product_id)
        WHERE 
            cart_quantity.cart_id=new.id;

    -- Updating the stock on the storage
    UPDATE stock
        SET amount = stock.amount - 
                        (SELECT amount FROM cart_quantity
                            WHERE cart_quantity.product_id=stock.product_id
                                AND cart_quantity.cart_id=new.id)
        WHERE
            stock.storage_id=(
                SELECT storage_id FROM
                (SELECT stock.storage_id, sum(amount) as total FROM(
                    SELECT *, storage_id as stid FROM count_valid_stock 
                        WHERE cart_id=(SELECT * FROM current)
                            AND prods=(SELECT count(*) FROM cart_quantity 
                                    WHERE cart_quantity.cart_id=(SELECT * from current)))
                        JOIN stock ON stock.storage_id=stid
                        GROUP BY stid
                        ORDER BY total DESC
                        LIMIT 1)
            );


END;
