
-- 1m mv
CREATE MATERIALIZED VIEW IF NOT EXISTS default.mv_metrics_v4_rollup_1m
ON CLUSTER chcluster
TO default.metrics_v4_rollup_1m AS
SELECT
    workspaceId,
    fingerprint,
    metric,
    any(serviceName) AS serviceName,
    toStartOfMinute(timestamp) AS timestamp,
    metric_type,
    any(is_monotonic) AS is_monotonic,
    anyLast(value) AS value,
    anyLast(sum) AS sum,
    anyLast(count) AS count,
    anyLast(buckets.le)    AS `buckets.le`,
    anyLast(buckets.count) AS `buckets.count`,
    anyLast(exemplars) AS exemplars,
    LEAST(max(_ttl), timestamp + INTERVAL 15 DAY) AS _ttl
FROM default.metrics_v4
GROUP BY
    workspaceId, fingerprint, metric, metric_type, timestamp;
