-- Cycle time per resolved case (hours)
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
