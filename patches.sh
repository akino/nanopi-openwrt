#sed -i 's/1400000/1450000/' target/linux/rockchip/patches-5.4/991-arm64-dts-rockchip-add-more-cpu-operating-points-for.patch
wget -O target/linux/rockchip/patches-5.4/991-arm64-dts-rockchip-add-more-cpu-operating-points-for.patch https://github.com/coolsnowwolf/lede/raw/67198ef5bed911ee87b696bfcb662b99e12e1fbb/target/linux/rockchip/patches-5.4/003-arm64-dts-rockchip-add-more-cpu-operating-points-for.patch
truncate -s-1 package/lean/luci-app-cpufreq/root/etc/config/cpufreq
echo -e "\toption governor0 'schedutil'" >> package/lean/luci-app-cpufreq/root/etc/config/cpufreq
echo -e "\toption minfreq0 '816000'" >> package/lean/luci-app-cpufreq/root/etc/config/cpufreq
echo -e "\toption maxfreq0 '1512000'\n" >> package/lean/luci-app-cpufreq/root/etc/config/cpufreq

sed -i "s/option hw_flow '1'/option hw_flow '0'/" package/ctcgfw/luci-app-turboacc/root/etc/config/turboacc
sed -i "s/option sfe_flow '1'/option sfe_flow '0'/" package/ctcgfw/luci-app-turboacc/root/etc/config/turboacc
sed -i "s/option sfe_bridge '1'/option sfe_bridge '0'/" package/ctcgfw/luci-app-turboacc/root/etc/config/turboacc
sed -i "/dep.*INCLUDE_.*=n/d" package/ctcgfw/luci-app-turboacc/Makefile

sed -i '/Installed-Time/a\sed -i "s/\\([[:digit:]]\)-[a-z0-9]\{32\}/\1/" $(1)/usr/lib/opkg/status\' include/rootfs.mk
find . -type f -name nft-qos.config | xargs sed -i "s/option limit_enable '1'/option limit_enable '0'/"
sed -i "/\/etc\/coremark\.sh/d" package/feeds/packages/coremark/coremark
sed -i 's/192.168.1.1/192.168.2.1/' package/base-files/files/bin/config_generate

rm -rf files
mv $GITHUB_WORKSPACE/files ./
#chmod 600 files/etc/dropbear/*
rm -rf files/etc/dropbear

if [ $DEVICE = 'r4s' ]; then
    wget https://github.com/immortalwrt/immortalwrt/commit/6c3f6d2686679173b95495c47d861db1f41729dd.patch
    sed -i 's/ctcgfw/kernel/g' 6c3f6d2686679173b95495c47d861db1f41729dd.patch
    git apply 6c3f6d2686679173b95495c47d861db1f41729dd.patch
    rm 6c3f6d2686679173b95495c47d861db1f41729dd.patch
fi

if [[ $DEVICE =~ ('r2s'|'r4s') ]]; then
    wget https://github.com/coolsnowwolf/lede/raw/757e42d70727fe6b937bb31794a9ad4f5ce98081/target/linux/rockchip/config-default -NP target/linux/rockchip/
    wget https://github.com/coolsnowwolf/lede/commit/f341ef96fe4b509a728ba1281281da96bac23673.patch
    git apply f341ef96fe4b509a728ba1281281da96bac23673.patch
    rm f341ef96fe4b509a728ba1281281da96bac23673.patch
fi

sed -i '/182.140.223.146/d' scripts/download.pl
sed -i '/\.cn\//d' scripts/download.pl
sed -i '/tencent/d' scripts/download.pl
