--Relacionar rating dos produtos, categoria e empresa (ordenar empresas que melhor trabalham numa dada categoria) - nando

--categoria | melhor empresa

select 	category_name as "Category Name"--,
		--manufacturer_name as "Best Manufacturer"
from (
	(select name from category) as category_name,
	--(select )



	from category
)