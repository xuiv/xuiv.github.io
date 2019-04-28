---
layout: post
title:  "golang交叉编译"
date:   2019-04-25 19:19:56
categories: computer config
---

{% highlight sh %}

env GOOS=windows GOARCH=amd64 go build -a -ldflags="-w -s"

env GOOS=linux GOARCH=amd64 go build -a -ldflags="-w -s"

apt-get install gcc-arm-linux-gnueabi
env GOOS=linux GOARCH=arm GOARM=7 CGO_ENABLED=1 CC=arm-linux-gnueabi-gcc go build -a -ldflags="-w -s"

mkdir -p /opt/android/ndk/ && cd /opt/android/ndk/
wget -c http://dl.google.com/android/ndk/android-ndk-r10e-linux-x86_64.bin && chmod a+x android-ndk-r10e-linux-x86_64.bin
./android-ndk-r10c-linux-x86_64.bin
export NDK_HOME=/opt/android/ndk/android-ndk-r10e
export PATH=$NDK_HOME:$PATH
cd /opt/android/ndk/android-ndk-r10e/samples/hello-jni 
ndk-build

/opt/android/ndk/android-ndk-r10e/build/tools/make-standalone-toolchain.sh --platform=android-18 --arch=arm --api 18 --ndk-dir=/opt/android/ndk/android-ndk-r10e
cd /tmp/ndk-root && tar jxf arm-linux-androideabi-4.8.tar.bz2
cd /workspace/go/src/github.com/xuiv/gost-heroku
export PATH=/tmp/ndk-root/arm-linux-androideabi-4.8/bin:$PATH
env GOOS=android GOARCH=arm GOARM=7 CGO_ENABLED=1 CC=arm-linux-androideabi-gcc go build -a -ldflags="-w -s"

curl -O -L https://downloads.openwrt.org/releases/17.01.6/targets/ramips/mt7620/lede-sdk-17.01.6-ramips-mt7620_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar.xz
xz -d lede-sdk-17.01.6-ramips-mt7620_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar.xz
tar xf lede-sdk-17.01.6-ramips-mt7620_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar
export PATH=/workspace/go/lede-sdk-17.01.6-ramips-mt7620_gcc-5.4.0_musl-1.1.16.Linux-x86_64/staging_dir/toolchain-mipsel_24kc_gcc-5.4.0_musl-1.1.16/bin:$PATH
export STAGING_DIR=/workspace/go/lede-sdk-17.01.6-ramips-mt7620_gcc-5.4.0_musl-1.1.16.Linux-x86_64/staging_dir/
env GOOS=linux GOARCH=mipsle CGO_ENABLED=1 CC=mipsel-openwrt-linux-musl-gcc go build -a -ldflags="-w -s"
{% endhighlight %}
