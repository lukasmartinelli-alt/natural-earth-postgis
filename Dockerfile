FROM mdillon/postgis:9.5
ENV IMPORT_DATA_DIR=/import \
    NATURAL_EARTH_DB=/import/natural_earth_vector.sqlite

RUN apt-get update && apt-get install -y --no-install-recommends \
      wget \
      unzip \
      gdal-bin \
      sqlite3 \
 && rm -rf /var/lib/apt/lists/*

RUN wget --quiet http://naciscdn.org/naturalearth/packages/natural_earth_vector.sqlite.zip \
    && unzip -oj natural_earth_vector.sqlite.zip -d "$IMPORT_DATA_DIR" \
    && rm natural_earth_vector.sqlite.zip

RUN mv /docker-entrypoint-initdb.d/postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh
COPY import_natural_earth.sh /docker-entrypoint-initdb.d/20_import_natural_earth.sh
COPY db_properties.properties /docker-entrypoint-initdb.d/db_properties.properties