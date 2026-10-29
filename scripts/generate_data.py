"""Generate the SYNTHETIC dataset for the Anadolu Home case study.

All data is randomly generated (fixed seed) - no real company or customer.
Output: data/anadolu_home.db (SQLite) + one CSV per table.
"""
import csv
import random
import sqlite3
from datetime import date, timedelta
from pathlib import Path

random.seed(42)
ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "data"
DATA.mkdir(exist_ok=True)

CITIES = {  # city: (weight, extra expected delivery delay in days)
    "Istanbul": (30, 0.0), "Ankara": (14, 0.2), "Izmir": (13, 0.1),
    "Bursa": (7, 0.3), "Antalya": (7, 0.4), "Konya": (5, 0.8),
    "Trabzon": (4, 1.6), "Van": (3, 2.6), "Diyarbakir": (4, 2.4),
    "Gaziantep": (5, 1.2), "Eskisehir": (4, 0.5), "Samsun": (4, 1.4),
}
CHANNELS = {"Organic": 35, "Paid Ads": 30, "Social": 20, "Email": 15}
CATEGORIES = {  # category: (n_products, price range, cost ratio, return base, delay bump)
    "Furniture": (14, (1800, 9500), 0.62, 0.14, 1.8),
    "Kitchen": (18, (120, 1400), 0.55, 0.05, 0.0),
    "Textile": (18, (150, 1800), 0.50, 0.06, 0.2),
    "Decor": (20, (80, 900), 0.48, 0.04, 0.0),
    "Lighting": (12, (200, 2200), 0.58, 0.07, 0.5),
}
PAYMENTS = {"Credit Card": 62, "Installment": 23, "Bank Transfer": 8, "Cash on Delivery": 7}
SEASON = {1: 0.8, 2: 0.8, 3: 0.9, 4: 0.95, 5: 1.0, 6: 0.9, 7: 0.85,
          8: 0.9, 9: 1.05, 10: 1.15, 11: 1.6, 12: 1.3}  # Nov = Black Friday
YEAR = 2025


def wchoice(d):
    return random.choices(list(d), weights=[v if isinstance(v, (int, float)) else v[0] for v in d.values()])[0]


# ---------------- products ----------------
products = []
pid = 1
for cat, (n, (lo, hi), cost_ratio, _, _) in CATEGORIES.items():
    for _ in range(n):
        price = round(random.uniform(lo, hi) / 10) * 10 - 0.01
        products.append((pid, cat, round(price, 2), round(price * random.uniform(cost_ratio - 0.05, cost_ratio + 0.05), 2)))
        pid += 1
prod_by_cat = {}
for p in products:
    prod_by_cat.setdefault(p[1], []).append(p)

# ---------------- customers + orders ----------------
customers, orders, items, reviews = [], [], [], []
oid = 1
N_CUSTOMERS = 3200


def month_date():
    m = random.choices(list(SEASON), weights=list(SEASON.values()))[0]
    return date(YEAR, m, random.randint(1, 28))


