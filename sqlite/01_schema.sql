-- SQLite: учебная БД «Книжный магазин» (≥4 таблиц предметной области + роли/пользователи)
-- Запуск: sqlite3 bookstore_lab.db ".read 01_schema.sql"

PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;

-- Логическая модель ролей и пользователей (SQLite не имеет GRANT/USER на уровне движка)
CREATE TABLE roles (
    role_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    role_name   TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE db_users (
    user_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    login       TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL, -- в учебном проекте заглушка; в бою — только хранить хэш
    role_id     INTEGER NOT NULL REFERENCES roles (role_id),
    is_active   INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
    created_at  TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE authors (
    author_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name   TEXT NOT NULL CHECK (length(trim(full_name)) >= 2),
    country     TEXT NOT NULL DEFAULT 'RU',
    created_at  TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE books (
    book_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    author_id   INTEGER NOT NULL REFERENCES authors (author_id) ON DELETE RESTRICT,
    title       TEXT NOT NULL CHECK (length(trim(title)) >= 1),
    isbn        TEXT UNIQUE,
    price       REAL NOT NULL CHECK (price >= 0),
    stock_qty   INTEGER NOT NULL DEFAULT 0 CHECK (stock_qty >= 0),
    created_at  TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    email       TEXT NOT NULL UNIQUE,
    full_name   TEXT NOT NULL,
    phone       TEXT,
    created_at  TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE orders (
    order_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id  INTEGER NOT NULL REFERENCES customers (customer_id) ON DELETE RESTRICT,
    order_date   TEXT NOT NULL DEFAULT (datetime('now')),
    total_amount REAL NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
    status       TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new', 'paid', 'shipped', 'cancelled'))
);

CREATE TABLE order_items (
    item_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id    INTEGER NOT NULL REFERENCES orders (order_id) ON DELETE CASCADE,
    book_id     INTEGER NOT NULL REFERENCES books (book_id) ON DELETE RESTRICT,
    quantity    INTEGER NOT NULL CHECK (quantity > 0),
    unit_price  REAL NOT NULL CHECK (unit_price >= 0),
    UNIQUE (order_id, book_id)
);

CREATE TABLE audit_log (
    log_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name  TEXT NOT NULL,
    operation   TEXT NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
    row_pk      TEXT,
    old_row     TEXT,
    new_row     TEXT,
    changed_at  TEXT NOT NULL DEFAULT (datetime('now'))
);
