#!/bin/bash
# 在 feeds 安装完成、生成 .config 之前执行
set -e
SRC="$1"

# 1) 默认 LAN 地址改成 192.168.50.8
sed -i 's/ipad=${ipaddr:-"192.168.1.1"}/ipad=${ipaddr:-"192.168.50.8"}/' \
    "$SRC/package/base-files/files/bin/config_generate"
grep -n '192.168.50.8' "$SRC/package/base-files/files/bin/config_generate"

# 2) 把自定义文件塞进固件
if [ -d "$SRC/../files" ]; then
  cp -r "$SRC/../files/." "$SRC/files/"
fi

# 3) 第三方主题 aurora 的默认值保持官方
echo "diy done"