def make_order(cust_id, city, d):
    """Create one order; return (delay_days, rating, status)."""
    global oid
    n_lines = random.choices([1, 2, 3, 4], weights=[55, 28, 12, 5])[0]
    cats = random.choices(list(CATEGORIES), weights=[12, 28, 24, 22, 14], k=n_lines)
    discount = 0.0
    if d.month == 11:
        discount = random.choice([0.15, 0.2, 0.25, 0.3])
    elif random.random() < 0.18:
        discount = random.choice([0.05, 0.1, 0.15])
    promised = 3 if "Furniture" not in cats else 7
    bump = max(CATEGORIES[c][4] for c in cats)
    extra = CITIES[city][1]
    peak = 1.2 if d.month in (11, 12) else 0.0
    delay = round(random.gauss(bump * 0.6 + extra + peak - 0.3, 1.4))
    delay = max(-2, min(delay, 12))
    status = "delivered"
    r = random.random()
    if r < 0.035:
        status = "cancelled"
    else:
        rb = max(CATEGORIES[c][3] for c in cats) + (0.04 if delay >= 3 else 0.0)
        if random.random() < rb:
            status = "returned"
    pay = wchoice(PAYMENTS)
    orders.append((oid, cust_id, d.isoformat(), promised, None if status == "cancelled" else promised + delay,
                   status, pay, discount))
    total = 0.0
    for c in cats:
        p = random.choice(prod_by_cat[c])
        q = random.choices([1, 2, 3], weights=[80, 15, 5])[0]
        items.append((oid, p[0], q, round(p[2] * (1 - discount), 2)))
        total += p[2] * q
    rating = None
    if status != "cancelled" and random.random() < 0.62:
        base = {True: [20, 22, 28, 18, 12], False: [3, 4, 12, 33, 48]}[delay >= 3]  # 1..5 star weights
        if status == "returned":
            base = [38, 25, 20, 10, 7]
        rating = random.choices([1, 2, 3, 4, 5], weights=base)[0]
        reviews.append((oid, rating))
    oid += 1
    return delay, status


for cid in range(1, N_CUSTOMERS + 1):
    city = wchoice(CITIES)
    channel = wchoice(CHANNELS)
    first = month_date()
    customers.append((cid, city, first.isoformat(), channel))
    delay, status = make_order(cid, city, first)
    # repeat purchase: strongly depends on the first delivery experience
    p_repeat = 0.34
    if status == "cancelled":
        p_repeat = 0.10
    elif delay >= 3:
        p_repeat = 0.14
    elif delay <= 0 and status == "delivered":
        p_repeat = 0.46
    if channel == "Email":
        p_repeat += 0.06
    last = first
    while random.random() < p_repeat and last < date(YEAR, 12, 15):
        last = last + timedelta(days=random.randint(20, 120))
        if last > date(YEAR, 12, 31):
            break
        delay, status = make_order(cid, city, last)
        p_repeat *= 0.6

# ---------------- web funnel (monthly) ----------------
funnel = []
ord_by_month = {}
for o in orders:
    ord_by_month[int(o[2][5:7])] = ord_by_month.get(int(o[2][5:7]), 0) + 1
for m in range(1, 13):
    placed = ord_by_month.get(m, 0)
    checkout = round(placed / random.uniform(0.40, 0.46))   # high checkout abandonment (~57%)
    cart = round(checkout / random.uniform(0.52, 0.58))
    views = round(cart / random.uniform(0.11, 0.14))
    sessions = round(views / random.uniform(0.38, 0.44))
    funnel.append((f"{YEAR}-{m:02d}", sessions, views, cart, checkout, placed))

# ---------------- write ----------------
schema = (ROOT / "sql" / "01_schema.sql").read_text(encoding="utf-8")
db_path = DATA / "anadolu_home.db"
if db_path.exists():
    db_path.unlink()
con = sqlite3.connect(db_path)
con.executescript(schema)
tables = {
    "customers": (["customer_id", "city", "first_order_date", "acquisition_channel"], customers),
    "products": (["product_id", "category", "list_price", "unit_cost"], products),
    "orders": (["order_id", "customer_id", "order_date", "promised_days", "delivered_days", "status",
                "payment_method", "discount_pct"], orders),
    "order_items": (["order_id", "product_id", "quantity", "unit_price"], items),
    "reviews": (["order_id", "rating"], reviews),
    "web_funnel": (["month", "sessions", "product_views", "add_to_cart", "checkout_started", "orders_placed"], funnel),
}
for name, (cols, rows) in tables.items():
    con.executemany(f"INSERT INTO {name} VALUES ({','.join('?' * len(cols))})", rows)
    with open(DATA / f"{name}.csv", "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(cols)
        w.writerows(rows)
    print(f"{name}: {len(rows)} rows")
con.commit()
con.close()
