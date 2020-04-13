-- Sample query to identify unsupported datatypes by DMS for PostgreSQL to PostgreSQL Migration
-- Refer to https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html#CHAP_Source.PostgreSQL.Homogeneous for more details
select table_schema,table_name,column_name,data_type 
from information_schema.columns where 
data_type in ('enum', 'cidr', 'inet', 'macaddr', 'tsvector', 'tsquery',
 'point,','line', 'polygon', 'circle', 'array', 'int4range', 'int8range',
  'int8range', 'tsrange', 'tstzrange','daterange','timestamp with time zone')
  and table_schema not in ('pg_catalog', 'information_schema');

