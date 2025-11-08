create table if not exists logs_v3 ON CLUSTER chcluster (
    id String CODEC(ZSTD(1)),
    workspaceId String CODEC(ZSTD(1)),
    datasource LowCardinality(String) CODEC(ZSTD(1)),
    timestamp DateTime64(3) CODEC(Delta, ZSTD(1)),
    serviceName LowCardinality(String) CODEC(ZSTD(1)),
    severity LowCardinality(String) CODEC(ZSTD(1)),
    string_attrs Map(String, String) CODEC(ZSTD(1)),
    number_attrs Map(String, Float64) CODEC(ZSTD(1)),
    traceId String CODEC(ZSTD(1)),
    spanId String CODEC(ZSTD(1)),
    groupId String CODEC(ZSTD(1)),
    _ttl DateTime,
    INDEX idx_datasource datasource TYPE set(100) GRANULARITY 1,
    INDEX idx_trace_id traceId TYPE bloom_filter GRANULARITY 4,
    INDEX idx_serviceName serviceName TYPE set(10000) GRANULARITY 1,
    INDEX idx_groupId groupId TYPE bloom_filter GRANULARITY 4
)
ENGINE = ReplicatedMergeTree
ORDER BY (workspaceId, timestamp)
TTL _ttl
PARTITION BY toDate(timestamp)
SETTINGS index_granularity=8192, ttl_only_drop_parts = 1;