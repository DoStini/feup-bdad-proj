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

PRAGMA foreign_keys=ON;

CREATE TABLE person(
    id INTEGER,
    name TEXT NOT NULL,
    birthdate DATE NOT NULL,
    nif INTEGER NOT NULL UNIQUE, /* Inserir restricao de tamanho*/
    telephone INTEGER NOT NULL, /* Same here */
    email TEXT NOT NULL UNIQUE,

    CONSTRAINT person_valid_nif CHECK(length(nif) == 9),
    CONSTRAINT person_valid_phone CHECK(length(telephone) == 9),
    CONSTRAINT person_valid_birthdate CHECK(birthdate==strftime('%Y-%m-%d', birthdate) AND birthdate < CURRENT_TIMESTAMP),
    CONSTRAINT person_pk PRIMARY KEY(id)
);


CREATE TABLE client(
    id INTEGER,
    hash_password TEXT NOT NULL,

    CONSTRAINT client_password_valid_md5 CHECK(length(hash_password) == 32),

    CONSTRAINT client_pk PRIMARY KEY(id),
    CONSTRAINT client_fk FOREIGN KEY(id) REFERENCES person(id)
);


CREATE TABLE employee(
    id INTEGER,
    salary INTEGER NOT NULL,
    weekly_hours INTEGER NOT NULL,

    CONSTRAINT employee_valid_salary CHECK (salary > 0),
    CONSTRAINT employee_valid_hours CHECK (weekly_hours > 0 AND weekly_hours <= 168),

    CONSTRAINT employee_pk PRIMARY KEY(id),
    CONSTRAINT employee_fk FOREIGN KEY(id) REFERENCES person(id)
);


CREATE TABLE cart(
    id INTEGER,
    date DATE DEFAULT CURRENT_TIMESTAMP,
    client_id INTEGER NOT NULL,

    CONSTRAINT cart_id_pk PRIMARY KEY (id),
    CONSTRAINT client_id_fk FOREIGN KEY(client_id) REFERENCES Client(id),

    CONSTRAINT cart_not_current_date CHECK ( date == CURRENT_TIMESTAMP )
);


CREATE TABLE cart_quantity(
    cart_id INTEGER,
    product_id INTEGER,
    amount INTEGER NOT NULL,
    price INTEGER,
    -- Podemos usar o price apenas para mais tarde, atualizar todos ao fazer uma order para ter o preço atualizado
    -- Por enquanto pode então ser qualquer valor, visto que depois vai ser atualizado

    CONSTRAINT cart_quantity_valid_amount CHECK (amount > 0),
    CONSTRAINT cart_quantity_valid_price CHECK (price > 0),

    CONSTRAINT cart_quantity_pk PRIMARY KEY(cart_id, product_id),
    CONSTRAINT cart_quantity_cart_id_fk FOREIGN KEY (cart_id) REFERENCES cart(id),
    CONSTRAINT cart_quantity_prod_fk FOREIGN KEY (product_id) REFERENCES product(id)
);


CREATE TABLE product(
    id INTEGER,
    name TEXT NOT NULL,
    price INTEGER NOT NULL,
    description TEXT,
    manufacturer_id INTEGER,

    CONSTRAINT product_valid_price CHECK(price > 0),

    CONSTRAINT product_pk PRIMARY KEY (id)
    CONSTRAINT product_man_fk FOREIGN KEY(manufacturer_id) REFERENCES manufacturer(id)
);


CREATE TABLE product_category_applied(
    product_id INTEGER,
    category_id INTEGER,

    CONSTRAINT product_category_applied_pk PRIMARY KEY(product_id, category_id),
    CONSTRAINT product_category_applied_prod_fk FOREIGN KEY(product_id) REFERENCES product(id),
    CONSTRAINT product_category_applied_cat_fk FOREIGN KEY(category_id) REFERENCES category(id)
);


---------------------------------------------------------------------------------------------------------


CREATE TABLE manufacturer (
    id INTEGER,
    name TEXT NOT NULL,

    CONSTRAINT manufacturer_pk PRIMARY KEY(id)
);


CREATE TABLE category (
    id INTEGER,
    name TEXT NOT NULL,

    CONSTRAINT category_pk PRIMARY KEY(id)
);


CREATE TABLE subcategory (
    id INTEGER,
    parent_id INTEGER,


    CONSTRAINT subcategory_pk PRIMARY KEY(id),
    
    CONSTRAINT subcategory_id_fk FOREIGN KEY(id) REFERENCES category(id),
    CONSTRAINT subcategory_parent_id_fk FOREIGN KEY(parent_id) REFERENCES category(id)
);



