create trigger review_trigger
	before insert on review

when
	(select count(*) from cart_quantity as cq on new.product_id = cq.product_id
		where cq.cart_id = new.order_id) = 0
begin
	raise(abort, "Can't add a review because the client didn't buy this product")
end