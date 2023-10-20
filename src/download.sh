#!/bin/bash
#readonly makeVer='4.4'
readonly redisVer='7.2.2'


download(){
    local f="$1"
    local src="$2"
    if [ -f "$f" ]; then
      return 0
    fi
    wget "$src" -O "$f"
}
#download "make-${makeVer}.tar.gz" "https://ftp.gnu.org/gnu/make/make-${makeVer}.tar.gz"
#git clone git clone --recursive https://github.com/RedisBloom/RedisBloom.git  ./redis-bloom
#download "RedisBloom-${bloomVer}.tar.gz" "https://github.com/RedisBloom/RedisBloom/archive/refs/tags/v${bloomVer}.tar.gz"
download "redis-${redisVer}.tar.gz" "https://download.redis.io/releases/redis-${redisVer}.tar.gz"