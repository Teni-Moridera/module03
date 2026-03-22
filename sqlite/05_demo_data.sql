INSERT INTO authors (full_name, country) VALUES
  ('Лев Толстой', 'RU'),
  ('Джордж Оруэлл', 'UK');

INSERT INTO books (author_id, title, isbn, price, stock_qty)
SELECT author_id, 'Война и мир', '978-5-000-00001-1', 799.0, 12 FROM authors WHERE full_name = 'Лев Толстой'
UNION ALL
SELECT author_id, '1984', '978-5-000-00002-8', 450.0, 30 FROM authors WHERE full_name = 'Джордж Оруэлл';

INSERT INTO customers (email, full_name, phone) VALUES
  ('ivan@example.com', 'Иван Петров', '+79001234567');

INSERT INTO orders (customer_id, total_amount, status)
SELECT customer_id, 1249.0, 'new' FROM customers WHERE email = 'ivan@example.com';

INSERT INTO order_items (order_id, book_id, quantity, unit_price)
SELECT o.order_id, b.book_id, 1, b.price
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN books b ON b.title = 'Война и мир'
WHERE c.email = 'ivan@example.com';
