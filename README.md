
# PostgreSQL Replication Setup

## 1. Build Images

### Build Image untuk Primary Node
```bash
docker build -t postgres-primary -f Dockerfile-primary .
```

### Build Image untuk Secondary Node
```bash
docker build -t postgres-secondary -f Dockerfile-secondary .
```

## 2. Run Containers

### Primary Node
Jalankan Primary Node dengan perintah berikut:
```bash
docker run -d --name primary-db \
  -e POSTGRES_USER=rangga \
  -e POSTGRES_PASSWORD=rangga123 \
  -e POSTGRES_DB=ranggadb \
  -p 5432:5432 \
  -v primary-db-data:/var/lib/postgresql/data \
  postgres-primary
```

### Secondary Node
Jalankan Secondary Node dengan menghubungkannya ke Primary Node:
```bash
docker run -d --name secondary-db \
  --link primary-db:rangga-primary \
  -e POSTGRES_USER=rangga \
  -e POSTGRES_PASSWORD=rangga123 \
  -e POSTGRES_DB=ranggadb \
  -p 5433:5432 \
  -v secondary-db-data:/var/lib/postgresql/data \
  postgres-secondary
```

## 3. Langkah-langkah Setup

### Langkah-langkah di Primary Node
1. Masuk ke Primary Node:
   ```bash
   docker exec -it primary-db psql -U rangga -d ranggadb
   ```
2. Periksa status replikasi:
   ```sql
   SELECT * FROM pg_stat_replication;
   ```

### Membuat Tabel dan Data di Primary Node
1. Buat tabel `rangga_data`:
   ```sql
   CREATE TABLE rangga_data (
     id SERIAL PRIMARY KEY,
     data VARCHAR(50)
   );
   ```
2. Masukkan data ke tabel `rangga_data`:
   ```sql
   INSERT INTO rangga_data (data) VALUES ('Data pertama');
   INSERT INTO rangga_data (data) VALUES ('Data kedua');
   ```
3. Verifikasi data:
   ```sql
   SELECT * FROM rangga_data;
   ```

### Langkah-langkah di Secondary Node
1. Masuk ke Secondary Node:
   ```bash
   docker exec -it secondary-db psql -U rangga -d ranggadb
   ```
2. Verifikasi data yang ada di `rangga_data`:
   ```sql
   SELECT * FROM rangga_data;
   ```

## 4. Menambahkan Data di Primary dan Sinkronisasi ke Secondary

1. Tambahkan data baru di Primary Node:
   ```bash
   docker exec -it primary-db psql -U rangga -d ranggadb -c "INSERT INTO rangga_data (data) VALUES ('Data Session Semantics');"
   ```

2. Untuk memastikan data tersinkronisasi, Anda dapat merestart Secondary Node:
   ```bash
   docker restart secondary-db
   ```

## Catatan
Pastikan konfigurasi replikasi diatur dengan benar pada kedua node untuk mendukung sinkronisasi data antar node PostgreSQL.
