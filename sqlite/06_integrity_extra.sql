-- Дополнительный контроль целостности (SQLite: ограничения на уровне таблиц + PRAGMA)

-- Индексы для целостности доступа к данным и производительности журнала
CREATE INDEX IF NOT EXISTS idx_books_author ON books (author_id);
CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders (customer_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items (order_id);
CREATE INDEX IF NOT EXISTS idx_audit_time ON audit_log (changed_at DESC);

-- Серверный аудит SQLite: см. ПОЛИТИКА — trace/profile на уровне соединения;
-- в файле БД фиксируем триггерный журнал audit_log.
