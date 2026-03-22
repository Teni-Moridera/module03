-- Роли и учётные записи (логическая модель; пароли — заглушки для отчёта)

INSERT INTO roles (role_name, description) VALUES
  ('admin', 'Полный доступ к каталогу, заказам и журналу аудита'),
  ('librarian', 'Справочники authors/books; заказы только чтение'),
  ('sales', 'Клиенты и заказы; каталог только чтение'),
  ('readonly', 'Только SELECT по согласованным представлениям');

INSERT INTO db_users (login, password_hash, role_id) VALUES
  ('u_admin',    'sha256:CHANGE_ME', (SELECT role_id FROM roles WHERE role_name = 'admin')),
  ('u_librarian','sha256:CHANGE_ME', (SELECT role_id FROM roles WHERE role_name = 'librarian')),
  ('u_sales',    'sha256:CHANGE_ME', (SELECT role_id FROM roles WHERE role_name = 'sales')),
  ('u_analyst',  'sha256:CHANGE_ME', (SELECT role_id FROM roles WHERE role_name = 'readonly'));
