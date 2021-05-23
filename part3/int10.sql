DROP VIEW IF EXISTS manufacturer_sales_per_country;

CREATE VIEW manufacturer_sales_per_country AS
SELECT manufacturer.id as manufacturer_id, city_id, sum(cart_quantity.amount) as sales
FROM shipment
JOIN cart_quantity ON (shipment.id = cart_quantity.cart_id)
JOIN product ON (cart_quantity.product_id = product.id)
JOIN manufacturer ON (product.manufacturer_id = manufacturer.id)
JOIN address ON (shipment.address_id = address.id)
GROUP BY manufacturer.id, city_id;

SELECT manufacturer_id, city_id,  manufacturer.name as manufacturer_name, city.city_name, max(sales) as sales_in_country
FROM manufacturer_sales_per_country
JOIN city ON (city_id = city.id)
JOIN manufacturer ON (manufacturer_id = manufacturer.id)
GROUP BY manufacturer.id;

