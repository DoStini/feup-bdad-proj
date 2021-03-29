DROP TABLE IF EXISTS manufacturer;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS subcategory;
DROP TABLE IF EXISTS storage;
DROP TABLE IF EXISTS stock;
DROP TABLE IF EXISTS "order";

PRAGMA foreign_keys=ON;

CREATE TABLE manufacturer (
    id INTEGER,
    name TEXT NOT NULL UNIQUE,

    CONSTRAINT manufacturer_pk PRIMARY KEY(id)
);


CREATE TABLE category (
    id INTEGER,
    name TEXT NOT NULL UNIQUE,

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