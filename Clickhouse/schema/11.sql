CREATE MATERIALIZED VIEW default.mv_metric_series
ON CLUSTER chcluster
TO default.metric_series
AS
SELECT
    workspaceId,
    metric,
    metric_type,
    fingerprint,
    -- keep latest values for metadata
    argMax(description, timestamp) AS description,
    argMax(unit, timestamp) AS unit,
    argMax(attributes, timestamp) AS attributes,
    -- series lifetime stats
    min(timestamp) AS min_time,
    max(timestamp) AS max_time,
    count() AS points_seen
FROM default.metrics_v4_queue
GROUP BY workspaceId, metric, metric_type, fingerprint;
