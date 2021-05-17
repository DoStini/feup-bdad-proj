DROP VIEW IF EXISTS paid_order_last_30_days;
DROP VIEW IF EXISTS unreviewed_last_30_days;

CREATE VIEW paid_order_last_30_days AS 
SELECT order_paid.id as order_id
FROM order_paid JOIN "order" USING(id)
WHERE julianday('now') - julianday("order".date) <= 30;

CREATE VIEW unreviewed_last_30_days AS
select client_id
FROM paid_order_last_30_days LEFT JOIN review USING(order_id)
JOIN cart ON (paid_order_last_30_days.order_id = cart.id)
WHERE review.product_id IS NULL;

SELECT client.id, sum(amount), product.price
FROM paid_order_last_30_days JOIN cart ON (paid_order_last_30_days.order_id = cart.id)
JOIN client ON (cart.client_id = client.id)
JOIN cart_quantity ON (cart_quantity.cart_id = cart.id)
JOIN product ON (cart_quantity.product_id = product.id)
WHERE client.id NOT IN unreviewed_last_30_days
GROUP BY client.id
HAVING count(client.id) >= 2;
