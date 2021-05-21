DROP VIEW IF EXISTS product_pairs;
CREATE VIEW product_pairs as
SELECT pid1, pid2, count(*) as num FROM
    (SELECT c1.cart_id as cid1, c2.cart_id as cid2, c1.product_id as pid1,c2.product_id as pid2
    FROM cart_quantity as c1, cart_quantity as c2
        WHERE c1.cart_id=c2.cart_id AND c1.product_id > c2.product_id)
    GROUP BY pid1, pid2;


DROP VIEW IF EXISTS product_pairs_match;
CREATE VIEW product_pairs_match AS
SELECT pid1, pid2, num, max_count, 100*num/max_count as match
FROM 
    (SELECT pid1, pid2, num FROM product_pairs) JOIN
    (SELECT pid1 as p1, max(num) as max_count FROM product_pairs GROUP BY pid1)
        ON pid1=p1;

SELECT * FROM cart_quantity JOIN product_pairs_match --JOIN product
    ON cart_quantity.product_id=pid1 --AND product.id=pid2
    WHERE cart_quantity.cart_id=4
    ORDER BY pid2;

SELECT cart_id, pid2, num, avg(match) as fixed_match FROM cart_quantity JOIN product_pairs_match --JOIN product
    ON cart_quantity.product_id=pid1 --AND product.id=pid2
    WHERE cart_quantity.cart_id=4
    GROUP BY pid2;
