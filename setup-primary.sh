#!/bin/bash

# Aktifkan wal_level untuk replikasi
echo "wal_level = replica" >> $PGDATA/postgresql.conf
echo "max_wal_senders = 10" >> $PGDATA/postgresql.conf
echo "wal_keep_size = 64" >> $PGDATA/postgresql.conf

# Izinkan akses replikasi dari secondary
echo "host replication rangga 0.0.0.0/0 md5" >> $PGDATA/pg_hba.conf
