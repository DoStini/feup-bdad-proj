DROP VIEW IF EXISTS purchases_lower_than_any;

CREATE VIEW purchases_lower_than_any AS
SELECT cp1.purchases AS purchases
FROM client_purchases AS cp1, client_purchases AS cp2
WHERE cp1.purchases < cp2.purchases;

SELECT id, person.name as person_name, purchases
FROM client_purchases
JOIN person USING(id)
WHERE purchases NOT IN (
	SELECT purchases FROM purchases_lower_than_any
);

