CREATE MATERIALIZED VIEW  IF NOT EXISTS default.mv_metrics_v4 ON CLUSTER chcluster
TO default.metrics_v4
AS
SELECT
    workspaceId,
    fingerprint,
    metric,
    serviceName,
    timestamp,
    metric_type,
    is_monotonic,
    value,
    count,
    sum,
    arrayMap(s -> CAST(s AS Float64), buckets.le) AS `buckets.le`,
    buckets.count,
    exemplars,
    _ttl
FROM default.metrics_v4_queue;
