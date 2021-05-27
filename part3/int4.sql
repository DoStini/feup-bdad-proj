select 	client_name as "Client Name",
		category_name as "Best Category Name"
from (
	select 
		(select name from person
			where client.id = person.id) as client_name,

		(select cat.name from cart as ca
			INNER JOIN cart_quantity as cq on ca.id = cq.cart_id
			INNER JOIN product as pr on pr.id = cq.product_id
			INNER JOIN product_category_applied as pca on pca.product_id = pr.id
			INNER JOIN category as cat on cat.id = pca.category_id
			where ca.client_id = client.id

			group by cat.name
			order by count(*) desc limit 1
			) as category_name

	from client
) where category_name != "";