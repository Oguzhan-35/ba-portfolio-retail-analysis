# 02 — Stakeholders & RACI

## Stakeholder map
| Stakeholder | Interest | Influence | Engagement approach |
|---|---|---|---|
| COO (sponsor) | Cost, delivery performance, customer retention | High | Weekly steering update; owns prioritisation |
| Head of E-Commerce | Conversion, checkout UX, promo calendar | High | Co-owns BR-01, BR-05, BR-06 |
| Logistics Manager | Carrier SLAs, cost per parcel | High | Key partner for BR-01..BR-03; likely resistance if cost rises |
| Marketing Manager | Campaign performance, email automation | Medium | Owns BR-07; needs to accept lower discount depth |
| Customer Service Lead | Complaint volume, return handling | Medium | Source of pain points; owns notification response |
| Finance Controller | Margin, promo profitability | Medium | Validates impact estimate and margin floor |
| IT / Platform Developer | Feasibility, effort | Medium | Estimates BR-01, BR-06; needs clear acceptance criteria |
| Carriers (external) | Contract volume | Low–Medium | Managed by Logistics through SLA reviews |
| Customers (external) | Reliable delivery, easy returns | — | Voice captured via reviews (Q3) and repeat behaviour (Q4) |

## RACI (R = Responsible, A = Accountable, C = Consulted, I = Informed)
| Deliverable | BA | COO | Head of E-Com | Logistics | Marketing | Cust. Service | Finance | IT |
|---|---|---|---|---|---|---|---|---|
| Requirements sign-off | R | A | C | C | C | C | C | I |
| City-level delivery estimate (BR-01) | C | I | A | C | I | I | I | R |
| Weekly late-delivery report (BR-02) | R | I | I | A | I | C | I | C |
| Proactive delay notification (BR-03) | C | I | C | R | I | A | I | R |
| Furniture damage checklist (BR-04) | C | I | I | A | I | C | I | I |
| Promo margin floor (BR-05) | C | I | R | I | C | I | A | C |
| Checkout A/B test (BR-06) | R | I | A | I | C | I | I | R |
| Post-purchase email (BR-07) | C | I | C | I | A | I | I | R |

## Key conflicts to manage
1. **Logistics vs. Head of E-Commerce:** honest (longer) delivery estimates may lower conversion; the BA must bring Q3/Q4 evidence that *broken promises cost more than long promises*.
2. **Marketing vs. Finance:** deep promos drive orders but erode AOV (Q1, November).
