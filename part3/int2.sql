--tipo de pagamento mais popular em cada país, produto mais vendido em cada país, total de produtos vendidos em cada país, total gasto - nando

--| país | produto mais vendido | total de produtos vendidos em cada país | total gasto

select "MBWay", country_name, mb.id
	from payment_mb_way as mb
		INNER JOIN "order" as ord on ord.id = mb.id 
			INNER JOIN shipment as sh on sh.id = ord.id
				INNER JOIN address as ad on ad.id = sh.address_id
					INNER JOIN city on ad.city_id = city.id
						INNER JOIN country on country.id=city.country_id
	
	where ord.status != "waiting"

UNION

select "Credit Card", country_name, cc.id
	from payment_credit_card as cc
		INNER JOIN "order" as ord on ord.id = cc.id 
			INNER JOIN shipment as sh on sh.id = ord.id
				INNER JOIN address as ad on ad.id = sh.address_id
					INNER JOIN city on ad.city_id = city.id
						INNER JOIN country on country.id=city.country_id
	
	where ord.status != "waiting";


