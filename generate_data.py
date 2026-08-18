"""
Task 6 - Sales Trend Analysis Using Aggregations
Generates a realistic 'orders' dataset (online_sales) and loads it into SQLite
so the SQL script can be executed and real results produced.
"""

import sqlite3
import random
from datetime import date, timedelta

random.seed(42)

DB_PATH = "online_sales.db"

conn = sqlite3.connect(DB_PATH)
cur = conn.cursor()

cur.executescript("""
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    order_date  DATE NOT NULL,
    amount      DECIMAL(10,2),
    product_id  INTEGER NOT NULL
);
""")

products = list(range(101, 121))  # 20 products

start_date = date(2024, 1, 1)
end_date = date(2024, 12, 31)

rows = []
d = start_date
while d <= end_date:
    # vary number of orders per day (simulate weekday/weekend + seasonal spikes)
    base_orders = random.randint(3, 10)
    if d.weekday() >= 5:  # weekend boost
        base_orders += random.randint(2, 5)
    if d.month in (11, 12):  # festive season boost (Diwali/year-end sale)
        base_orders += random.randint(4, 8)

    for _ in range(base_orders):
        product_id = random.choice(products)
        amount = round(random.uniform(199, 8999), 2)
        # occasionally insert a NULL amount to simulate real-world messy data
        if random.random() < 0.01:
            amount = None
        rows.append((d.isoformat(), amount, product_id))

    d += timedelta(days=1)

cur.executemany(
    "INSERT INTO orders (order_date, amount, product_id) VALUES (?, ?, ?)",
    rows
)
conn.commit()

count = cur.execute("SELECT COUNT(*) FROM orders").fetchone()[0]
null_count = cur.execute("SELECT COUNT(*) FROM orders WHERE amount IS NULL").fetchone()[0]
print(f"Inserted {count} rows into orders table ({null_count} rows have NULL amount to simulate messy data).")

conn.close()
