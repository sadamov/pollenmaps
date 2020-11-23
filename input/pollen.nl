
&RunSpecification
strict_nl_parsing  = .true.
verbosity          = "moderate"
diagnostic_length  = 110
/

&GlobalResource
dictionary           = "/oprusers/owm/opr/resources/dictionary_cosmo.txt"
grib_definition_path = "/oprusers/owm/opr/resources/eccodes_definitions_cosmo",
"/oprusers/owm/opr/resources/eccodes_definitions_vendor"
location_list        = "/store/mch/msopr/sadamov/fieldextra/pollen/mylocation_list.txt"
/

&GlobalSettings
default_dictionary    = "cosmo",
default_model_name    = "cosmo-1"
location_to_gridpoint = "sn" 
/

&ModelSpecification
model_name         = "cosmo-1"
earth_axis_large   = 6371229.
earth_axis_small   = 6371229.
/

&Process
in_file  = "/store/s83/owm/COSMO-1/ANA20/laf2020070100"
out_type = "INCORE"
/
&Process in_field  = "FR_LAND" /
&Process in_field  = "HSURF  ", tag='HSURF' /


&Process
in_file  = "/store/s83/owm/COSMO-1/ANA20/laf<yyyymmddhh:2020070100>",
out_file = "mod_pollen.csv", 
tstart=0,
tstop=1,
tincr=1,
out_type = "XLS_TABLE",
out_type_separator='    ',
locgroup = "chall",           
/            

&Process in_field  = "POAC", levlist=80 /

