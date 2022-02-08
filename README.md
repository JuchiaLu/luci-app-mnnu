## 闽南师大校园网叠加助手

## (一) 简介

本软件是闽南师大校园网认证的 LuCI 控制界面. 由于认证脚本不大, 直接将其也一起打包了.

![](https://raw.githubusercontent.com/JuchiaLu/luci-app-mnnu/master/images/admin_network_mnnu.png)

![](https://raw.githubusercontent.com/JuchiaLu/luci-app-mnnu/master/images/admin_system_openmptcprouter_status.png)

## (二) 原理

学校的校园网重建几年了没建好,  免费使用不能缴费,  并限速1Mbps多(约160KB/s)的网速,  这点速度连B站的720P视频都看不了,  虽然每个人手机套餐都有无限流量,  但是中午或晚上高峰期网速依然不能顺畅看视频.  

由于ss支持mptcp协议打算配合openwrt在虚拟机搭建个软路由来叠加网速,  后来发现有现成开源项目[OpenMptcpRouter](https://github.com/Ysurac/openmptcprouter)

注意这里是真正意义上的网速叠加,  而不是多IP负载均衡的"叠加".  多IP负载均衡一般用在多线程下载有用, 因为它是同时建立多个会话, 而我们看视频或浏览网站一般都是一对一的单个会话, 所以需要一台服务器用来做链路汇聚.

具体原理就是将数据包分片后通过mptcp协议将分片均衡的分发到多条链路(多个IP)上, 服务器接收到这些分片后重新还原成数据包, 然后服务器作为一个代理将数据包转发到目标网站, OpenMptcpRouter具体原理如官网图所示

![](https://raw.githubusercontent.com/JuchiaLu/luci-app-mnnu/master/images/openmptcprouter.svg)

而我们只需根据需求, 虚拟多张网卡, 这样便能获取到多个IP, 如每个IP限速160KB, 4个IP共640KB就能看1080P在线视频了,  但校园网需要认证过后才能上网, 学校用的是锐捷的网页认证, 本程序实现了锐捷的认证协议, 只需要填写帐号密码, 便可以自动完成各个接口的认证, 同时会自动配置OpenMptcpRouter的一些配置.

## (三) 编译

根据平台下载 OpenWrt/LEDE 的 [SDK](https://openwrt.org/docs/guide-developer/using_the_sdk)

```sh
# 解压下载好的 SDK
tar xvJf openwrt-sdk-18.06.2-x86-generic_gcc-7.3.0_musl.Linux-x86_64.tar.xz
# 切换工作目录
cd openwrt-sdk-*
# Clone 项目
git clone https://github.com/juchialu/luci-app-mnnu.git
# 开始编译
make package/luci-app-mnnu/compile V=99
```

## (四) 其他

已提供编译好的ipk安装包, 直接上传到软路由后安装即可, 保姆级别的虚拟机搭建OpenMptcpRouter软路由并安装本软件的教程看[这里](#TODO), 教程最后提供了配置好的虚拟机文件, 下载直接打开运行即可.
