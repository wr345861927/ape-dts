test_db_1
CREATE DATABASE `test_db_1`

test_db_1.full_column_type
CREATE TABLE test_db_1.full_column_type
(
    `id` Int32,
    `char_col` Nullable(String),
    `char_col_2` Nullable(String),
    `character_col` Nullable(String),
    `character_col_2` Nullable(String),
    `varchar_col` Nullable(String),
    `varchar_col_2` Nullable(String),
    `character_varying_col` Nullable(String),
    `character_varying_col_2` Nullable(String),
    `bpchar_col` Nullable(String),
    `bpchar_col_2` Nullable(String),
    `text_col` Nullable(String),
    `real_col` Nullable(Float32),
    `float4_col` Nullable(Float32),
    `double_precision_col` Nullable(Float64),
    `float8_col` Nullable(Float64),
    `numeric_col` Nullable(Decimal(38, 9)),
    `numeric_col_2` Nullable(Decimal(38, 9)),
    `decimal_col` Nullable(Decimal(38, 9)),
    `decimal_col_2` Nullable(Decimal(38, 9)),
    `smallint_col` Nullable(Int16),
    `int2_col` Nullable(Int16),
    `smallserial_col` Int16,
    `serial2_col` Int16,
    `integer_col` Nullable(Int32),
    `int_col` Nullable(Int32),
    `int4_col` Nullable(Int32),
    `serial_col` Int32,
    `serial4_col` Int32,
    `bigint_col` Nullable(Int64),
    `int8_col` Nullable(Int64),
    `bigserial_col` Int64,
    `serial8_col` Int64,
    `bit_col` Nullable(String),
    `bit_col_2` Nullable(String),
    `bit_varying_col` Nullable(String),
    `bit_varying_col_2` Nullable(String),
    `varbit_col` Nullable(String),
    `varbit_col_2` Nullable(String),
    `time_col` Nullable(String),
    `time_col_2` Nullable(String),
    `time_col_3` Nullable(String),
    `time_col_4` Nullable(String),
    `timez_col` Nullable(String),
    `timez_col_2` Nullable(String),
    `timez_col_3` Nullable(String),
    `timez_col_4` Nullable(String),
    `timestamp_col` Nullable(DateTime64(6)),
    `timestamp_col_2` Nullable(DateTime64(6)),
    `timestamp_col_3` Nullable(DateTime64(6)),
    `timestamp_col_4` Nullable(DateTime64(6)),
    `timestampz_col` Nullable(DateTime64(6)),
    `timestampz_col_2` Nullable(DateTime64(6)),
    `timestampz_col_3` Nullable(DateTime64(6)),
    `timestampz_col_4` Nullable(DateTime64(6)),
    `date_col` Nullable(Date32),
    `bytea_col` Nullable(String),
    `boolean_col` Nullable(Bool),
    `bool_col` Nullable(Bool),
    `json_col` Nullable(String),
    `jsonb_col` Nullable(String),
    `interval_col` Nullable(String),
    `interval_col_2` Nullable(String),
    `array_float4_col` Nullable(String),
    `array_float8_col` Nullable(String),
    `array_int2_col` Nullable(String),
    `array_int4_col` Nullable(String),
    `array_int8_col` Nullable(String),
    `array_int8_col_2` Nullable(String),
    `array_text_col` Nullable(String),
    `array_boolean_col` Nullable(String),
    `array_boolean_col_2` Nullable(String),
    `array_date_col` Nullable(String),
    `array_timestamp_col` Nullable(String),
    `array_timestamp_col_2` Nullable(String),
    `array_timestamptz_col` Nullable(String),
    `array_timestamptz_col_2` Nullable(String),
    `box_col` Nullable(String),
    `cidr_col` Nullable(String),
    `circle_col` Nullable(String),
    `inet_col` Nullable(String),
    `line_col` Nullable(String),
    `lseg_col` Nullable(String),
    `macaddr_col` Nullable(String),
    `macaddr8_col` Nullable(String),
    `money_col` Nullable(String),
    `path_col` Nullable(String),
    `pg_lsn_col` Nullable(String),
    `pg_snapshot_col` Nullable(String),
    `polygon_col` Nullable(String),
    `point_col` Nullable(String),
    `tsquery_col` Nullable(String),
    `tsvector_col` Nullable(String),
    `txid_snapshot_col` Nullable(String),
    `uuid_col` Nullable(UUID),
    `xml_col` Nullable(String),
    `_ape_dts_is_deleted` Int8,
    `_ape_dts_timestamp` Int64
)
ENGINE = ReplacingMergeTree(_ape_dts_timestamp)
PRIMARY KEY id
ORDER BY id
SETTINGS index_granularity = 8192

test_db_1.check_pk_cols_order
CREATE TABLE test_db_1.check_pk_cols_order
(
    `col_1` Nullable(Int32),
    `col_2` Nullable(Int32),
    `col_3` Nullable(Int32),
    `pk_3` Int32,
    `pk_1` Int32,
    `col_4` Nullable(Int32),
    `pk_2` Int32,
    `col_5` Nullable(Int32),
    `_ape_dts_is_deleted` Int8,
    `_ape_dts_timestamp` Int64
)
ENGINE = ReplacingMergeTree(_ape_dts_timestamp)
PRIMARY KEY (pk_1, pk_2, pk_3)
ORDER BY (pk_1, pk_2, pk_3)
SETTINGS index_granularity = 8192

dst_test_db_2.router_test_1
CREATE TABLE dst_test_db_2.router_test_1
(
    `pk` Int32,
    `col_1` Nullable(Int32),
    `_ape_dts_is_deleted` Int8,
    `_ape_dts_timestamp` Int64
)
ENGINE = ReplacingMergeTree(_ape_dts_timestamp)
PRIMARY KEY pk
ORDER BY pk
SETTINGS index_granularity = 8192

dst_test_db_2.dst_router_test_2
CREATE TABLE dst_test_db_2.dst_router_test_2
(
    `pk` Int32,
    `col_1` Nullable(Int32),
    `_ape_dts_is_deleted` Int8,
    `_ape_dts_timestamp` Int64
)
ENGINE = ReplacingMergeTree(_ape_dts_timestamp)
PRIMARY KEY pk
ORDER BY pk
SETTINGS index_granularity = 8192