select country_name as "Country", 
	   case when c1 > c2 then "MB" when c2 > c1 then "CC" else "MB = CC" end as "Type", 
	   name as "Name" ,
	   total_number as "Total Number",
	   total_price as "Total Price"
from (
	select country_name, id, 
		(select count(*)
			from payment_mb_way as mb
				INNER JOIN "order" as ord on ord.id = mb.id 
				INNER JOIN shipment as sh on sh.id = ord.id
				INNER JOIN address as ad on ad.id = sh.address_id
				INNER JOIN city on ad.city_id = city.id
				INNER JOIN country as co on co.id=city.country_id 
				where co.id = country.id) as c1,
		(select count(*)
			from payment_credit_card as cc
				INNER JOIN "order" as ord on ord.id = cc.id 
				INNER JOIN shipment as sh on sh.id = ord.id
				INNER JOIN address as ad on ad.id = sh.address_id
				INNER JOIN city on ad.city_id = city.id
				INNER JOIN country as co on co.id=city.country_id 
				where co.id = country.id) as c2,
		(select name
			from shipment as sh
				INNER JOIN address as ad on ad.id = sh.address_id
				INNER JOIN city on ad.city_id = city.id
				INNER JOIN "order" as ord on ord.id = sh.id
				INNER JOIN cart as ca on ca.id = ord.id
				INNER JOIN cart_quantity as cq on ca.id = cq.cart_id
				INNER JOIN product as pr on cq.product_id = pr.id

			where city.country_id = country.id

			group by city.country_id, cq.product_id
			order by sum(amount) desc limit 1) as name,

		(select sum(amount)
			from shipment as sh
				INNER JOIN address as ad on ad.id = sh.address_id
				INNER JOIN city on ad.city_id = city.id
				INNER JOIN "order" as ord on ord.id = sh.id
				INNER JOIN cart as ca on ca.id = ord.id
				INNER JOIN cart_quantity as cq on ca.id = cq.cart_id
				INNER JOIN product as pr on cq.product_id = pr.id

			where city.country_id = country.id

			group by city.country_id, cq.product_id
			order by sum(amount) desc limit 1) as total_number,

		(select sum(cq.amount*cq.price)
			from shipment as sh
				INNER JOIN address as ad on ad.id = sh.address_id
				INNER JOIN city on ad.city_id = city.id
				INNER JOIN "order" as ord on ord.id = sh.id
				INNER JOIN cart as ca on ca.id = ord.id
				INNER JOIN cart_quantity as cq on ca.id = cq.cart_id
				INNER JOIN product as pr on cq.product_id = pr.id

			where city.country_id = country.id

			group by city.country_id, cq.product_id
			order by sum(amount) desc limit 1) as total_price
	from country)

where c1 > 0 or c2 > 0;
