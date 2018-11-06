#  开发过程一些问题记录

### 删除多余模拟器

在 Finder 里打开 `/Library/Developer/CoreSimulator/Profiles/Runtimes/`  文件夹
把里面指定版本的模拟器删除即可

### 编译 `TSIMServerViewController.m` 文件时，报如下错误

``
Undefined symbols for architecture x86_64:
"_OBJC_CLASS_$_TIMFriendProfileOption", referenced from:
objc-class-ref in TIMServer(TSIMServerViewController.o)
"_OBJC_CLASS_$_TIMSdkConfig", referenced from:
objc-class-ref in TIMServer(TSIMServerViewController.o)
"_OBJC_CLASS_$_TIMGroupMemberInfoOption", referenced from:
objc-class-ref in TIMServer(TSIMServerViewController.o)
"_OBJC_CLASS_$_TIMGroupInfoOption", referenced from:
objc-class-ref in TIMServer(TSIMServerViewController.o)
"_OBJC_CLASS_$_TIMUserConfig", referenced from:
objc-class-ref in TIMServer(TSIMServerViewController.o)
"_OBJC_CLASS_$_TIMManager", referenced from:
objc-class-ref in TIMServer(TSIMServerViewController.o)
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
``

``
Undefined symbols for architecture x86_64:
"_OBJC_CLASS_$_TIMManager", referenced from:
objc-class-ref in TIMServer(TSIMServerViewController.o)
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)``

当时 configTIMAccount 方法里在配置 TIMManager 的参数，经排除法发现，是配置参数导致的报错
另外，从
`"_OBJC_CLASS_$_TIMManager", referenced from:
objc-class-ref in TIMServer(TSIMServerViewController.o)` 
分析出，是  TIMManage 导致的错误

回想起腾讯 IM Demo 里提到，跑工程时要链接一些 C++ 的库
