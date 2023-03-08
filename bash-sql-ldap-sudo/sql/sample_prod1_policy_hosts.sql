set heading off

select distinct
  lower(HOSTNAME) as HOSTNAME
from {schema}.{inventory_table}
where
  HOSTNAME is not null
  and FULLY_QUALIFIED_HOSTNAME is not null
  and INSTANCE_TYPE is not null
  and upper(BUSINESS_AREA) = '{business_area}'  
  and upper(LOB)           = '{LOB - line of business}'
  and TIER_TYPE            = 'mt'                       -- 'mt' - mid-tier, 'db' - database
  and SERVICE_TYPE in                                   -- list of applicable 'service types'
    ('{service_type1}', '{service_type2}', '{service_type3}')
  and IS_PRODUCTION = TRUE
order by HOSTNAME;
