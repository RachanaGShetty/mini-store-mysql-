-- check connection & current DB
SELECT VERSION();
SHOW DATABASES;
USE mini_store;        -- run this only if you already created the DB
-- 01_schema.sql — create database, tables, indexes
DROP DATABASE IF EXISTS mini_store;
CREATE DATABASE mini_store CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mini_store;

-- Customers
CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name  VARCHAR(50) NOT NULL,
  last_name   VARCHAR(50) NOT NULL,
  email       VARCHAR(120) NOT NULL UNIQUE,
  city        VARCHAR(80),
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Products
CREATE TABLE products (
  product_id  INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  category    VARCHAR(50),
  price       DECIMAL(10,2) NOT NULL,
  stock       INT NOT NULL DEFAULT 0,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Orders
CREATE TABLE orders (
  order_id    INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  order_date  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status      ENUM('PENDING','PAID','CANCELLED','SHIPPED') DEFAULT 'PENDING',
  CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_orders_customer_date (customer_id, order_date)
) ENGINE=InnoDB;

-- Order items
CREATE TABLE order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id      INT NOT NULL,
  product_id    INT NOT NULL,
  quantity      INT NOT NULL,
  unit_price    DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_items_order FOREIGN KEY (order_id)
    REFERENCES orders(order_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_items_product FOREIGN KEY (product_id)
    REFERENCES products(product_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_items_order (order_id),
  INDEX idx_items_product (product_id)
) ENGINE=InnoDB;

-- Helpful index for product search
CREATE INDEX idx_products_name ON products(name);
