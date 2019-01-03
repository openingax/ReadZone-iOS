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
<!--* libTelephonyIOKitDynamic.tbd-->
* CoreTelephony.framework
* SystemConfiguration.framework
* AVFoundation.framework

### 合成 Framework
> 生成一个能在模拟器与真机运行的 Framework，并支持所有架构

1. 在终端 cd 到 Products 目录 (Products 在工程根目录 -> DerivedData -> Build -> Products)
2. 运行命令 `lipo -create ./Debug-iphoneos/TIMServer.framework/TIMServer ./Debug-iphonesimulator/TIMServer.framework/TIMServer -output ./TIMServer`
3. 运行命令：`cp ./TIMServer ./Debug-iphoneos/TIMServer.framework`，用生成在 Products 目录下的 TIMServer 文件替换掉 `./Debug-iphoneos/TIMServer.framework/` 目录下的 TIMServer
4. 运行命令：`lipo -info ./Debug-iphoneos/TIMServer.framework/TIMServer` 检查生成的新 Framework 是否支持多种架构，如：`Architectures in the fat file: ./Debug-iphoneos/TIMServer.framework/TIMServer are: armv7 i386 x86_64 arm64 `表示制作成功
5. 去 `Products/Debug-iphoneos` 里去复制 TIMServer.framework 即可.

注意：如果执行 `lipo -create` 报错 `xxxxxx have the same architectures (i386) and can't be in the same fat output file`，把 Products 目录下的文件全删了重新选择真机与模拟器编译，再重复如上步骤即可。
