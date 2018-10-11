set PGPASSWORD=p@ssw0rd

REM psql -U postgres -d elmis_sdp -f 01_insert_prod_conv_rates.sql
REM psql -U postgres -d elmis_sdp -f 02_backup.sql
REM psql -U postgres -d elmis_sdp -f 03_convert.sql
psql -U postgres -d elmis_sdp -f 04_misc.sql
psql -U postgres -d elmis_sdp -f 05_sync.sql


echo end
