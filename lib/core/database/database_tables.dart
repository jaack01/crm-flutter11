class DatabaseTables {
  // Prevent instantiation
  DatabaseTables._();

  // ============================================================================
  // TABLE CREATION STATEMENTS
  // ============================================================================

  /// Customers table
  static const String createCustomersTable = '''
    CREATE TABLE customers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_code TEXT UNIQUE NOT NULL,
      first_name TEXT NOT NULL,
      last_name TEXT,
      phone TEXT UNIQUE NOT NULL,
      email TEXT,
      alternate_phone TEXT,
      address TEXT,
      city TEXT,
      pincode TEXT,
      customer_type TEXT DEFAULT 'Regular',
      loyalty_points INTEGER DEFAULT 0,
      photo_path TEXT,
      notes TEXT,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP,
      updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
      is_active INTEGER DEFAULT 1
    )
  ''';

  /// Orders table
  static const String createOrdersTable = '''
    CREATE TABLE orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      order_number TEXT UNIQUE NOT NULL,
      customer_id INTEGER NOT NULL,
      order_date TEXT DEFAULT CURRENT_TIMESTAMP,
      expected_delivery_date TEXT,
      actual_delivery_date TEXT,
      status TEXT DEFAULT 'Received',
      is_rush_order INTEGER DEFAULT 0,
      total_items INTEGER DEFAULT 0,
      subtotal REAL DEFAULT 0,
      discount REAL DEFAULT 0,
      tax_amount REAL DEFAULT 0,
      total_amount REAL DEFAULT 0,
      advance_paid REAL DEFAULT 0,
      balance_amount REAL DEFAULT 0,
      payment_status TEXT DEFAULT 'Pending',
      special_instructions TEXT,
      created_by INTEGER,
      updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
    )
  ''';

  /// Order items table
  static const String createOrderItemsTable = '''
    CREATE TABLE order_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      order_id INTEGER NOT NULL,
      service_id INTEGER NOT NULL,
      item_type_id INTEGER NOT NULL,
      quantity INTEGER DEFAULT 1,
      unit_price REAL NOT NULL,
      total_price REAL NOT NULL,
      notes TEXT,
      FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
      FOREIGN KEY (service_id) REFERENCES services(id),
      FOREIGN KEY (item_type_id) REFERENCES item_types(id)
    )
  ''';

  /// Services table
  static const String createServicesTable = '''
    CREATE TABLE services (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      service_name TEXT NOT NULL,
      service_code TEXT UNIQUE NOT NULL,
      description TEXT,
      base_price REAL DEFAULT 0,
      is_active INTEGER DEFAULT 1,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP
    )
  ''';

  /// Item types table
  static const String createItemTypesTable = '''
    CREATE TABLE item_types (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      item_name TEXT NOT NULL,
      item_code TEXT UNIQUE NOT NULL,
      category TEXT,
      is_active INTEGER DEFAULT 1,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP
    )
  ''';

  /// Service pricing table
  static const String createServicePricingTable = '''
    CREATE TABLE service_pricing (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      service_id INTEGER NOT NULL,
      item_type_id INTEGER NOT NULL,
      price REAL NOT NULL,
      rush_price REAL,
      FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
      FOREIGN KEY (item_type_id) REFERENCES item_types(id) ON DELETE CASCADE,
      UNIQUE(service_id, item_type_id)
    )
  ''';

  /// Payments table
  static const String createPaymentsTable = '''
    CREATE TABLE payments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      order_id INTEGER NOT NULL,
      payment_date TEXT DEFAULT CURRENT_TIMESTAMP,
      amount REAL NOT NULL,
      payment_method TEXT NOT NULL,
      transaction_reference TEXT,
      notes TEXT,
      received_by INTEGER,
      FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
    )
  ''';

  /// Employees table
  static const String createEmployeesTable = '''
    CREATE TABLE employees (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      employee_code TEXT UNIQUE NOT NULL,
      first_name TEXT NOT NULL,
      last_name TEXT,
      phone TEXT UNIQUE NOT NULL,
      email TEXT,
      role TEXT NOT NULL,
      salary REAL,
      commission_rate REAL,
      joining_date TEXT,
      is_active INTEGER DEFAULT 1,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP
    )
  ''';

  /// Inventory items table
  static const String createInventoryItemsTable = '''
    CREATE TABLE inventory_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      item_name TEXT NOT NULL,
      item_code TEXT UNIQUE NOT NULL,
      category TEXT,
      unit TEXT,
      current_stock REAL DEFAULT 0,
      min_stock_level REAL DEFAULT 0,
      unit_price REAL,
      is_active INTEGER DEFAULT 1,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP
    )
  ''';

  /// Stock transactions table
  static const String createStockTransactionsTable = '''
    CREATE TABLE stock_transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      inventory_item_id INTEGER NOT NULL,
      transaction_type TEXT NOT NULL,
      quantity REAL NOT NULL,
      transaction_date TEXT DEFAULT CURRENT_TIMESTAMP,
      reference_id INTEGER,
      notes TEXT,
      FOREIGN KEY (inventory_item_id) REFERENCES inventory_items(id) ON DELETE CASCADE
    )
  ''';

  /// Expenses table
  static const String createExpensesTable = '''
    CREATE TABLE expenses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      expense_date TEXT NOT NULL,
      category TEXT NOT NULL,
      amount REAL NOT NULL,
      payment_method TEXT,
      description TEXT,
      receipt_path TEXT,
      created_at TEXT DEFAULT CURRENT_TIMESTAMP
    )
  ''';

  /// Settings table
  static const String createSettingsTable = '''
    CREATE TABLE settings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      setting_key TEXT UNIQUE NOT NULL,
      setting_value TEXT,
      updated_at TEXT DEFAULT CURRENT_TIMESTAMP
    )
  ''';

  // ============================================================================
  // INDEX CREATION STATEMENTS
  // ============================================================================

  static const String createCustomersIndexes = '''
    CREATE INDEX idx_customers_phone ON customers(phone);
    CREATE INDEX idx_customers_customer_code ON customers(customer_code);
    CREATE INDEX idx_customers_customer_type ON customers(customer_type);
  ''';

  static const String createOrdersIndexes = '''
    CREATE INDEX idx_orders_order_number ON orders(order_number);
    CREATE INDEX idx_orders_customer_id ON orders(customer_id);
    CREATE INDEX idx_orders_status ON orders(status);
    CREATE INDEX idx_orders_order_date ON orders(order_date);
    CREATE INDEX idx_orders_payment_status ON orders(payment_status);
  ''';

  static const String createPaymentsIndexes = '''
    CREATE INDEX idx_payments_order_id ON payments(order_id);
    CREATE INDEX idx_payments_payment_date ON payments(payment_date);
  ''';

  // ============================================================================
  // DEFAULT DATA INSERTION
  // ============================================================================

  /// Insert default services
  static const String insertDefaultServices = '''
    INSERT INTO services (service_name, service_code, description, base_price) VALUES
    ('Wash & Iron', 'WASH_IRON', 'Regular washing and ironing service', 50.0),
    ('Dry Clean', 'DRY_CLEAN', 'Dry cleaning service for delicate items', 150.0),
    ('Iron Only', 'IRON_ONLY', 'Only ironing service', 20.0),
    ('Wash Only', 'WASH_ONLY', 'Only washing service', 30.0),
    ('Stain Removal', 'STAIN_REMOVAL', 'Special stain removal treatment', 100.0),
    ('Steam Press', 'STEAM_PRESS', 'Steam pressing for formal wear', 80.0);
  ''';

  /// Insert default item types
  static const String insertDefaultItemTypes = '''
    INSERT INTO item_types (item_name, item_code, category) VALUES
    -- Clothing
    ('Shirt', 'SHIRT', 'Clothing'),
    ('T-Shirt', 'TSHIRT', 'Clothing'),
    ('Pants', 'PANTS', 'Clothing'),
    ('Jeans', 'JEANS', 'Clothing'),
    ('Skirt', 'SKIRT', 'Clothing'),
    ('Dress', 'DRESS', 'Clothing'),
    ('Suit', 'SUIT', 'Clothing'),
    ('Blazer', 'BLAZER', 'Clothing'),
    ('Jacket', 'JACKET', 'Clothing'),
    ('Coat', 'COAT', 'Clothing'),
    ('Saree', 'SAREE', 'Clothing'),
    ('Kurta', 'KURTA', 'Clothing'),
    ('Salwar Kameez', 'SALWAR_KAMEEZ', 'Clothing'),

    -- Bedding
    ('Bedsheet', 'BEDSHEET', 'Bedding'),
    ('Blanket', 'BLANKET', 'Bedding'),
    ('Comforter', 'COMFORTER', 'Bedding'),
    ('Pillow Cover', 'PILLOW_COVER', 'Bedding'),
    ('Duvet', 'DUVET', 'Bedding'),

    -- Accessories
    ('Tie', 'TIE', 'Accessories'),
    ('Scarf', 'SCARF', 'Accessories'),
    ('Handkerchief', 'HANDKERCHIEF', 'Accessories'),

    -- Home
    ('Curtain', 'CURTAIN', 'Home'),
    ('Towel', 'TOWEL', 'Home'),
    ('Table Cloth', 'TABLE_CLOTH', 'Home'),
    ('Carpet', 'CARPET', 'Home');
  ''';

  /// Insert default settings
  static const String insertDefaultSettings = '''
    INSERT INTO settings (setting_key, setting_value) VALUES
    ('shop_name', 'Laundry Shop'),
    ('shop_address', ''),
    ('shop_phone', ''),
    ('shop_email', ''),
    ('tax_rate', '18.0'),
    ('currency_symbol', '₹'),
    ('theme_mode', 'light'),
    ('next_customer_number', '1'),
    ('next_order_number', '1'),
    ('next_employee_number', '1'),
    ('order_number_prefix', 'ORD'),
    ('customer_number_prefix', 'CUST'),
    ('employee_number_prefix', 'EMP'),
    ('low_stock_notification', '1'),
    ('order_reminder_notification', '1'),
    ('payment_reminder_notification', '1'),
    ('default_delivery_days', '3'),
    ('rush_order_premium_percent', '50');
  ''';
}
