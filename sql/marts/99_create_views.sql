USE case_workflow;

CREATE OR REPLACE VIEW mart_backlog_daily AS
WITH RECURSIVE date_bounds AS (
  SELECT
    DATE(MIN(created_at)) AS start_date,
    DATE(MAX(COALESCE(resolved_at, created_at))) AS end_date
  FROM fact_cases
),
calendar AS (
  SELECT start_date AS d, end_date
  FROM date_bounds
  UNION ALL
  SELECT DATE_ADD(d, INTERVAL 1 DAY), end_date
  FROM calendar
  WHERE d < end_date
)
SELECT
  c.d AS snapshot_date,
  COUNT(*) AS open_cases
FROM calendar c
JOIN fact_cases f
  ON DATE(f.created_at) <= c.d
 AND (f.resolved_at IS NULL OR DATE(f.resolved_at) > c.d)
GROUP BY c.d
ORDER BY c.d;

CREATE OR REPLACE VIEW mart_cycle_time AS
SELECT
  case_id,
  created_at,
  resolved_at,
  ROUND(TIMESTAMPDIFF(MINUTE, created_at, resolved_at) / 60, 2) AS cycle_time_hours,
  category,
  priority,
  channel
FROM fact_cases
WHERE resolved_at IS NOT NULL;

CREATE OR REPLACE VIEW mart_aging_buckets AS
WITH open_cases AS (
  SELECT
    case_id,
    created_at,
    category,
    priority,
    channel,
    DATEDIFF(CURDATE(), DATE(created_at)) AS age_days
  FROM fact_cases
  WHERE resolved_at IS NULL
)
SELECT
  CASE
    WHEN age_days <= 2 THEN '0–2 days'
    WHEN age_days <= 7 THEN '3–7 days'
    WHEN age_days <= 14 THEN '8–14 days'
    ELSE '15+ days'
  END AS aging_bucket,
  COUNT(*) AS open_cases
FROM open_cases
GROUP BY 1
ORDER BY
  CASE aging_bucket
    WHEN '0–2 days' THEN 1
    WHEN '3–7 days' THEN 2
    WHEN '8–14 days' THEN 3
    ELSE 4
  END;
