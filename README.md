# MariaDB 10.2 (MySQL 5.7) Docker image on Debian

[Docker Hub](https://hub.docker.com/r/williamdes/docker-mariadb-debian/)

# Specs
- Compiled from source, [MariaDB](https://mariadb.com/products/technology/server) for armhf
- Version [10.2.9](https://mariadb.com/kb/en/library/mariadb-1029-release-notes/)

## Docker image usage

```
docker run [docker-options] williamdes/docker-mariadb-debian:10.2.9-armhf
```

Advanced run
```
mkdir /mariadb-data
docker run -d -p 3306:3306 -e TZ=Europe/Paris -v /mariadb-data:/var/lib/mysql williamdes/docker-mariadb-debian:10.2.9-armhf
```

Note that MySQL root password will be randomly generated (using pwgen).
If you need to get the password because you container is in background mode:
```
docker logs $(docker ps -qf "ancestor=williamdes/docker-mariadb-debian:10.2.9-armhf") 2>&1 |  grep "MySQL root Password:"
```
Root password will be displayed, during first run using output similar to this:
```
[i] MySQL root Password: XXXXXXXXXXXXXXX
```

But you don't need root password. If you connect locally, it should not
ask you for a password, so you can use following procedure:
```
docker exec -ti mariadb_containerid /bin/sh
# mysql -u root mysql
```
This way you can add any user as well.

## Examples

Typical usage:

```
docker run -ti -v /host/dir/for/db:/var/lib/mysql -e MYSQL_DATABASE=db -e MYSQL_USER=user -e MYSQL_PASSWORD=pazzw0rD williamdes/docker-mariadb-debian:10.2.9-armhf
```

## Configuration

## My.cnf overrides

You can override default MariaDB (MySQL) configuration settings by mounting a volume pointing to /etc/mysql/conf.d .
All files in this directory will be included and all configurations in them will be overriden (in order).

### Init scripts

You can create init scripts by mounting a volume into
- /opt/mariadb/pre-init.d : All .sh scripts in this directory will be executed before 1st time initialization (database creation)
- /opt/mariadb/post-init.d : All .sh scripts in this directory will be executed after 1st time initialization (database creation)
- /opt/mariadb/pre-exec.d : All .sh scripts in this directory will be executed before every start of MariaDB server

## Notes

- UTF-8 is the default charset

## Compile variables

See more in Dockerfile

### Plugins = YES
  PLUGIN_ARCHIVE=YES  
  PLUGIN_BLACKHOLE=YES  
  PLUGIN_ARIA=YES  
  PLUGIN_FEDERATED=YES  
  PLUGIN_FEDERATEDX=YES  
  PLUGIN_LOCALES=YES  
  PLUGIN_METADATA_LOCK_INFO=YES  
  PLUGIN_QUERY_RESPONSE_TIME=YES  
  PLUGIN_SEMISYNC_MASTER=YES  
  PLUGIN_SEMISYNC_SLAVE=YES  
  PLUGIN_SQL_ERRLOG=YES  
  PLUGIN_WSREP_INFO=YES  
### Plugins = NO
  PLUGIN_AUDIT_NULL=NO  
  PLUGIN_CLIENT_ED25519=NO  
  PLUGIN_CONNECT=NO   
  PLUGIN_DEBUG_KEY_MANAGEMENT=NO  
  PLUGIN_EXAMPLE_KEY_MANAGEMENT=NO  
  PLUGIN_FEEDBACK=NO  
  PLUGIN_FILE_KEY_MANAGEMENT=NO  
  PLUGIN_INNOBASE=YES  
  PLUGIN_MROONGA=NO  
  PLUGIN_PARTITION=NO  
  PLUGIN_PERFSCHEMA=NO  
  PLUGIN_ROCKSDB=NO  
  PLUGIN_SEQUENCE=NO  
  PLUGIN_SERVER_AUDIT=NO  
  PLUGIN_SPHINX=NO  
  PLUGIN_SPIDER=NO  
  PLUGIN_OQGRAPH=NO  
### STORAGE ENGINES = ON
  WITH_FEDERATED_STORAGE_ENGINE=ON  
  WITH_EXAMPLE_STORAGE_ENGINE=ON  
  WITH_PBXT_STORAGE_ENGINE=ON  
  WITH_TOKUDB_STORAGE_ENGINE=ON  
  WITH_SPHINX_STORAGE_ENGINE=ON  
### STORAGE ENGINES = OFF
  WITH_EMBEDDED_SERVER=OFF  
  WITH_PARTITION_STORAGE_ENGINE=OFF  
  WITH_PERFSCHEMA_STORAGE_ENGINE=OFF  
  WITH_ROCKSDB_STORAGE_ENGINE=OFF  
### Others
  WITH_JEMALLOC=NO    
  WITH_MARIABACKUP=NO   
  WITH_UNIT_TESTS=OFF    
  ENABLED_PROFILING=OFF  
  ENABLE_DEBUG_SYNC=OFF  
