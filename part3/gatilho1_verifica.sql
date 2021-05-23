
insert into person (id, name, nif, telephone, birthdate, email) values (12345, 'Fred', 123456789, 961234567, '2000-12-30', 'mail1@gmail.com');
insert into person (id, name, nif, telephone, birthdate, email) values (12346, 'Jack', 987654321, 967654321, '1997-1-25', 'mail2@gmail.com');
insert into employee (id, hourly_salary, weekly_hours) values (12346, 39, 10);
insert into client (id, hash_password) values (12345,'lajksh7r9dd68117a0ca05ab7090a94c');
insert into address (id,street, postal_code, door_number, city_id) values (123456,'Nobel', '0568-401', 1045, 87);
insert into person_address_applied (person_id, address_id) values (12345, 123456);
insert into cart (id, client_id) values (54321, 12345);

select "SHOULD FAIL";

insert into review (order_id, product_id, title, description, rating) values (54321, 100, 'Should fail', 'Some description', 4.008);

insert into cart_quantity (cart_id, product_id, amount,price) values (54321, 100, 10, 5);
insert into cart_quantity (cart_id, product_id, amount,price) values (54321, 101, 7, 5);
insert into cart_quantity (cart_id, product_id, amount,price) values (54321, 102, 4, 5);
insert into cart_quantity (cart_id, product_id, amount,price) values (54321, 103, 2, 5);

select "SHOULD FAIL";

insert into review (order_id, product_id, title, description, rating) values (54321, 100, 'Should fail', 'Some description', 4.008);

insert into "order" (id, employee_id, status) values (54321, NULL, 'waiting');

select "SHOULD FAIL";

insert into review (order_id, product_id, title, description, rating) values (54321, 101, 'Should fail', 'Some description', 4.008);

--shipment_type_id = 1 -> ctt
insert into payment_credit_card (id, payment_value, card_number, card_name, code) values (54321, 84.13, '4053102049', 'Conrade Shergold', 564);
insert into shipment (id, shipment_date, reception_date, distance, address_id, shipment_type_id) values (54321, '2021-05-22 13:43:20', '2021-05-24 12:00:20', 569.71373, 19, 1);

update "order" set employee_id = 12346, status = 'delivered' where "order".id = 54321;


select "SHOULD NOT FAILD";

insert into review (order_id, product_id, title, description, rating) values (54321, 100, 'Product 100', 'Nice product', 4.5);
insert into review (order_id, product_id, title, description, rating) values (54321, 101, 'Product 101', 'Perfect product', 5);
insert into review (order_id, product_id, title, description, rating) values (54321, 102, 'Product 102', 'Have some problems', 3);
insert into review (order_id, product_id, title, description, rating) values (54321, 103, 'Product 103', 'Terrible product', 1);

select * from review where order_id = 54321;
