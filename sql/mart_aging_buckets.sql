-- Aging buckets for currently open cases
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
