--- Summary table to keep track of unique metric series
CREATE TABLE default.metric_series ON CLUSTER chcluster
(
    workspaceId String CODEC(ZSTD(1)),
    metric LowCardinality(String) CODEC(ZSTD(1)),
    metric_type Enum8(
        'gauge'     = 1,
        'sum'       = 2,
        'histogram' = 3,
        'summary'   = 4
    ) CODEC(ZSTD(1)),
    fingerprint UInt64 CODEC(ZSTD(1)),
    description String CODEC(ZSTD(1)),
    unit LowCardinality(String) CODEC(ZSTD(1)),
    attributes Map(LowCardinality(String), String),
    min_time SimpleAggregateFunction(min, DateTime) CODEC(Delta(4), ZSTD(1)),
    max_time SimpleAggregateFunction(max, DateTime) CODEC(Delta(4), ZSTD(1)),
    points_seen SimpleAggregateFunction(sum, UInt64),
    INDEX idx_max_time max_time TYPE minmax GRANULARITY 1
)
    ENGINE = AggregatingMergeTree
    PARTITION BY toYYYYMM(max_time)
    ORDER BY (workspaceId, metric, fingerprint);
