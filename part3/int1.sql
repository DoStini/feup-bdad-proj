DROP VIEW IF EXISTS purchases_lower_than_any;

CREATE VIEW purchases_lower_than_any AS
SELECT cp1.purchases AS purchases
FROM client_purchases AS cp1, client_purchases AS cp2
WHERE cp1.purchases < cp2.purchases;

SELECT id, purchases
FROM client_purchases
WHERE purchases NOT IN (
	SELECT purchases FROM purchases_lower_than_any
);

