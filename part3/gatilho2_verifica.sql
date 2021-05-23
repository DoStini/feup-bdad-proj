SELECT "SHOULD FAIL";
insert into "order" (id, employee_id, status) values (12, NULL, 'waiting'); -- Should fail

SELECT "BEFORE INSERT";
SELECT * FROM stock WHERE storage_id = 21;
SELECT * FROM cart_quantity WHERE cart_quantity.cart_id=11;
insert into "order" (id, employee_id, status) values (11, NULL, 'waiting');
SELECT "AFTER INSERT";
SELECT * FROM stock WHERE storage_id = 21;
SELECT * FROM cart_quantity WHERE cart_quantity.cart_id=11;