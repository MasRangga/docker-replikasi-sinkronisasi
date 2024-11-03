#!/bin/bash

# Tunggu sampai primary siap
sleep 10

# Hapus direktori data di secondary (akan digantikan oleh data primary)
rm -rf $PGDATA/*

# Sinkronkan dengan primary
pg_basebackup -h rangga-primary -D $PGDATA -U rangga -Fp -Xs -P -R

# Konfigurasi tambahan pada secondary
echo "primary_conninfo = 'host=rangga-primary port=5432 user=rangga password=rangga123'" >> $PGDATA/postgresql.conf
