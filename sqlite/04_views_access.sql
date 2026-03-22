-- Разграничение «по ролям» через представления (SQLite не поддерживает GRANT)
-- Аналитик: только эти представления + audit_log_readonly

DROP VIEW IF EXISTS v_readonly_catalog;
CREATE VIEW v_readonly_catalog AS
SELECT
  b.book_id,
  b.title,
  b.isbn,
  b.price,
  b.stock_qty,
  a.full_name AS author_name,
  a.country
FROM books b
JOIN authors a ON a.author_id = b.author_id;

DROP VIEW IF EXISTS v_readonly_orders;
CREATE VIEW v_readonly_orders AS
SELECT
  o.order_id,
  o.order_date,
  o.total_amount,
  o.status,
  c.email,
  c.full_name AS customer_name
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id;

DROP VIEW IF EXISTS v_audit_readonly;
CREATE VIEW v_audit_readonly AS
SELECT log_id, table_name, operation, row_pk, old_row, new_row, changed_at
FROM audit_log;

-- Продажи: оформление без прямого изменения authors (через приложение — только INSERT в customers/orders)
-- Для чистого SQL-сценария оставляем таблицы; в политике зафиксировано, какие объекты трогает роль.
