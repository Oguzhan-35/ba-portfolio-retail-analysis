# Anadolu Home — E-Commerce Delivery & Retention Analysis

**A Business Analyst portfolio case study** · SQL · SQLite · Python · BPMN-style process maps · BRD · User Stories

> 🇹🇷 Türkçe özet için: [README.tr.md](README.tr.md)

> **Disclosure:** *Anadolu Home* is a **fictional** online home-goods retailer and all data in this repo is **synthetically generated** (fixed random seed, see `scripts/generate_data.py`). This is a practice case study, not work done for a real company. Its purpose is to show how I approach a business problem end-to-end: frame it, analyse it with data, and turn findings into requirements.

---

## The business problem (in one paragraph)

Anadolu Home sells furniture, kitchenware, textiles, decor and lighting online across Türkiye. Revenue grew through 2025, but management sees three worrying signals: only **~27% of customers ever buy a second time**, **57% of customers who start checkout abandon it**, and **Black Friday revenue came in below October's** despite 19% more orders. The COO wants to know *where the money is leaking and what to fix first*.

## Headline findings

| # | Finding | Evidence (see [results](docs/05-analysis-results.md)) |
|---|---|---|
| 1 | **Late delivery is the strongest driver of churn.** Customers whose first order arrives 3+ days late repeat-buy at **7.1%** vs **39.1%** for on-time first orders. | Q4 |
| 2 | The damage has a **threshold**: 1–2 days late barely moves ratings (4.07 vs 4.09), but 3+ days late drops it to **2.71** and 44.6% give 1–2 stars. | Q3 |
| 3 | Delays are **geographic**: Van, Diyarbakır, Trabzon have 83–95% late deliveries; Istanbul averages well under one day late. | Q6 |
| 4 | **Furniture** has the highest return rate (13.9%) *and* the lowest margin (37.5%) — it is the least profitable category once returns are counted. | Q5 |
| 5 | **Black Friday discounts cannibalised revenue**: orders +19% vs Oct, but AOV fell from ₺2,663 to ₺2,053 and net revenue fell ~15%. | Q1 |
| 6 | **Acquisition channel is not the lever** — repeat rate is ~25–28% in every channel. Spend on retention/logistics, not on channel mix. | Q7 |

## What's in this repo

```
docs/
  01-business-case-and-requirements.md   Problem statement, objectives, scope, BRD-style requirements
  02-stakeholders-and-raci.md            Stakeholder map, interests, RACI
  03-process-as-is-to-be.md              AS-IS vs TO-BE order-to-delivery process (Mermaid diagrams)
  04-user-stories.md                     User stories with acceptance criteria (Given/When/Then)
  05-analysis-results.md                 All SQL queries + results (auto-generated)
  06-recommendations-and-roadmap.md      Prioritised recommendations, KPI targets, impact estimate, risks
sql/
  01_schema.sql                          Database schema
  02_analysis.sql                        8 KPI queries (CTEs, window-free joins, conditional aggregation)
scripts/
  generate_data.py                       Builds the synthetic SQLite DB + CSVs
  run_analysis.py                        Runs the queries and writes docs/05-analysis-results.md
data/                                    anadolu_home.db + CSV per table
```

## Reproduce it

Requires only Python 3 (standard library — no packages).

```bash
python scripts/generate_data.py   # creates data/anadolu_home.db and CSVs
python scripts/run_analysis.py    # regenerates docs/05-analysis-results.md
```

## Skills demonstrated

- **Requirements elicitation & documentation** — business case, scope, BRD-style requirements, user stories with acceptance criteria
- **Stakeholder analysis** — interest/influence mapping, RACI
- **Process modelling** — AS-IS / TO-BE flows, pain-point identification
- **Data analysis in SQL** — funnel analysis, cohort-style repeat rate, conditional aggregation, RFM segmentation
- **Prioritisation & communication** — impact/effort matrix, KPI targets, assumption-driven impact estimate

## Limitations

Synthetic data encodes the relationships I chose to simulate, so the *findings* illustrate the analysis method rather than real-world truth. The impact estimate in the roadmap is explicitly assumption-based.

---
**Oğuzhan Kul** · MIS graduate · Business Analyst candidate · İzmir, Türkiye · [GitHub](https://github.com/Oguzhan-35)
