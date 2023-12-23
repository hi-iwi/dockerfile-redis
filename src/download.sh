#!/bin/bash
readonly redisVer='7.0.14'


download(){
    local f="$1"
    local src="$2"
    if [ -f "$f" ]; then
      return 0
    fi
    wget "$src" -O "$f"
}

download "redis-${redisVer}.tar.gz" "https://download.redis.io/releases/redis-${redisVer}.tar.gz"