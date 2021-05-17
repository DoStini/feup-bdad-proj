PRAGMA foreign_keys=OFF;

DROP TABLE IF EXISTS product_category_applied;
DROP TABLE IF EXISTS cart_quantity;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS person;
---------------------------------------------------
DROP TABLE IF EXISTS manufacturer;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS subcategory;
DROP TABLE IF EXISTS storage;
DROP TABLE IF EXISTS stock;
DROP TABLE IF EXISTS "order";
---------------------------------------------------
DROP TABLE IF EXISTS country;
DROP TABLE IF EXISTS payment_credit_card;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS person_address_applied;
DROP TABLE IF EXISTS shipment_type;
DROP TABLE IF EXISTS shipment;
DROP TABLE IF EXISTS payment_mb_way;
DROP TABLE IF EXISTS review;

PRAGMA foreign_keys=ON;

CREATE TABLE person(
    id INTEGER,
    name TEXT NOT NULL,
    birthdate DATE NOT NULL,
    nif INTEGER NOT NULL UNIQUE, /* Inserir restricao de tamanho*/
    telephone INTEGER NOT NULL, /* Same here */
    email TEXT NOT NULL UNIQUE,

    CONSTRAINT person_valid_email 
            CHECK (
                email LIKE '_%@%_%._%' 
                AND email NOT LIKE '%\%'
                AND email NOT LIKE '%/%'
                AND email NOT LIKE '%?%'
                AND email NOT LIKE '%:%'
                AND email NOT LIKE '% %'
                AND email NOT LIKE '%@%@%'),
    CONSTRAINT person_valid_nif CHECK(length(nif) >= 4),
    CONSTRAINT person_valid_phone CHECK(length(telephone) BETWEEN 7 AND 15),
    CONSTRAINT person_valid_birthdate CHECK(birthdate==strftime('%Y-%m-%d', birthdate) AND birthdate < CURRENT_TIMESTAMP),
    CONSTRAINT person_pk PRIMARY KEY(id)
);


CREATE TABLE client(
    id INTEGER,
    hash_password TEXT NOT NULL,

    CONSTRAINT client_password_valid_md5 CHECK(length(hash_password) == 32),

    CONSTRAINT client_pk PRIMARY KEY(id),
    CONSTRAINT client_fk FOREIGN KEY(id) REFERENCES person(id)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE
);


CREATE TABLE employee(
    id INTEGER,
    hourly_salary REAL NOT NULL,
    weekly_hours INTEGER NOT NULL,

    CONSTRAINT employee_valid_salary CHECK (hourly_salary > 0),
    CONSTRAINT employee_valid_hours CHECK (weekly_hours > 0 AND weekly_hours <= 168),

    CONSTRAINT employee_pk PRIMARY KEY(id),
    CONSTRAINT employee_fk FOREIGN KEY(id) REFERENCES person(id)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE
);


CREATE TABLE cart(
    id INTEGER,
    date DATE DEFAULT CURRENT_TIMESTAMP, -- Using triggers we will be able to make this read-only
    client_id INTEGER,

    CONSTRAINT cart_id_pk PRIMARY KEY (id),
    CONSTRAINT client_id_fk FOREIGN KEY(client_id) REFERENCES Client(id)
                        ON DELETE SET NULL
                        ON UPDATE CASCADE,

    CONSTRAINT cart_not_current_date CHECK ( date == CURRENT_TIMESTAMP )
);


CREATE TABLE cart_quantity(
    cart_id INTEGER,
    product_id INTEGER,
    amount INTEGER NOT NULL,
    price REAL,
    -- Podemos usar o price apenas para mais tarde, atualizar todos ao fazer uma order para ter o preço atualizado
    -- Por enquanto pode então ser qualquer valor, visto que depois vai ser atualizado

    CONSTRAINT cart_quantity_valid_amount CHECK (amount > 0),
    CONSTRAINT cart_quantity_valid_price CHECK (price > 0),

    CONSTRAINT cart_quantity_pk PRIMARY KEY(cart_id, product_id),
    CONSTRAINT cart_quantity_cart_id_fk FOREIGN KEY (cart_id) REFERENCES cart(id)
                        ON DELETE CASCADE
                        ON UPDATE CASCADE,
    CONSTRAINT cart_quantity_prod_fk FOREIGN KEY (product_id) REFERENCES product(id)
                        ON DELETE CASCADE
                        ON UPDATE CASCADE
);


CREATE TABLE product(
    id INTEGER,
    name TEXT NOT NULL,
    price REAL NOT NULL,
    description TEXT,
    manufacturer_id INTEGER,

    CONSTRAINT product_valid_price CHECK(price > 0),

    CONSTRAINT product_pk PRIMARY KEY (id)
    CONSTRAINT product_man_fk FOREIGN KEY(manufacturer_id) REFERENCES manufacturer(id)
                        ON DELETE SET NULL
                        ON UPDATE CASCADE
);


