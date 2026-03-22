-- Триггеры: контроль остатка + журнал изменений (отдельно INSERT/UPDATE/DELETE — правила OLD/NEW в SQLite)

CREATE TRIGGER trg_books_stock_check
BEFORE INSERT OR UPDATE OF stock_qty ON books
FOR EACH ROW
WHEN NEW.stock_qty < 0
BEGIN
  SELECT RAISE(ABORT, 'stock_qty не может быть отрицательным');
END;

CREATE TRIGGER trg_books_ai
AFTER INSERT ON books
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, operation, row_pk, old_row, new_row)
  VALUES (
    'books', 'INSERT', NEW.book_id, NULL,
    json_object(
      'book_id', NEW.book_id, 'author_id', NEW.author_id, 'title', NEW.title,
      'isbn', NEW.isbn, 'price', NEW.price, 'stock_qty', NEW.stock_qty
    )
  );
END;

CREATE TRIGGER trg_books_au
AFTER UPDATE ON books
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, operation, row_pk, old_row, new_row)
  VALUES (
    'books', 'UPDATE', NEW.book_id,
    json_object(
      'book_id', OLD.book_id, 'author_id', OLD.author_id, 'title', OLD.title,
      'isbn', OLD.isbn, 'price', OLD.price, 'stock_qty', OLD.stock_qty
    ),
    json_object(
      'book_id', NEW.book_id, 'author_id', NEW.author_id, 'title', NEW.title,
      'isbn', NEW.isbn, 'price', NEW.price, 'stock_qty', NEW.stock_qty
    )
  );
END;

CREATE TRIGGER trg_books_ad
AFTER DELETE ON books
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, operation, row_pk, old_row, new_row)
  VALUES (
    'books', 'DELETE', OLD.book_id,
    json_object(
      'book_id', OLD.book_id, 'author_id', OLD.author_id, 'title', OLD.title,
      'isbn', OLD.isbn, 'price', OLD.price, 'stock_qty', OLD.stock_qty
    ),
    NULL
  );
END;

CREATE TRIGGER trg_orders_ai
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, operation, row_pk, old_row, new_row)
  VALUES (
    'orders', 'INSERT', NEW.order_id, NULL,
    json_object(
      'order_id', NEW.order_id, 'customer_id', NEW.customer_id,
      'total_amount', NEW.total_amount, 'status', NEW.status
    )
  );
END;

CREATE TRIGGER trg_orders_au
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, operation, row_pk, old_row, new_row)
  VALUES (
    'orders', 'UPDATE', NEW.order_id,
    json_object(
      'order_id', OLD.order_id, 'customer_id', OLD.customer_id,
      'total_amount', OLD.total_amount, 'status', OLD.status
    ),
    json_object(
      'order_id', NEW.order_id, 'customer_id', NEW.customer_id,
      'total_amount', NEW.total_amount, 'status', NEW.status
    )
  );
END;

CREATE TRIGGER trg_orders_ad
AFTER DELETE ON orders
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, operation, row_pk, old_row, new_row)
  VALUES (
    'orders', 'DELETE', OLD.order_id,
    json_object(
      'order_id', OLD.order_id, 'customer_id', OLD.customer_id,
      'total_amount', OLD.total_amount, 'status', OLD.status
    ),
    NULL
  );
END;

CREATE TRIGGER trg_order_items_ai
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, operation, row_pk, old_row, new_row)
  VALUES (
    'order_items', 'INSERT', NEW.item_id, NULL,
    json_object(
      'item_id', NEW.item_id, 'order_id', NEW.order_id, 'book_id', NEW.book_id,
      'quantity', NEW.quantity, 'unit_price', NEW.unit_price
    )
  );
END;

CREATE TRIGGER trg_order_items_au
AFTER UPDATE ON order_items
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, operation, row_pk, old_row, new_row)
  VALUES (
    'order_items', 'UPDATE', NEW.item_id,
    json_object(
      'item_id', OLD.item_id, 'order_id', OLD.order_id, 'book_id', OLD.book_id,
      'quantity', OLD.quantity, 'unit_price', OLD.unit_price
    ),
    json_object(
      'item_id', NEW.item_id, 'order_id', NEW.order_id, 'book_id', NEW.book_id,
      'quantity', NEW.quantity, 'unit_price', NEW.unit_price
    )
  );
END;

CREATE TRIGGER trg_order_items_ad
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, operation, row_pk, old_row, new_row)
  VALUES (
    'order_items', 'DELETE', OLD.item_id,
    json_object(
      'item_id', OLD.item_id, 'order_id', OLD.order_id, 'book_id', OLD.book_id,
      'quantity', OLD.quantity, 'unit_price', OLD.unit_price
    ),
    NULL
  );
END;
