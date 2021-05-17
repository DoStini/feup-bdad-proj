DROP VIEW IF EXISTS product_rating;
DROP VIEW IF EXISTS product_sales;

CREATE VIEW product_rating AS
SELECT product.id as id, avg(rating)
FROM product JOIN review ON (product.id = review.product_id)
GROUP BY product.id;

CREATE VIEW product_sales AS
SELECT product_id as id, sum(amount) as sales
FROM order_paid JOIN cart_quantity ON (order_paid.id = cart_id)
GROUP BY product_id;

