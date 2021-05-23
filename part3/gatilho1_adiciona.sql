DROP TRIGGER IF EXISTS review_trigger;

CREATE TRIGGER review_trigger 
	before insert
		on review
when
	(select count(*) from "order"  
		where "order".id = new.order_id) != 1

	OR
	
	(select count(*) from cart_quantity as cq  
		where cq.cart_id = new.order_id AND new.product_id = cq.product_id) = 0

	OR

	(select status from "order"
		where "order".id = new.order_id) = 'waiting'

	OR

	(select count(*) from shipment as sh
		where sh.id = new.order_id) != 1

begin
	select RAISE(ABORT, "This review cannot be done because the customer has not purchased this product");
end;
