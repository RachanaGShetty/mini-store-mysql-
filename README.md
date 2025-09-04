# Mini Store Database Management (MySQL Project)

## Project Description
This is a beginner-friendly MySQL project that simulates a mini online store.  
It includes tables for **customers, products, orders, and order items**, with sample data and queries to extract business insights.  
A transaction demo shows how to safely insert orders with rollback/commit.

## Queries

##Query 1 – List all products sorted by price
```sql
SELECT product_id, name, category, price, stock
FROM products
ORDER BY price DESC;
##Query 2 – Find all customers in Bangalore
SELECT customer_id, first_name, last_name, email, city
FROM customers
WHERE LOWER(city) = 'bangalore';
##Query 3 – Show orders with customer name and total amount
SELECT
  o.order_id,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  o.order_date,
  o.status,
  IFNULL(SUM(oi.quantity * oi.unit_price),0) AS order_total
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, c.first_name, c.last_name, o.order_date, o.status
ORDER BY o.order_date DESC;
##Query 5 – Transaction Demo (Safe order insert)
START TRANSACTION;

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, NOW(), 'PENDING');

SET @last_order_id = LAST_INSERT_ID();

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES 
(@last_order_id, 2, 1, 799.00),
(@last_order_id, 5, 2, 299.00);

-- Commit or rollback
-- COMMIT;
-- ROLLBACK;


Relational database design (tables and relationships).
SQL basics: SELECT, JOIN, GROUP BY, ORDER BY.
Transactions for data integrity (COMMIT and ROLLBACK).


