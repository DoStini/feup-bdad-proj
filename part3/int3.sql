DROP VIEW IF EXISTS product_rating;

CREATE VIEW product_rating AS
SELECT product.id as id, avg(rating)
FROM product JOIN review ON (product.id = review.product_id)
GROUP BY id;
