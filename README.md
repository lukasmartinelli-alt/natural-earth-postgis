## Natural Earth PostGIS database

A [PostGIS](http://postgis.net/) Docker container populated with Natural Earth data.
You can use this to quickly spin up a PostGIS database
containing the full [Natural Earth data set](www.naturalearthdata.com) to get
started with analysis.

## Requirements

Make sure you have [installed Docker for your platform](https://docs.docker.com/engine/installation/).

- [Install on OSX](https://docs.docker.com/engine/installation/mac/#/docker-for-mac)
- [Install on Windows](https://docs.docker.com/engine/installation/windows/)

## Usage

Now you need to start the prepared Docker container and wait until it is ready.

```bash
docker run -p 5432:5432 lukasmartinelli/natural-earth-postgis
```

You can also use the [Kitematic GUI](https://kitematic.com/) and search for `natural earth postgis` to spin up the container.

## Connect

You can now use `psql` or any other PostgreSQL client to connect to the PostGIS database.

```bash
psql
```

## Postgis Editor

To get started analyzing the data I recommend to use [**postgis-studio**](https://github.com/lukasmartinelli/postgis-editor).


