#  TIMFramework 开发文档

简介：TIMFramework 用于开发云米即时通讯 IM SDK 模块，SDK 主工程为 TIMServer，TIMFramework 为宿主工程

### 依赖的 SDK

##### 云米SDK
* YMCommon.framework
* YMCommon.bundle

***
##### 腾讯 IM SDK

已上传到 Git
* IMFriendshipExt.framework
* IMGroupExt.framework (没有群组功能，暂未添加进工程)
* IMMessageExt.framework
* IMSDKBugly.framework (调试用，暂未添加进工程)

需从公司 FTP服务器 下载加入到 TIMServer 工程
* ImSDK.framework
* QALSDK.framework
* TLSSDK.framework

FTP 相关设置
Account: 192.168.1.250
Password: test
所在目录：`/home/vsftpd/test/iOS/IMSDK`

##### 系统依赖库
* libsqlite3.tbd
* libz.tbd
* libc++.tbd
* libTelephonyIOKitDynamic.tbd


### 跑主工程时报错的解决方法

* 错误提示
1、尝试把 TIMServer 工程的 bitcode 设为 NO
2、尝试把 TIMServer 工程的 Build Active Architecture Only 都设为 NO

* 错误2
`build input file cannot be found TIMServer.a`

解决方法：
1、把 `Enable Bitcode` 设为 NO；
2、把 Debug 下的 Build Active Architecture Only 的设为 NO  
