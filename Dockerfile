FROM armhf/debian:latest
MAINTAINER William Desportes <williamdes@wdes.fr>

# The version numbers to download and build and the cpu core count
ENV MARIADB_VER 10.2.9
ENV CPU_NBR 3
ADD start.sh /opt/mariadb/start.sh
RUN mkdir -p /opt/src \
    && mkdir -p /etc/mysql \
    # Install packages
    && apt-get update \
    && apt-get install -y \
        pwgen openssl ca-certificates \
        # Installing needed libs
        libstdc++6 libaio-dev libgnutls28-dev libncurses-dev libcurl4-openssl-dev libxml2 \
        cmake ncurses-dev gnutls-dev libxml2-dev libaio-dev bison libboost-dev curl wget \
    build-essential liblz4-1 liblz4-dev lzma liblzma-dev openssl libssl-dev \
    && update-ca-certificates \
    && apt-get clean \
    # Download and unpack mariadb
    && wget -O /opt/src/mdb.tar.gz https://downloads.mariadb.org/interstitial/mariadb-${MARIADB_VER}/source/mariadb-${MARIADB_VER}.tar.gz \
    && cd /opt/src && tar -xf mdb.tar.gz && rm mdb.tar.gz \
    # Build maridb
    && mkdir -p /tmp/_ \
    && cd /opt/src/mariadb-${MARIADB_VER} \
    && cmake . \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DSYSCONFDIR=/etc/mysql \
        -DMYSQL_DATADIR=/var/lib/mysql \
        -DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock \
        -DDEFAULT_CHARSET=utf8 \
        -DDEFAULT_COLLATION=utf8_general_ci \
        -DENABLED_LOCAL_INFILE=ON \
        -DINSTALL_INFODIR=share/mysql/docs \
        -DINSTALL_MANDIR=/tmp/_/share/man \
        -DINSTALL_PLUGINDIR=lib/mysql/plugin \
        -DINSTALL_SCRIPTDIR=bin \
        # -DINSTALL_INCLUDEDIR=/tmp/_/include/mysql \
        -DINSTALL_DOCREADMEDIR=/tmp/_/share/mysql \
        -DINSTALL_SUPPORTFILESDIR=share/mysql \
        -DINSTALL_MYSQLSHAREDIR=share/mysql \
        -DINSTALL_DOCDIR=/tmp/_/share/mysql/docs \
        -DINSTALL_SHAREDIR=share/mysql \
        -DWITH_READLINE=ON \
        -DWITH_ZLIB=system \
        -DWITH_SSL=system \
        -DWITH_LIBWRAP=OFF \
        -DWITH_JEMALLOC=NO \
        -DWITH_MARIABACKUP=NO \
        -DWITH_EXTRA_CHARSETS=complex \
        -DPLUGIN_ARCHIVE=YES \
        -DPLUGIN_ARIA=YES \
        -DPLUGIN_AUDIT_NULL=NO \
        -DPLUGIN_BLACKHOLE=YES \
        -DPLUGIN_CLIENT_ED25519=NO \
        -DPLUGIN_CONNECT=NO \
        -DPLUGIN_DEBUG_KEY_MANAGEMENT=NO \
        -DPLUGIN_EXAMPLE_KEY_MANAGEMENT=NO \
        -DPLUGIN_FEDERATED=YES \
        -DPLUGIN_FEDERATEDX=YES \
        -DPLUGIN_FEEDBACK=NO \
        -DPLUGIN_FILE_KEY_MANAGEMENT=NO \
        -DPLUGIN_INNOBASE=YES \
        -DPLUGIN_LOCALES=YES \
        -DPLUGIN_METADATA_LOCK_INFO=YES \
        -DPLUGIN_MROONGA=NO \
        -DPLUGIN_PARTITION=NO \
        -DPLUGIN_PERFSCHEMA=NO \
        -DPLUGIN_QUERY_RESPONSE_TIME=YES \
        -DPLUGIN_ROCKSDB=NO \
        -DPLUGIN_SEMISYNC_MASTER=YES \
        -DPLUGIN_SEMISYNC_SLAVE=YES \
        -DPLUGIN_SEQUENCE=NO \
        -DPLUGIN_SERVER_AUDIT=NO \
        -DPLUGIN_SPHINX=NO \
        -DPLUGIN_SPIDER=NO \
        -DPLUGIN_SQL_ERRLOG=YES \
        -DPLUGIN_WSREP_INFO=YES \
        -DPLUGIN_OQGRAPH=NO \
        -DWITH_FEDERATED_STORAGE_ENGINE=ON \
        -DWITH_EXAMPLE_STORAGE_ENGINE=ON \
        -DWITH_PBXT_STORAGE_ENGINE=ON \
        -DWITH_ROCKSDB_STORAGE_ENGINE=OFF \
        -DWITH_TOKUDB_STORAGE_ENGINE=ON \
        -DWITH_EMBEDDED_SERVER=OFF \
        -DWITH_PARTITION_STORAGE_ENGINE=OFF \
        -DWITH_PERFSCHEMA_STORAGE_ENGINE=OFF \
        -DWITH_SPHINX_STORAGE_ENGINE=ON \
        -DWITH_UNIT_TESTS=OFF \
        -DENABLED_PROFILING=OFF \
        -DENABLE_DEBUG_SYNC=OFF \
    && make -j${CPU_NBR} \
        # Install
    && make -j${CPU_NBR} install \
    # Copy default config
    && cp /usr/share/mysql/my-large.cnf /etc/mysql/my.cnf \
    && echo "!includedir /etc/mysql/conf.d/" >>/etc/mysql/my.cnf \
    # Clean everything
    && rm -rf /opt/src \
    && rm -rf /tmp/_ \
    && rm -rf /usr/sql-bench \
    && rm -rf /usr/mysql-test \
    && rm -rf /usr/data \
    && rm -rf /usr/lib/python2.7 \
    && rm -rf /usr/bin/mysql_client_test \
    && rm -rf /usr/bin/mysqltest \
    && apt-get autoremove -y --force-yes \
    # Create needed directories
    && mkdir -p /var/lib/mysql \
    && mkdir -p /run/mysqld \
    && mkdir /etc/mysql/conf.d \
    && mkdir -p /opt/mariadb/pre-init.d \
    && mkdir -p /opt/mariadb/post-init.d \
    && mkdir -p /opt/mariadb/pre-exec.d \
    # Set permissions
    && chmod -R 755 /opt/mariadb \
    && addgroup --system -gid 500 mysql \
    && adduser --system --no-create-home --uid 500 --gid 500 mysql \
    && chown -R mysql:mysql /var/lib/mysql \
    && chown -R mysql:mysql /run/mysqld
ADD my.cnf /etc/mysql/my.cnf
EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/opt/mariadb/start.sh"]