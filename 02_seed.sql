-- 02_seed.sql — insert sample data
USE mini_store;

-- Customers
INSERT INTO customers (first_name, last_name, email, city) VALUES
('Asha',  'Rao',    'asha.rao@example.com',    'Bangalore'),
('Vikram','Singh',  'vikram.singh@example.com','Mumbai'),
('Neha',  'Gupta',  'neha.gupta@example.com',  'Delhi'),
('Arjun', 'Patel',  'arjun.patel@example.com', 'Pune'),
('Riya',  'Sharma', 'riya.sharma@example.com', 'Bangalore'),
('Kabir', 'Mehta',  'kabir.mehta@example.com', 'Hyderabad');

-- Products
INSERT INTO products (name, category, price, stock) VALUES
('Espresso Beans 1kg',       'Beverage',   799.00, 100),
('French Press',             'Equipment', 1499.00,  50),
('Ceramic Mug',              'Merchandise',299.00, 200),
('Cold Brew Bottle',         'Beverage',  1299.00,  80),
('Drip Filter Papers (100)', 'Consumable', 199.00, 300),
('Milk Frother',             'Equipment',  999.00,  60);

-- Orders
INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2025-07-02 10:15:00', 'PAID'),
(2, '2025-07-15 16:40:00', 'SHIPPED'),
(1, '2025-08-03 12:05:00', 'PAID'),
(3, '2025-08-20 09:30:00', 'CANCELLED'),
(4, '2025-08-25 18:20:00', 'PAID'),
(5, '2025-09-01 11:00:00', 'PAID');

-- Order items (for non-cancelled orders)
-- Order 1 (Asha)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 799.00),
(1, 3, 2, 299.00);

-- Order 2 (Vikram)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(2, 2, 1, 1499.00),
(2, 5, 2, 199.00);

-- Order 3 (Asha)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(3, 4, 1, 1299.00),
(3, 1, 1, 799.00),
(3, 6, 1, 999.00);

-- Order 5 (Arjun)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(5, 3, 4, 299.00),
(5, 5, 3, 199.00);

-- Order 6 (Riya)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(6, 6, 1, 999.00),
(6, 1, 3, 799.00);
