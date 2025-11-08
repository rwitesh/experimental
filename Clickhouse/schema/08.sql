-- 1h rollup table
CREATE TABLE IF NOT EXISTS default.metrics_v4_rollup_1h ON CLUSTER chcluster (
     workspaceId LowCardinality (String),
     fingerprint UInt64,
     metric LowCardinality (String),
     description String,
     unit LowCardinality (String),
     serviceName LowCardinality (String),
     timestamp DateTime64(3),
     metric_type Enum8 (
         'gauge' = 1, 'sum' = 2, 'histogram' = 3, 'summary' = 4
         ),
     is_monotonic UInt8,
     value SimpleAggregateFunction (anyLast, Float64),
     sum SimpleAggregateFunction (anyLast, Float64),
     count SimpleAggregateFunction (anyLast, UInt64),
     buckets Nested(
         le SimpleAggregateFunction (anyLast, Float64),
         count SimpleAggregateFunction (anyLast, UInt64)
     ),
     attributes Map (LowCardinality (String), String),
     exemplars SimpleAggregateFunction (anyLast, Array (
         Tuple (
             spanId String,
             value Float64,
             traceId String,
             timestamp DateTime64 (6),
             attributes Map (
                 String,
                 String
                 )
             )
         )) CODEC (ZSTD (1)),
     _ttl DateTime,
     INDEX idx_serviceName serviceName TYPE set(10000) GRANULARITY 1
) ENGINE = AggregatingMergeTree
  PARTITION BY (toYYYYMM (timestamp))
  ORDER BY (workspaceId, serviceName, metric, fingerprint, timestamp)
  TTL _ttl
  SETTINGS index_granularity = 8192;