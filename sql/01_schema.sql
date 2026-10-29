-- Anadolu Home (fictional) - schema. SQLite dialect.
CREATE TABLE customers (
    customer_id         INTEGER PRIMARY KEY,
    city                TEXT NOT NULL,
    first_order_date    TEXT NOT NULL,
    acquisition_channel TEXT NOT NULL
);
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    category   TEXT NOT NULL,
    list_price REAL NOT NULL,
    unit_cost  REAL NOT NULL
);
CREATE TABLE orders (
    order_id       INTEGER PRIMARY KEY,
    customer_id    INTEGER NOT NULL REFERENCES customers(customer_id),
    order_date     TEXT NOT NULL,
    promised_days  INTEGER NOT NULL,   -- delivery SLA shown at checkout
    delivered_days INTEGER,            -- actual days; NULL if cancelled
    status         TEXT NOT NULL CHECK (status IN ('delivered','cancelled','returned')),
    payment_method TEXT NOT NULL,
    discount_pct   REAL NOT NULL
);
CREATE TABLE order_items (
    order_id   INTEGER NOT NULL REFERENCES orders(order_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity   INTEGER NOT NULL,
    unit_price REAL NOT NULL           -- price after discount
);
CREATE TABLE reviews (
    order_id INTEGER PRIMARY KEY REFERENCES orders(order_id),
    rating   INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5)
);
CREATE TABLE web_funnel (
    month            TEXT PRIMARY KEY,  -- YYYY-MM
    sessions         INTEGER,
    product_views    INTEGER,
    add_to_cart      INTEGER,
    checkout_started INTEGER,
    orders_placed    INTEGER
);
