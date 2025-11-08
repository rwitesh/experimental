CREATE MATERIALIZED VIEW IF NOT EXISTS logs_mv_v3 ON CLUSTER chcluster TO logs_v3 AS
SELECT * FROM logs_v3_queue where _topic = 'logs_v2';