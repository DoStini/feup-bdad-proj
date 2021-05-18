DROP VIEW IF EXISTS paid_order_last_30_days;
DROP VIEW IF EXISTS unreviewed_last_30_days;
DROP VIEW IF EXISTS paid_orders_morethan_20;

CREATE VIEW paid_order_last_30_days AS 
SELECT order_paid.id as order_id
FROM order_paid
JOIN "order" USING(id)
WHERE julianday('now') - julianday("order".date) <= 30;

CREATE VIEW unreviewed_last_30_days AS
select client_id
FROM paid_order_last_30_days
LEFT JOIN review USING(order_id)
JOIN cart ON (paid_order_last_30_days.order_id = cart.id)
WHERE review.product_id IS NULL;

CREATE VIEW paid_orders_morethan_20 AS
SELECT client_id
FROM paid_order_last_30_days
JOIN cart_quantity ON (paid_order_last_30_days.order_id = cart_quantity.cart_id)
JOIN cart ON (order_id = cart.id)
GROUP BY order_id
HAVING sum(price) >= 20;

SELECT client.id as client_id_bonus, person.name as client_name
FROM paid_order_last_30_days
JOIN cart ON (paid_order_last_30_days.order_id = cart.id)
JOIN client ON (cart.client_id = client.id)
JOIN person ON (client.id = person.id)
WHERE client.id NOT IN unreviewed_last_30_days AND client.id IN paid_orders_morethan_20
GROUP BY client.id
HAVING count(client.id) >= 2;

