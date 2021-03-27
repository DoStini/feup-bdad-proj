PRAGMA foreign_keys=ON;

DROP TABLE IF EXISTS product_category_applied;
DROP TABLE IF EXISTS cart_quantity;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS person;


CREATE TABLE person(
    id INTEGER,
    name TEXT NOT NULL,
    birthdate DATE NOT NULL,
    nif INTEGER NOT NULL UNIQUE, /* Inserir restricao de tamanho*/
    telephone INTEGER NOT NULL UNIQUE, /* Same here */
    email TEXT NOT NULL UNIQUE,

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
    -- CONSTRAINT product_man_fk FOREIGN KEY(manufacturer_id) REFERENCES manufacturer(id)
);


CREATE TABLE product_category_applied(
    product_id INTEGER,
    category_id INTEGER,

    CONSTRAINT product_category_applied_pk PRIMARY KEY(product_id, category_id),
    CONSTRAINT product_category_applied_prod_fk FOREIGN KEY(product_id) REFERENCES product(id),
    CONSTRAINT product_category_applied_cat_fk FOREIGN KEY(category_id) REFERENCES category(id)
);