CREATE TABLE storage(
    id INTEGER,
    storage_name TEXT NOT NULL,
    address_id INTEGER NOT NULL,

    CONSTRAINT storage_pk PRIMARY KEY(id),

    CONSTRAINT storage_address_id_fk FOREIGN KEY(address_id) REFERENCES Address(id)
);


CREATE TABLE stock (
    product_id INTEGER,
    storage_id INTEGER,
    amount INTEGER NOT NULL,

    CONSTRAINT stock_amount CHECK (amount >= 0),

    CONSTRAINT stock_pk PRIMARY KEY(product_id,storage_id),

    CONSTRAINT stock_product_id_fk FOREIGN KEY(product_id) REFERENCES product(id),
    CONSTRAINT stock_storage_id_fk FOREIGN KEY(storage_id) REFERENCES storage(id)
);

CREATE TABLE "order" (
    id INTEGER,
    cart_id INTEGER NOT NULL,
    employee_id INTEGER,
    date DATE DEFAULT CURRENT_TIMESTAMP,
    status TEXT NOT NULL,

    CONSTRAINT order_pk PRIMARY KEY(id),

    CONSTRAINT order_employee_id_fk FOREIGN KEY(employee_id) REFERENCES employee(id),
    CONSTRAINT order_cart_id_fk FOREIGN KEY(cart_id) REFERENCES cart(id),

    CONSTRAINT order_not_current_date CHECK (date == CURRENT_TIMESTAMP),
    CONSTRAINT order_status_options CHECK (status == "waiting" OR status == "processing" OR status == "shipped" OR status == "delivered"),
    CONSTRAINT order_employee_assignment CHECK ((status == "waiting" AND employee_id IS NULL) OR (status != "waiting" AND employee_id IS NOT NULL))
);


---------------------------------------------------------------------------------------------------------


CREATE TABLE country(
	country_id INTEGER NOT NULL,
	country_name TEXT NOT NULL,

	CONSTRAINT country_id_pk PRIMARY KEY(country_id)
);

CREATE TABLE city(
	city_id INTEGER NOT NULL,
	city_name TEXT NOT NULL,
	country_id INTEGER NOT NULL,

	CONSTRAINT city_id_pk PRIMARY KEY(city_id),
	CONSTRAINT country_id_fk FOREIGN KEY(country_id) REFERENCES country(country_id)
);

CREATE TABLE address(
	address_id INTEGER NOT NULL,
	street TEXT,
	postal_code TEXT,
	door_number INTEGER,
	city_id INTEGER NOT NULL,

	CONSTRAINT address_id_pk PRIMARY KEY(address_id),
	CONSTRAINT city_id_fk FOREIGN KEY(city_id) REFERENCES city(city_id)
);

CREATE TABLE person_address_applied(
	person_id INTEGER NOT NULL,
	address_id INTEGER NOT NULL,

	CONSTRAINT person_address_pk PRIMARY KEY(person_id, address_id),
	CONSTRAINT person_id_fk FOREIGN KEY(person_id) REFERENCES person(person_id),
	CONSTRAINT address_id_fk FOREIGN KEY(address_id) REFERENCES address(address_id)
);

CREATE TABLE shipment_type(
	shipment_type_id INTEGER PRIMARY KEY,
	type TEXT NOT NULL,
	base_cost REAL NOT NULL
);

CREATE TABLE shipment(
	order_id INTEGER NOT NULL,
	shipment_date DATE,
	reception_date DATE,
	distance REAL NOT NULL,
	address_id INTEGER NOT NULL,
	shipment_type_id INTEGER NOT NULL,

	CONSTRAINT order_id_pk PRIMARY KEY(order_id),
	CONSTRAINT order_id_fk FOREIGN KEY(order_id) 
		REFERENCES "order"(id),
	CONSTRAINT address_id_fk FOREIGN KEY(address_id) 
		REFERENCES address(address_id),
	CONSTRAINT shipment_type_id_fk FOREIGN KEY(shipment_type_id)
       		REFERENCES shipment_type(shipment_type_id)
);

CREATE TABLE payment_mb_way(
	order_id INTEGER NOT NULL,
	payment_date DATE,
	payment_value REAL NOT NULL,
	payment_phone_number TEXT NOT NULL,
	
	CONSTRAINT order_id_pk PRIMARY KEY(order_id),
	CONSTRAINT order_id_fk FOREIGN KEY(order_id) 
		REFERENCES "order"(id)
);

CREATE TABLE payment_credit_card(
	order_id INTEGER NOT NULL,
	payment_date DATE,
	payment_value REAL,
	card_number TEXT NOT NULL,
	card_name TEXT NOT NULL,
	code TEXT NOT NULL,

	CONSTRAINT order_id_pk PRIMARY KEY(order_id),
	CONSTRAINT order_id_fk FOREIGN KEY(order_id) 
		REFERENCES "order"(id)
);
