require 'sqlite3'

class SqlService
  def initialize
    @db = SQLite3::Database.new(':memory:')
    setup_database
  end

  def setup_database
    @db.execute <<-SQL
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY,
        customer TEXT,
        amount REAL,
        order_date DATE
      );
    SQL

    @db.execute <<-SQL
      INSERT INTO orders (customer, amount, order_date) VALUES
      ('Alice', 5000, '2024-03-01'),
      ('Bob', 8000, '2024-03-05'),
      ('Alice', 3000, '2024-03-15'),
      ('Charlie', 7000, '2024-02-20'),
      ('Alice', 10000, '2024-02-28'),
      ('Bob', 4000, '2024-02-10'),
      ('Charlie', 9000, '2024-03-22'),
      ('Alice', 2000, '2024-03-30');
    SQL
  end

  def run_queries
    results = {}

    # Total sales for March
    results[:march_sales] = @db.execute(<<-SQL).first.first
      SELECT SUM(amount) as total_march_sales
      FROM orders
      WHERE strftime('%m', order_date) = '03';
    SQL

    # Top-spending customer
    results[:top_customer] = @db.execute(<<-SQL).first
      SELECT customer, SUM(amount) as total_spent
      FROM orders
      GROUP BY customer
      ORDER BY total_spent DESC
      LIMIT 1;
    SQL

    # Average order value
    results[:avg_order] = @db.execute(<<-SQL).first.first
      SELECT AVG(amount) as avg_order_value
      FROM orders;
    SQL

    results
  end

  def reset_database
    @db.close
    @db = SQLite3::Database.new(':memory:')
    setup_database
  end
end 