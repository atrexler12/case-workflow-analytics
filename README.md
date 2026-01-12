# Case Workflow Analytics (SQL + Power BI)

## Goal
Measure workflow performance and identify drivers of delays using a case/ticket-style dataset.

## KPIs
- Backlog by day
- Cycle time (created → resolved)
- Aging buckets (0–2d, 3–7d, 8–14d, 15+d)
- Throughput (resolved per day/week)
- Breakdown by category / priority / channel

## Data Model
- fact_cases (one row per case)
- dim_category, dim_priority, dim_channel
- mart_kpis_daily (daily KPI mart for dashboards)

## Dashboard
- Executive summary (KPIs + trends)
- Drivers & drilldowns
- Aging & backlog view

## Status
In progress — v1 will include screenshots and a Power BI report.

## Notes
Dataset is public/simulated and used for learning/portfolio purposes.
