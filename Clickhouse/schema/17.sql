CREATE TABLE IF NOT EXISTS logs_v3_queue ON CLUSTER chcluster (
    workspaceId String,
    datasource String,
    serviceName String,
    string_attrs Map(String, String),
    number_attrs Map(String, Float64),
    timestamp DateTime64(3),
    traceId String,
    id String,
    spanId String,
    severity String,
    groupId String,
    _ttl DateTime
    ) ENGINE = Kafka('kafka:29092','logs_v2','clickhouse-logs_v2','JSONEachRow')
    SETTINGS
    kafka_poll_timeout_ms = 500,
    kafka_num_consumers = 12,
    kafka_flush_interval_ms = 2000,
    kafka_max_block_size = 65536,
    kafka_thread_per_consumer = 1,
    kafka_poll_max_batch_size = 65536;
