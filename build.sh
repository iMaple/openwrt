#!/bin/bash

sudo apt-get update
sudo apt-get install upx -y
ln -s /usr/bin/upx staging_dir/host/bin/

echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall.git;packages" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall.git;luci" >> feeds.conf.default
echo "src-git passwall2_luci https://github.com/xiaorouji/openwrt-passwall2.git" >> feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install luci-app-passwall
./scripts/feeds install luci-app-passwall2

make defconfig
#make menuconfig

#make download -j8 V=s
make download -j8

sudo chown -R 1000:1000 ./bin

#make package/luci-app-passwall/compile V=sc
make package/luci-app-passwall/{clean,compile} -j$(nproc)
make package/luci-app-passwall2/{clean,compile} -j$(nproc)

make package/index
