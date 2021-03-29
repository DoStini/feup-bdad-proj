PRAGMA foreign_keys=ON;

DROP TABLE IF EXISTS Country;

CREATE TABLE Country(
	country_id INTEGER NOT NULL,
	country_name TEXT NOT NULL,

	CONSTRAINT country_id_pk PRIMARY KEY(country_id)
);

DROP TABLE IF EXISTS City;

CREATE TABLE City(
	city_id INTEGER NOT NULL,
	city_name TEXT NOT NULL,
	country_id INTEGER NOT NULL,

	CONSTRAINT city_id_pk PRIMARY KEY(city_id),
	CONSTRAINT country_id_fk FOREIGN KEY(country_id) REFERENCES Country(country_id)
);

DROP TABLE IF EXISTS Address;

CREATE TABLE Address(
	address_id INTEGER NOT NULL,
	street TEXT,
	postal_code TEXT,
	door_number INTEGER,
	city_id INTEGER NOT NULL,

	CONSTRAINT address_id_pk PRIMARY KEY(address_id),
	CONSTRAINT city_id_fk FOREIGN KEY(city_id) REFERENCES City(city_id)
);

DROP TABLE IF EXISTS Person_address_applied;

CREATE TABLE Person_address_applied(
	person_id INTEGER NOT NULL,
	address_id INTEGER NOT NULL,

	CONSTRAINT person_address_pk PRIMARY KEY(person_id, address_id),
	CONSTRAINT person_id_fk FOREIGN KEY(person_id) REFERENCES Person(person_id),
	CONSTRAINT address_id_fk FOREIGN KEY(address_id) REFERENCES Address(address_id)
);

DROP TABLE IF EXISTS Shipment_type;

CREATE TABLE Shipment_type(
	shipment_type_id INTEGER PRIMARY KEY,
	type TEXT NOT NULL,
	base_cost REAL NOT NULL
);

DROP TABLE IF EXISTS Shipment;

CREATE TABLE Shipment(
	order_id INTEGER NOT NULL,
	shipment_date DATE,
	reception_date DATE,
	distance REAL NOT NULL,
	address_id INTEGER NOT NULL REFERENCES Address(address_id),
	shipment_type_id INTEGER NOT NULL REFERENCES Shipment_type(shipment_type_id),

	CONSTRAINT order_id_pk PRIMARY KEY(order_id),
	CONSTRAINT order_id_fk FOREIGN KEY(order_id) 
		REFERENCES "Order",
	CONSTRAINT address_id_fk FOREIGN KEY(address_id) 
		REFERENCES Address(address_id),
	CONSTRAINT shipment_type_id_fk FOREIGN KEY(shipment_type_id)
       		REFERENCES Shipment_type(shipment_type_id)
);

DROP TABLE IF EXISTS Payment_mb_way;

CREATE TABLE Payment_mb_way(
	order_id INTEGER NOT NULL,
	payment_date DATE,
	payment_value REAL NOT NULL,
	payment_phone_number TEXT NOT NULL,
	
	CONSTRAINT order_id_pk PRIMARY KEY(order_id),
	CONSTRAINT order_id_fk FOREIGN KEY(order_id) 
		REFERENCES "Order"
);

DROP TABLE IF EXISTS Payment_credit_card;

CREATE TABLE Payment_credit_card(
	order_id INTEGER NOT NULL,
	payment_date DATE,
	payment_value REAL,
	card_number TEXT NOT NULL,
	card_name TEXT NOT NULL,
	code TEXT NOT NULL,

	CONSTRAINT order_id_pk PRIMARY KEY(order_id),
	CONSTRAINT order_id_fk FOREIGN KEY(order_id) 
		REFERENCES "Order"
);

