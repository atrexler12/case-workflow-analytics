CREATE TABLE IF NOT EXISTS fact_cases (
  case_id        BIGINT PRIMARY KEY,
  created_at     DATETIME NOT NULL,
  resolved_at    DATETIME NULL,
  category       VARCHAR(100),
  priority       VARCHAR(50),
  channel        VARCHAR(50)
);
