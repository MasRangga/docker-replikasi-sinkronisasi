# Build Image untuk Primary Node

docker build -t postgres-primary -f Dockerfile-primary .

# Build Image untuk Secondary Node

docker build -t postgres-secondary -f Dockerfile-secondary .

# Primary Node

docker run -d --name primary-db -e POSTGRES_USER=rangga -e POSTGRES_PASSWORD=rangga123 -e POSTGRES_DB=ranggadb -p 5432:5432 -v primary-db-data:/var/lib/postgresql/data postgres-primary

# Secondary Node

docker run -d --name secondary-db --link primary-db:rangga-primary -e POSTGRES_USER=rangga -e POSTGRES_PASSWORD=rangga123 -e POSTGRES_DB=ranggadb -p 5433:5432 -v secondary-db-data:/var/lib/postgresql/data postgres-secondary

# Step Primary

docker exec -it primary-db psql -U rangga -d ranggadb

SELECT \* FROM pg_stat_replication;

# Membuat data dan Tabel Primary

CREATE TABLE rangga_data (
id SERIAL PRIMARY KEY,
data VARCHAR(50)
);

INSERT INTO rangga_data (data) VALUES ('Data pertama');
INSERT INTO rangga_data (data) VALUES ('Data kedua');

SELECT \* FROM rangga_data;

# Step Secondary

docker exec -it secondary-db psql -U rangga -d ranggadb

SELECT \* FROM rangga_data;

# Input di primary

docker exec -it primary-db psql -U rangga -d ranggadb
INSERT INTO rangga_data (data) VALUES ('Data Session Semantics');

# Restart Secondary Node

docker restart secondary-db
