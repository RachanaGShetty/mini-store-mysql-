-- 04_views_procs_triggers.sql — create a view, a stored procedure, and a trigger
USE mini_store;

-- Drop if existing
DROP VIEW IF EXISTS vw_order_totals;
DROP VIEW IF EXISTS vw_product_sales;
DROP PROCEDURE IF EXISTS sp_customer_summary;
DROP TRIGGER IF EXISTS trg_order_items_ai;

-- View: each order with item count and total amount
CREATE VIEW vw_order_totals AS
SELECT
  o.order_id,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  o.order_date,
  o.status,
  COUNT(oi.order_item_id) AS item_count,
  IFNULL(SUM(oi.quantity * oi.unit_price), 0) AS total_amount
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, customer_name, o.order_date, o.status;

-- View: product sales summary
CREATE VIEW vw_product_sales AS
SELECT
  p.product_id,
  p.name,
  IFNULL(SUM(oi.quantity), 0) AS total_qty,
  IFNULL(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name;

-- Stored procedure: summary for a given customer (orders + lifetime value)
DELIMITER //
CREATE PROCEDURE sp_customer_summary(IN p_customer_id INT)
BEGIN
  -- Orders for this customer
  SELECT o.order_id, o.order_date, o.status,
         IFNULL(SUM(oi.quantity * oi.unit_price), 0) AS order_total
  FROM orders o
  LEFT JOIN order_items oi ON oi.order_id = o.order_id
  WHERE o.customer_id = p_customer_id
  GROUP BY o.order_id, o.order_date, o.status
  ORDER BY o.order_date DESC;

  -- Lifetime spend + order count
  SELECT c.customer_id,
         CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
         IFNULL(SUM(oi.quantity * oi.unit_price), 0) AS lifetime_value,
         COUNT(DISTINCT o.order_id) AS orders_count
  FROM customers c
  LEFT JOIN orders o ON o.customer_id = c.customer_id
  LEFT JOIN order_items oi ON oi.order_id = o.order_id
  WHERE c.customer_id = p_customer_id
  GROUP BY c.customer_id;
END //
DELIMITER ;

-- Trigger: after inserting order_items, decrease stock of that product
DELIMITER //
CREATE TRIGGER trg_order_items_ai
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
  UPDATE products
  SET stock = stock - NEW.quantity
  WHERE product_id = NEW.product_id;
END //
DELIMITER ;