CREATE TABLE product_category_applied(
    product_id INTEGER,
    category_id INTEGER,

    CONSTRAINT product_category_applied_pk PRIMARY KEY(product_id, category_id),
    CONSTRAINT product_category_applied_prod_fk FOREIGN KEY(product_id) REFERENCES product(id)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE,
    CONSTRAINT product_category_applied_cat_fk FOREIGN KEY(category_id) REFERENCES category(id)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE
);


---------------------------------------------------------------------------------------------------------


CREATE TABLE manufacturer (
    id INTEGER,
    name TEXT NOT NULL UNIQUE,
    head_office_address_id INTEGER NOT NULL UNIQUE,

    CONSTRAINT manufacturer_fk FOREIGN KEY(head_office_address_id) REFERENCES address(id)
                            ON DELETE RESTRICT
                            ON UPDATE CASCADE,
    CONSTRAINT manufacturer_pk PRIMARY KEY(id)
);


CREATE TABLE category (
    id INTEGER,
    name TEXT NOT NULL UNIQUE,

    CONSTRAINT category_pk PRIMARY KEY(id)
);


CREATE TABLE subcategory (
    id INTEGER,
    parent_id INTEGER NOT NULL,


    CONSTRAINT subcategory_pk PRIMARY KEY(id),
    
    CONSTRAINT subcategory_id_fk FOREIGN KEY(id) REFERENCES category(id)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE,
    CONSTRAINT subcategory_parent_id_fk FOREIGN KEY(parent_id) REFERENCES category(id)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE,
    CONSTRAINT subcategory_check_ids CHECK (parent_id != id)
);



CREATE TABLE storage(
    id INTEGER,
    name TEXT NOT NULL,
    address_id INTEGER NOT NULL,

    CONSTRAINT storage_pk PRIMARY KEY(id),

    CONSTRAINT storage_address_id_fk FOREIGN KEY(address_id) REFERENCES address(id)
                            ON DELETE RESTRICT
                            ON UPDATE CASCADE
);


CREATE TABLE stock (
    product_id INTEGER,
    storage_id INTEGER,
    amount INTEGER NOT NULL,

    CONSTRAINT stock_amount CHECK (amount >= 0),

    CONSTRAINT stock_pk PRIMARY KEY(product_id,storage_id),

    CONSTRAINT stock_product_id_fk FOREIGN KEY(product_id) REFERENCES product(id)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE,
    CONSTRAINT stock_storage_id_fk FOREIGN KEY(storage_id) REFERENCES storage(id)
                            ON DELETE RESTRICT
                            ON UPDATE CASCADE
);

CREATE TABLE "order" (
    id INTEGER,
    employee_id INTEGER,
    date DATE DEFAULT CURRENT_TIMESTAMP,
    status TEXT NOT NULL,

    CONSTRAINT order_pk PRIMARY KEY(id),

    CONSTRAINT order_employee_id_fk FOREIGN KEY(employee_id) REFERENCES employee(id)
                            ON DELETE SET NULL
                            ON UPDATE CASCADE,
    CONSTRAINT order_id_fk FOREIGN KEY(id) REFERENCES cart(id)
                            ON DELETE RESTRICT
                            ON UPDATE CASCADE,

    CONSTRAINT order_not_current_date CHECK (date == CURRENT_TIMESTAMP)
    CONSTRAINT order_status_options CHECK (status LIKE 'waiting' OR status LIKE 'processing' OR status LIKE 'shipped' OR status LIKE 'delivered')
    CONSTRAINT order_employee_assignment CHECK ((status == 'waiting' AND employee_id IS NULL) OR (status != 'waiting' AND employee_id IS NOT NULL))
);


---------------------------------------------------------------------------------------------------------


CREATE TABLE country(
	id INTEGER NOT NULL,
	country_name TEXT UNIQUE NOT NULL,

	CONSTRAINT country_id_pk PRIMARY KEY(id)
);

CREATE TABLE city(
	id INTEGER NOT NULL,
	city_name TEXT NOT NULL,
	country_id INTEGER NOT NULL,

	CONSTRAINT city_id_pk PRIMARY KEY(id),
	CONSTRAINT country_id_fk FOREIGN KEY(country_id) REFERENCES country(id)
                        ON DELETE RESTRICT
                        ON UPDATE CASCADE
);

