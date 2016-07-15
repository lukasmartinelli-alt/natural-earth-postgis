#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly NE_DB=${NE_DB:-naturalearth}
readonly NE_USER=${NE_USER:-naturalearth}
readonly NE_PASSWORD=${NE_PASSWORD:-naturalearth}

function create_natural_earth_db() {
    echo "Creating database $NE_DB with owner $NE_USER"
    PGUSER="$POSTGRES_USER" psql --dbname="$POSTGRES_DB" <<-EOSQL
		CREATE USER $NE_USER WITH PASSWORD '$NE_PASSWORD';
		CREATE DATABASE $NE_DB WITH TEMPLATE template_postgis OWNER $NE_USER;
	EOSQL
}

function import_natural_earth() {
    echo "Importing Natural Earth to PostGIS"
    PGCLIENTENCODING=LATIN1 ogr2ogr \
    -progress \
    -f Postgresql \
    -s_srs EPSG:4326 \
    -t_srs EPSG:3857 \
    -clipsrc -180.1 -85.0511 180.1 85.0511 \
    PG:"dbname=$NE_DB user=$NE_USER host=$DB_HOST port=$DB_PORT" password="$NE_PASSWORD"\
    -lco GEOMETRY_NAME=geom \
    -lco DIM=2 \
    -nlt GEOMETRY \
    -overwrite \
    "$NATURAL_EARTH_DB"
}

create_natural_earth_db
import_natural_earth
