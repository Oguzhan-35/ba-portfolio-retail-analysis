# 04 — User Stories & Acceptance Criteria

Format: *As a … I want … so that …* + Given/When/Then. Story points are relative estimates (Fibonacci).

## US-01 — Realistic delivery estimate (BR-01) · Must · 8 pts
**As a** shopper in Van, **I want** to see a delivery estimate that matches what actually happens in my city, **so that** I can trust the promise and plan to be home.

- **Given** a customer enters a delivery city at checkout, **when** the page calculates the estimate, **then** it shows a date range based on the 80th percentile of actual delivery time for that city over the last 90 days.
- **Given** fewer than 30 historical orders exist for the city, **when** the estimate is calculated, **then** the regional average is used instead.
- **Given** the estimate is shown, **when** the order is placed, **then** the shown estimate is stored on the order as `promised_days`.

## US-02 — Weekly late-delivery report (BR-02) · Must · 3 pts
**As a** Logistics Manager, **I want** a weekly report of % late and average delay per carrier and city, **so that** I can raise SLA issues with data.

- **Given** the report runs every Monday, **then** it lists the 10 worst city/carrier combinations with order count, % late and average delay.
- **Given** a combination exceeds 40% late deliveries, **then** it is flagged red.
- **Given** the SQL behind it, **then** it is reproducible without manual spreadsheet edits.

## US-03 — Proactive delay notification (BR-03) · Must · 5 pts
**As a** customer whose parcel is going to be late, **I want** to be told before the promised date, **so that** I do not feel ignored.

- **Given** an order is not "out for delivery" one day before `promised_days`, **when** the nightly job runs, **then** the customer gets an SMS/email with the new estimate.
- **Given** the delay will be 3+ days, **then** the message includes a voucher (value set by Finance).
- **Given** the customer has not given contact consent, **then** no message is sent (KVKK).

## US-04 — Furniture damage prevention & return reason codes (BR-04) · Should · 5 pts
**As a** Customer Service agent, **I want** every furniture return to carry a reason code, **so that** we can see whether damage, sizing or expectation is the cause.

- **Given** a return is opened, **then** the reason is a mandatory dropdown (damaged in transit / wrong size / not as described / changed mind / other).
- **Given** the warehouse packs furniture, **then** a 5-point damage checklist must be ticked before the label prints.

## US-05 — Promotion margin floor (BR-05) · Should · 3 pts
**As a** Finance Controller, **I want** promotions to enforce a margin floor, **so that** Black Friday does not reduce net revenue.

- **Given** a campaign is configured, **when** the discount would push a product's gross margin below the category floor, **then** the system blocks it or requires Finance approval.
- **Given** the campaign ends, **then** a report compares AOV and net revenue to the previous month.

## US-06 — Checkout A/B test (BR-06) · Could · 5 pts
**As a** Head of E-Commerce, **I want** to test guest checkout and upfront shipping costs, **so that** I can reduce the 57% abandonment with evidence.

- **Given** a visitor reaches checkout, **then** they are randomly assigned to variant A or B (50/50) and the assignment is persisted.
- **Given** the test has ≥ 2,000 checkouts per variant, **then** the result report shows conversion and a confidence interval.

## US-07 — Day +14 follow-up email (BR-07) · Could · 2 pts
**As a** Marketing Manager, **I want** an automatic email two weeks after an on-time delivery, **so that** happy customers are nudged to buy again.

- **Given** an order was delivered on or before `promised_days` and no return was opened, **when** 14 days have passed, **then** the customer receives the email once.
- **Given** the customer unsubscribed, **then** no email is sent.
