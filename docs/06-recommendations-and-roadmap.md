# 06 — Recommendations & Roadmap

## Prioritisation (impact vs. effort)

| Priority | Recommendation | Impact | Effort | Why |
|---|---|---|---|---|
| 1 | **Fix delivery promise & monitoring** (BR-01, BR-02) | High | Medium | Late first order cuts repeat rate from 39.1% → 7.1% (Q4); the problem is concentrated in 6 cities (Q6) |
| 2 | **Proactive delay notification** (BR-03) | High | Low–Med | Reaction is the only lever when a delay has already happened; ratings collapse only at 3+ days (Q3) |
| 3 | **Promo margin floor** (BR-05) | Medium | Low | November lost ~15% net revenue vs. October despite +19% orders (Q1) |
| 4 | **Furniture returns programme** (BR-04) | Medium | Medium | Highest return rate (13.9%) on lowest-margin category (Q5) |
| 5 | **Follow-up email** (BR-07) | Medium | Low | Cheap; targets the on-time cohort |
| 6 | **Checkout A/B test** (BR-06) | Unknown | Medium | Abandonment is high but no data yet on *why* — test before building |

**Not recommended:** shifting budget between acquisition channels — repeat rates are within ~3 points of each other (Q7), so channel mix is not what is limiting retention.

## Roadmap
| Phase | Weeks | Deliverables |
|---|---|---|
| 1 — Visibility | 1–4 | Weekly late-delivery report (US-02); baseline KPI dashboard; carrier review for Van, Diyarbakır, Trabzon |
| 2 — Promise & recovery | 5–10 | City-specific estimates (US-01); proactive notifications (US-03) |
| 3 — Margin & returns | 8–14 | Promo margin floor (US-05); furniture checklist + reason codes (US-04) |
| 4 — Growth | 12–20 | Day +14 email (US-07); checkout A/B test (US-06) |

## Impact estimate (assumption-based)
*Customers whose first order was 3+ days late: 496 (15.5% of 3,200).*

- **Assumption:** the roadmap moves half of them (248) into the "1–2 days late" experience, where repeat rate is 24.1% instead of 7.1%.
- **Extra repeat customers:** 248 × (24.1% − 7.1%) ≈ **42**
- **Value:** 42 × average order value (~₺2,700) ≈ **₺114,000 per year** of additional revenue from this cohort alone — before the benefit on on-time customers, ratings and word-of-mouth.

> This is a deliberately conservative, single-lever estimate; real numbers would need Finance validation and a pilot.

## KPI dashboard (monthly)
Repeat rate · % late by city · avg rating (and % 1–2 stars) · return rate by category · AOV in promo months · checkout abandonment.

## Risks
| Risk | Mitigation |
|---|---|
| Honest estimates lower conversion | A/B test the new estimate on 20% of traffic first |
| Carriers resist stricter SLAs | Use report data in contract renewal; add secondary carrier in worst regions |
| Voucher cost spirals | Cap voucher per customer; Finance approves values |
| Notification without consent (KVKK) | Consent flag required in US-03 acceptance criteria |
| Synthetic-data insights don't transfer | Re-run `sql/02_analysis.sql` on real data — queries are schema-based and reusable |
