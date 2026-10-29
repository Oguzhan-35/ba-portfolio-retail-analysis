# 01 — Business Case & Requirements

## 1. Background
Anadolu Home (fictional) is a Türkiye-wide online retailer in five categories: Furniture, Kitchen, Textile, Decor, Lighting. In 2025 it handled ~4,300 orders from ~3,200 customers. Delivery is outsourced to regional carriers; the promised delivery time (SLA) is shown at checkout (3 days standard, 7 days for furniture).

## 2. Problem statement
Growth is being bought, not retained. Management sees (a) a low repeat-purchase rate, (b) a high checkout abandonment rate, and (c) a disappointing Black Friday. Nobody currently knows which of these is the root problem and which are symptoms.

## 3. Business objectives (SMART)
| ID | Objective | Baseline (2025) | Target (12 months) |
|---|---|---|---|
| O1 | Increase repeat-purchase rate | 27% of customers | 35% |
| O2 | Reduce share of orders delivered 3+ days late | see Q3/Q6 | halve it, starting with the 6 worst cities |
| O3 | Reduce furniture return rate | 13.9% | ≤ 9% |
| O4 | Protect margin on promotions | Nov AOV ₺2,053 (−23% vs Oct) | Promo AOV ≥ ₺2,500 |
| O5 | Reduce checkout abandonment | 57.4% | ≤ 50% |

## 4. Scope
**In scope:** order-to-delivery process, delivery SLA communication, returns handling for furniture, promotion design, checkout flow analysis.
**Out of scope:** product sourcing, pricing strategy outside promotions, ERP replacement, mobile app.

## 5. Assumptions & constraints
- Carrier contracts can be renegotiated at renewal; mid-term changes are limited.
- No budget for building own fleet. 
- Data used is the 2025 order history; no marketing-spend data is available (so channel ROI is out of scope).

## 6. Business requirements
| ID | Requirement | Objective | Priority (MoSCoW) |
|---|---|---|---|
| BR-01 | The system shall show a **region-specific realistic delivery estimate** at checkout, based on historical carrier performance per city. | O1, O2 | Must |
| BR-02 | The business shall be able to **monitor late deliveries per carrier and city** in a weekly report. | O2 | Must |
| BR-03 | Customers whose order is at risk of being 3+ days late shall be **proactively notified** with an apology/compensation option. | O1 | Must |
| BR-04 | Furniture orders shall go through a **pre-shipment packaging/damage checklist**, and returns shall capture a structured reason code. | O3 | Should |
| BR-05 | Promotions shall have a **minimum-basket rule or margin floor** so discount depth cannot erode AOV unchecked. | O4 | Should |
| BR-06 | The business shall run an **A/B test** on checkout (guest checkout, delivery-cost transparency) before full rollout. | O5 | Could |
| BR-07 | A **post-purchase email** shall be triggered 14 days after on-time deliveries to drive the second purchase. | O1 | Could |

## 7. Non-functional requirements
- Delivery estimates must load in < 1 s at checkout.
- Customer notification data must comply with KVKK (Turkish data-protection law) — contact consent is required.
- Weekly report must be reproducible from SQL (no manual spreadsheet steps).

## 8. Success measures
Tracked monthly on a single dashboard: repeat rate, % late by city, avg rating, return rate by category, AOV in promo months, checkout abandonment.
