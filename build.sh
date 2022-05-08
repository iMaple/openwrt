#!/bin/bash

sudo apt-get update
sudo apt-get install upx -y
ln -s /usr/bin/upx staging_dir/host/bin/

echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall.git;packages" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall.git;luci" >> feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install luci-app-passwall

make defconfig
make menuconfig

make download -j8 V=s

sudo chown -R 1000:1000 ./bin

make package/luci-app-passwall/compile V=sc
#make package/luci-app-passwall/{clean,compile} -j4

make package/index
