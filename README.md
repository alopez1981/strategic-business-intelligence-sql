# Strategic Data Analysis & SQL Portfolio 📊

> Transforming raw data into C-Level actionable insights.
> **Stack:** PostgreSQL, Advanced SQL (Window Functions, CTEs), Data Forensics.

## Overview

As an Engineering Manager, I don't just query databases; I interrogate them to answer critical business questions. This
repository contains a collection of **production-ready SQL patterns** I use to solve problems related to Revenue,
Retention, and Security.

## 📂 Case Studies (Modules)

### 1. Financial Health (Revenue Intelligence)

* **Goal:** Calculate real Metrics (MRR, Churn Rate) ignoring noise.
* **Technique:** Usage of `LAG()` and `LEAD()` window functions to calculate Month-over-Month (MoM) growth variance
  directly in SQL, reducing BI tool dependency.

### 2. Customer Lifetime Value (LTV)

* **Goal:** Identify "Whale" clients (Top 5% percentile) to optimize Marketing Spend (CAC).
* **Technique:** complex aggregations and `PERCENT_RANK()` to segment user base automatically.

### 3. Forensic SQL (Security)

* **Goal:** Detect "Account Sharing" and "Impossible Travel" scenarios to prevent revenue leakage.
* **Technique:** Self-joins on log tables to identify high-velocity anomalies (e.g., same user logging in from Spain and
  USA within 10 minutes).

---
*Note: The schemas provided here are generic representations of standard SaaS structures.*