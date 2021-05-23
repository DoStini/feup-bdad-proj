select 	category_name as "Category Name",
		manufacturer_name as "Best Manufacturer",
		rating as "Rating"
from (

	(select name as category_name,

	(select ma.name
		from review as re
		INNER JOIN product as pr on re.product_id = pr.id
		INNER JOIN product_category_applied as pc on pr.id = pc.product_id
		INNER JOIN manufacturer as ma on pr.manufacturer_id = ma.id

		where category.id = pc.category_id

		group by ma.id
		order by avg(re.rating) desc 
		limit 1
	) as manufacturer_name,

	(select avg(re.rating)
		from review as re
		INNER JOIN product as pr on re.product_id = pr.id
		INNER JOIN product_category_applied as pc on pr.id = pc.product_id

		where category.id = pc.category_id

		group by pr.manufacturer_id
		order by avg(re.rating) desc 
		limit 1
	) as rating

	from category)
)
where manufacturer_name != ""
;
