CREATE TABLE default.metrics_v4_queue ON CLUSTER chcluster
(
    workspaceId String,
    metric String,
    fingerprint UInt64,
    description String,
    unit String,
    serviceName String,
    timestamp DateTime64(6),
    metric_type Enum8('gauge' = 1, 'sum' = 2, 'histogram' = 3, 'summary' = 4),
    is_monotonic UInt8,
    value Float64,
    count UInt64,
    sum Float64,
    buckets Nested (le Float64, count UInt64),
    attributes Map(String, String),
    exemplars Array(Tuple(
        spanId String,
        value Float64,
        traceId String,
        timestamp DateTime64(6),
    attributes Map(String, String)
    )),
    _ttl DateTime,
    )
    ENGINE = Kafka('kafka:29092', 'metrics_v4', 'clickhouse-metrics_v4', 'JSONEachRow')
    SETTINGS
    kafka_poll_timeout_ms = 500,
    kafka_num_consumers = 12,
    kafka_flush_interval_ms = 2000,
    kafka_max_block_size = 65536,
    kafka_thread_per_consumer = 1,
    kafka_poll_max_batch_size = 65536;


