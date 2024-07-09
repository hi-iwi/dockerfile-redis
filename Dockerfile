FROM aario/centos:7

# 不要升级太超前，尽量最后一个版本超过  10
ENV RedisVer     redis-7.0.14


# centos 7 停止更新yum源了，但是每次重启都会生成很多centos的源而无法访问。这里清除一下
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
RUN rm -f /etc/yum.repos.d/*.repo
RUN mv /etc/yum.repos.d/CentOS-Base.repo.bak /etc/yum.repos.d/CentOS-Base.repo
RUN yum clean all
RUN yum makecache
# ENV RDS_PORT        6379
# ENV RDS_CONF        /etc/aa/redis.conf
# ENV RDS_DATA_DIR    /var/lib/dockervol/redis
# ENV RDS_LOG_DIR     /var/log/dockervol/redis.log
RUN yum install -y gcc gcc-c++ make git which python3

ADD ./src/* /usr/local/src/
WORKDIR "/usr/local/src/${RedisVer}"
RUN make && make install

# @TODO 安装 bloom filter 模块 编译方法见 ：https://redis.uptrace.dev/guide/bloom-cuckoo-count-min-top-k.html#redisbloom
# bloom filter 安装太多问题！！！！ 没必要就先不要安装了！！！
RUN yum clean all  && rm -rf /var/cache/yum && rm -rf /usr/local/src/*
RUN ln -sf /dev/stdout /var/log/dockervol/stdout.log && ln -sf /dev/stderr /var/log/dockervol/stderr.log

# COPY 只能复制当前目录，不复制子目录内容
COPY --chown=aario:aario ./etc/aa/*  /etc/aa/

ENTRYPOINT ["/etc/aa/entrypoint", "/usr/local/bin/redis-server", "/etc/aa/redis.conf"]