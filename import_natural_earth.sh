set -o errexit
set -o pipefail
set -o nounset

PROPERTY_FILE=/docker-entrypoint-initdb.d/db_properties.properties

function getProperty {
   PROP_KEY=$1
   PROP_VALUE=`cat $PROPERTY_FILE | grep "$PROP_KEY" | cut -d'=' -f2`
   echo $PROP_VALUE
}

readonly NE_HOST=$(getProperty "NE_HOST")
readonly NE_SCHEMA=$(getProperty "NE_SCHEMA")
readonly NE_DB=$(getProperty "NE_DB")
readonly NE_USER=$(getProperty "NE_USER")
readonly NE_PASSWORD=$(getProperty "NE_PASSWORD")

function create_natural_earth_db() {
	if [ "$NE_HOST" = "localhost" ]
	then
		echo "Creating database $NE_DB with owner $NE_USER"
		PGUSER="$POSTGRES_USER" psql --dbname="$POSTGRES_DB" <<-EOSQL
			CREATE USER $NE_USER WITH PASSWORD '$NE_PASSWORD';
			CREATE DATABASE $NE_DB WITH TEMPLATE template_postgis OWNER $NE_USER;
		EOSQL
	fi
}

function import_natural_earth() { 
    echo "Importing Natural Earth to PostGIS"
    PGCLIENTENCODING=LATIN1 ogr2ogr \
    -progress \
    -f Postgresql \
    -s_srs EPSG:4326 \
    -t_srs EPSG:3857 \
    -clipsrc -180.1 -85.0511 180.1 85.0511 \
    PG:"host=$NE_HOST dbname=$NE_DB active_schema=$NE_SCHEMA user=$NE_USER password=$NE_PASSWORD"\
    -lco GEOMETRY_NAME=geom \
    -lco DIM=2 \
    -nlt GEOMETRY \
    -overwrite \
    "$NATURAL_EARTH_DB"
}
create_natural_earth_db
import_natural_earth