
-- 1h mv
CREATE MATERIALIZED VIEW IF NOT EXISTS default.mv_metrics_v4_rollup_1h
ON CLUSTER chcluster
TO default.metrics_v4_rollup_1h AS
SELECT
    workspaceId,
    fingerprint,
    metric,
    any(serviceName) AS serviceName,
    toStartOfHour(timestamp) AS timestamp,
    metric_type,
    any(is_monotonic) AS is_monotonic,
    anyLast(value) AS value,
    anyLast(sum) AS sum,
    anyLast(count) AS count,
    anyLast(buckets.le)    AS `buckets.le`,
    anyLast(buckets.count) AS `buckets.count`,
    anyLast(exemplars) AS exemplars,
    max(_ttl) AS _ttl
FROM default.metrics_v4_rollup_5m
GROUP BY
    workspaceId, fingerprint, metric, metric_type, timestamp;
