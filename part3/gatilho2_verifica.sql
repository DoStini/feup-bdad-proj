SELECT "SHOULD FAIL";
insert into "order" (id, employee_id, status) values (12, NULL, 'waiting'); -- Should fail

insert into storage (id, name, address_id) values (5000, 'Patric', 21);

insert into stock (product_id, storage_id, amount) values (20, 5000, 600);
insert into stock (product_id, storage_id, amount) values (21, 5000, 600);
insert into stock (product_id, storage_id, amount) values (22, 5000, 600);
insert into stock (product_id, storage_id, amount) values (23, 5000, 600);
insert into stock (product_id, storage_id, amount) values (24, 5000, 600);
insert into stock (product_id, storage_id, amount) values (25, 5000, 600);
insert into stock (product_id, storage_id, amount) values (26, 5000, 600);
insert into cart (id, client_id) values(2000, 1);

insert into cart_quantity (cart_id, product_id, amount,  price) values (2000, 20, 600, 1);
insert into cart_quantity (cart_id, product_id, amount,  price) values (2000, 21, 55, 1);
insert into cart_quantity (cart_id, product_id, amount,  price) values (2000, 22, 60, 1);
insert into cart_quantity (cart_id, product_id, amount,  price) values (2000, 23, 60, 1);
insert into cart_quantity (cart_id, product_id, amount,  price) values (2000, 24, 23, 1);
insert into cart_quantity (cart_id, product_id, amount,  price) values (2000, 25, 60, 1);
insert into cart_quantity (cart_id, product_id, amount,  price) values (2000, 26, 30, 1);


SELECT "BEFORE INSERT";
SELECT * FROM stock WHERE storage_id = 5000;
SELECT * FROM cart_quantity WHERE cart_quantity.cart_id=2000;
insert into "order" (id, employee_id, status) values (2000, NULL, 'waiting');
SELECT "AFTER INSERT";
SELECT * FROM stock WHERE storage_id = 5000;
SELECT * FROM cart_quantity WHERE cart_quantity.cart_id=2000;
