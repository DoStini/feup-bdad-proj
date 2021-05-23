select "SHOULD FAIL";

insert into shipment (id, shipment_date, reception_date, distance, address_id, shipment_type_id) values (2, '2022-04-20 13:50:36', null, 693.69008, 63, 3);

select "BEFORE INSERT";

SELECT * FROM shipment;

insert into cart (id, client_id) values(510, 1);
insert into "order" (id, employee_id, status) values(510, 33, 'processing');
insert into payment_mb_way (id, payment_value, payment_phone_number) values(510, 10, 10);


insert into shipment (id, shipment_date, reception_date, distance, address_id, shipment_type_id) values (510, '2022-04-20 13:50:36', null, 693.69008, 63, 3);

select "AFTER INSERT";

select * FROM shipment;
