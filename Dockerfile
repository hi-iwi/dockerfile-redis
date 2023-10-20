FROM aario/centos:7

# redis 6 支持多线程改动较大，而且要升级gcc，暂不建议使用
ENV RedisVer     redis-7.2.2


# ENV RDS_PORT        6379
# ENV RDS_CONF        /etc/aa/redis.conf
# ENV RDS_DATA_DIR    /var/lib/dockervol/redis
# ENV RDS_LOG_DIR     /var/log/dockervol/redis.log
RUN yum install -y gcc gcc-c++ make git which python3

ADD ./src/* /usr/local/src/
WORKDIR "/usr/local/src/${RedisVer}"
RUN make && make install

# @TODO 安装 bloom filter 模块 编译方法见 ：https://redis.uptrace.dev/guide/bloom-cuckoo-count-min-top-k.html#redisbloom

RUN yum clean all  && rm -rf /var/cache/yum && rm -rf /usr/local/src/*
RUN ln -sf /dev/stdout /var/log/dockervol/stdout.log && ln -sf /dev/stderr /var/log/dockervol/stderr.log

# COPY 只能复制当前目录，不复制子目录内容
COPY --chown=iwi:iwi ./etc/aa/*  /etc/aa/

ENTRYPOINT ["/etc/aa/entrypoint", "/usr/local/bin/redis-server", "/etc/aa/redis.conf"]