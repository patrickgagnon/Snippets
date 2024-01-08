-- Detect and Terminate Queries
SELECT pid, now() - pg_stat_activity.query_start AS duration, query, state
FROM pg_stat_activity
WHERE (now() - pg_stat_activity.query_start) > interval '5 seconds'
AND state = 'active';

SELECT pg_terminate_backend(16860); --31910


-- Create Data Dictionary
SELECT
--        'prod'                                                                as env,
pg_namespace.nspname                                                  as schema_name,
pg_class.relname                                                      as table_name,
pg_attribute.attname                                                  AS column_name,
pg_catalog.format_type(pg_attribute.atttypid, pg_attribute.atttypmod) AS data_type

FROM pg_catalog.pg_attribute
         INNER JOIN
     pg_catalog.pg_class ON pg_class.oid = pg_attribute.attrelid
         INNER JOIN
     pg_catalog.pg_namespace ON pg_namespace.oid = pg_class.relnamespace
WHERE pg_attribute.attnum > 0
  AND NOT pg_attribute.attisdropped
--     AND pg_namespace.nspname = 'prod_public'
    /*
    AND pg_class.relname = 'my_table'
    */
  AND pg_namespace.nspname NOT ilike 'pg_%'
ORDER BY attnum ASC;

-- Views Data Dictionary
SELECT dependent_ns.nspname   as dependent_schema
     , dependent_view.relname as dependent_view
     , source_ns.nspname      as source_schema
     , source_table.relname   as source_table
     , pg_attribute.attname   as column_name
FROM pg_depend
         JOIN pg_rewrite ON pg_depend.objid = pg_rewrite.oid
         JOIN pg_class as dependent_view ON pg_rewrite.ev_class = dependent_view.oid
         JOIN pg_class as source_table ON pg_depend.refobjid = source_table.oid
         JOIN pg_attribute ON pg_depend.refobjid = pg_attribute.attrelid
    AND pg_depend.refobjsubid = pg_attribute.attnum
         JOIN pg_namespace dependent_ns ON dependent_ns.oid = dependent_view.relnamespace
         JOIN pg_namespace source_ns ON source_ns.oid = source_table.relnamespace
WHERE source_ns.nspname = 'Savant'
--AND source_table.relname = 'my_table'
  AND pg_attribute.attnum > 0
--AND pg_attribute.attname = 'my_column'
ORDER BY 1, 2;
