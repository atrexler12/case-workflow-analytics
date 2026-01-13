-- Backlog by day (open cases on each date)
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
