DROP VIEW IF EXISTS product_rating;
DROP VIEW IF EXISTS product_sales;
DROP VIEW IF EXISTS product_shipment_time;

CREATE VIEW product_rating AS
SELECT product.id as id, avg(rating) as rating
FROM product
LEFT JOIN review ON (product.id = review.product_id)
GROUP BY product.id;

CREATE VIEW product_sales AS
SELECT product_id as id, sum(amount) as sales
FROM order_paid
JOIN cart_quantity ON (order_paid.id = cart_id)
GROUP BY product_id;

CREATE VIEW product_shipment_time AS
SELECT product_id as id, avg(julianday(reception_date) - julianday(shipment_date)) as shipping_time
FROM shipment
JOIN cart_quantity ON (shipment.id = cart_quantity.cart_id)
WHERE reception_date IS NOT NULL AND shipment_date IS NOT NULL
GROUP BY product_id;

SELECT product_shipment_time.id, product.name AS product_name, manufacturer.name as manufacturer_name, shipping_time as shipping_days, rating, sales
FROM product_shipment_time 
JOIN product_sales ON (product_shipment_time.id = product_sales.id) 
JOIN product_rating ON (product_sales.id = product_rating.id)
JOIN product ON (product_sales.id = product.id)
JOIN manufacturer ON (product.manufacturer_id = manufacturer.id);

