set PGPASSWORD=p@ssw0rd

psql -U postgres -d elmis_sdp -f 01_insert_prod_conv_rates.sql
psql -U postgres -d elmis_sdp -f 02_backup.sql
psql -U postgres -d elmis_sdp -f 03_convert.sql
psql -U postgres -d elmis_sdp -f 04_misc.sql


echo end
