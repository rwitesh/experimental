CREATE TABLE IF NOT EXISTS default.metrics_v4 ON CLUSTER chcluster
(
    workspaceId LowCardinality(String) CODEC(ZSTD(1)),
    fingerprint UInt64 CODEC(ZSTD(1)),
    metric LowCardinality(String) CODEC(ZSTD(1)),
    serviceName LowCardinality(String) CODEC(ZSTD(1)),
    timestamp DateTime64(3) CODEC(Delta(8), ZSTD(1)),
    metric_type Enum8(
     'gauge' = 1,
     'sum' = 2,
     'histogram' = 3,
     'summary' = 4
     ) CODEC(ZSTD(1)),
    is_monotonic UInt8 CODEC(ZSTD(1)),
    value Float64 CODEC(Gorilla, ZSTD(1)),
    count UInt64 CODEC(T64, ZSTD(1)),
    sum Float64 CODEC(Gorilla, ZSTD(1)),
    buckets Nested (
       le Float64,
       count UInt64
    ) CODEC(ZSTD(1)),
    exemplars Array(Tuple(
        spanId String,
        value Float64,
        traceId String,
        timestamp DateTime64(6),
        attributes Map(LowCardinality(String), String)
    )) CODEC(ZSTD(1)),
    _ttl DateTime,
    INDEX idx_serviceName serviceName TYPE set(10000) GRANULARITY 1
)
ENGINE = ReplicatedMergeTree
PARTITION BY (toYYYYMM(timestamp))
ORDER BY  (workspaceId, metric, fingerprint, timestamp)
TTL timestamp + INTERVAL 3 HOUR
SETTINGS index_granularity = 8192;