CREATE TABLE address(
	id INTEGER NOT NULL,
	street TEXT NOT NULL,
	postal_code TEXT NOT NULL,
	door_number INTEGER,
	city_id INTEGER NOT NULL,

	CONSTRAINT address_id_pk PRIMARY KEY(id),
	CONSTRAINT city_id_fk FOREIGN KEY(city_id) REFERENCES city(id)  
                        ON DELETE RESTRICT
                        ON UPDATE CASCADE
);

CREATE TABLE person_address_applied(
	person_id INTEGER NOT NULL,
	address_id INTEGER NOT NULL,

	CONSTRAINT person_address_pk PRIMARY KEY(person_id, address_id),
	CONSTRAINT person_id_fk FOREIGN KEY(person_id) REFERENCES person(id)
                        ON DELETE CASCADE
                        ON UPDATE CASCADE,
	CONSTRAINT address_id_fk FOREIGN KEY(address_id) REFERENCES address(id)
                        ON DELETE CASCADE
                        ON UPDATE CASCADE
);

CREATE TABLE shipment_type(
	id INTEGER NOT NULL,
	type TEXT UNIQUE NOT NULL,
	base_cost REAL NOT NULL,

	CONSTRAINT shipment_type_id_pk PRIMARY KEY(id),
	CONSTRAINT shipment_type_invalid CHECK(type LIKE 'ctt' OR type LIKE 'dpd' OR type LIKE 'dhl' 
						OR type LIKE 'ups' OR type LIKE 'inWarehouse'),

	CONSTRAINT shipment_type_cost CHECK(base_cost >= 0)
);

CREATE TABLE shipment(
	id INTEGER NOT NULL,
	shipment_date DATE, -- Waits until order status is shipped before being filled
	reception_date DATE,
	distance REAL NOT NULL,
	address_id INTEGER NOT NULL,
	shipment_type_id INTEGER NOT NULL,

	CONSTRAINT order_id_pk PRIMARY KEY(id),
	CONSTRAINT order_id_fk FOREIGN KEY(id) REFERENCES "order"(id)
                        ON DELETE RESTRICT
                        ON UPDATE CASCADE,
	CONSTRAINT address_id_fk FOREIGN KEY(address_id) REFERENCES address(id)
                        ON DELETE RESTRICT
                        ON UPDATE CASCADE,
	CONSTRAINT shipment_type_id_fk FOREIGN KEY(shipment_type_id) REFERENCES shipment_type(id)
                        ON DELETE RESTRICT
                        ON UPDATE CASCADE

	CONSTRAINT shipment_reception_after_shipment CHECK (reception_date IS NULL OR (shipment_date IS NOT NULL AND reception_date > shipment_date)),
	CONSTRAINT shipment_distance_positive CHECK (distance >= 0)	
);

CREATE TABLE payment_mb_way(
	id INTEGER NOT NULL,
	payment_date DATE DEFAULT CURRENT_TIMESTAMP,
	payment_value REAL NOT NULL,
	payment_phone_number TEXT NOT NULL,
	
	CONSTRAINT order_id_pk PRIMARY KEY(id),
	CONSTRAINT order_id_fk FOREIGN KEY(id) REFERENCES "order"(id)
                        ON DELETE RESTRICT
                        ON UPDATE CASCADE

	

    	CONSTRAINT payment_mb_not_current_date CHECK (payment_date == CURRENT_TIMESTAMP),
	CONSTRAINT payment_value_positive CHECK (payment_value > 0)
);

CREATE TABLE payment_credit_card(
	id INTEGER NOT NULL,
	payment_date DATE DEFAULT CURRENT_TIMESTAMP,
	payment_value REAL NOT NULL,
	card_number TEXT NOT NULL,
	card_name TEXT NOT NULL,
	code TEXT NOT NULL,

	CONSTRAINT order_id_pk PRIMARY KEY(id),
	CONSTRAINT order_id_fk FOREIGN KEY(id) REFERENCES "order"(id)
                        ON DELETE RESTRICT
                        ON UPDATE CASCADE

	
    	CONSTRAINT payment_credit_not_current_date CHECK (payment_date == CURRENT_TIMESTAMP)
	CONSTRAINT payment_value_positive CHECK (payment_value > 0)
);
---------------------------------------------------------------------------------------------------------

CREATE TABLE review(
    order_id INTEGER,
    product_id INTEGER,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    rating REAL NOT NULL,

    CONSTRAINT review_pk PRIMARY KEY(order_id, product_id),
	CONSTRAINT order_id_fk FOREIGN KEY(order_id) REFERENCES "order"(id)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE,
    CONSTRAINT product_id_fk FOREIGN KEY(product_id) REFERENCES product(id)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE,

    CONSTRAINT rating_options CHECK (rating >= 0 OR rating <= 5)
);

