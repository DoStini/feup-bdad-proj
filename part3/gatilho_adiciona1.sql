create trigger review_trigger
	before insert
		on review
when
	
begin
	select RAISE(ABORT, "Can't add a review to a product that has not been purchased.");
end;