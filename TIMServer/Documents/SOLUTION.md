#  开发过程一些问题记录


### 跑主工程时报错的解决方法

* 错误提示
1、尝试把 TIMServer 工程的 bitcode 设为 NO
2、尝试把 TIMServer 工程的 Build Active Architecture Only 都设为 NO

* 错误2
`build input file cannot be found TIMServer.a`

解决方法：
1、把 `Enable Bitcode` 设为 NO；
2、把 Debug 下的 Build Active Architecture Only 的设为 NO  


*************************


### 删除多余模拟器

在 Finder 里打开 `/Library/Developer/CoreSimulator/Profiles/Runtimes/`  文件夹
把里面指定版本的模拟器删除即可


************************


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

未完待续...


*************************************

### 编写 TIMDemo 时，把腾讯 IM 的 Frameworks 添加到 SDK 工程，编译报错

截取一部分错误：
``
"std::__1::ios_base::~ios_base()", referenced from:
sdk_logger::impl::CGlobalLogger::log(long, std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > const&) in QALSDK(logger.o)
sdk_logger::impl::CGlobalLogger::logapp(long, std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > const&) in QALSDK(logger.o)
sdk_logger::LOGGER_LOG(sdk_logger::ELevel, char const*, int, char const*, char const*, std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > const&) in QALSDK(logger.o)
sdk_logger::LOGGER_APP_LOG(sdk_logger::ELevel, char const*, int, char const*, char const*, std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > const&) in QALSDK(logger.o)
std::__1::basic_ostringstream<char, std::__1::char_traits<char>, std::__1::allocator<char> >::~basic_ostringstream() in QALSDK(logger.o)
virtual thunk to std::__1::basic_ostringstream<char, std::__1::char_traits<char>, std::__1::allocator<char> >::~basic_ostringstream() in QALSDK(logger.o)
std::__1::basic_ostream<char, std::__1::char_traits<char> >::~basic_ostream() in QALSDK(logger.o)
...
"_sqlite3_column_int", referenced from:
-[QualityReportDAOImp fetchBatchItems:] in ImSDK(QualityReportDAOImp.o)
imcore::SqliteMsgStore::ReadSessions(std::__1::vector<std::__1::shared_ptr<imcore::SessionNode>, std::__1::allocator<std::__1::shared_ptr<imcore::SessionNode> > >*) in IMMessageExt(sqlite_store.o)
imcore::SqliteMsgStore::ReadMsgs(std::__1::shared_ptr<imcore::SessionNode> const&, unsigned long, std::__1::vector<std::__1::shared_ptr<imcore::MsgNode>, std::__1::allocator<std::__1::shared_ptr<imcore::MsgNode> > >*, imcore::MsgNode const*, bool) in IMMessageExt(sqlite_store.o)
imcore::SqliteMsgStore::DBReportReaded(std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > const&, imcore::SessionType, unsigned int) in IMMessageExt(sqlite_store.o)
imcore::SqliteMsgStore::ReportReaded(std::__1::shared_ptr<imcore::SessionNode>, unsigned int) in IMMessageExt(sqlite_store.o)
imcore::SqliteMsgStore::ReadMsgsRecentTime(std::__1::vector<imcore::MsgKey, std::__1::allocator<imcore::MsgKey> >&, unsigned int) in IMMessageExt(sqlite_store.o)
imcore::SqliteMsgStore::FindMessage(std::__1::shared_ptr<imcore::SessionNode> const&, unsigned long long, unsigned long long, unsigned long long, bool) in IMMessageExt(sqlite_store.o)
...
"std::__1::__basic_string_common<true>::__throw_length_error() const", referenced from:
-[TIMMessage(MsgExt) setCustomData:] in IMMessageExt(TIMMessage+MsgExt.o)
-[TIMMessage(MsgExt) setSender:] in IMMessageExt(TIMMessage+MsgExt.o)
-[TIMMessageDraft setUserData:] in IMMessageExt(TIMMessage+MsgExt.o)
-[TIMConversation(MsgExt) saveMessage:sender:isReaded:] in IMMessageExt(TIMConversation+MsgExt.o)
-[TIMManager(MsgExt) sendMessage:toUsers:succ:fail:] in IMMessageExt(TIMManager+MSG.o)
-[TIMManager(MsgExt) getConversationList] in IMMessageExt(TIMManager+MSG.o)
-[TIMManager(MsgExt) deleteConversation:receiver:] in IMMessageExt(TIMManager+MSG.o)
...
"_sqlite3_prepare", referenced from:
imcore::SqliteMsgStore::RevokeOneMsg(imcore::MessageLocator const&) in IMMessageExt(sqlite_store.o)
imcore::SqliteMsgStore::DeleteC2CMsgs(std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > const&, unsigned int, unsigned int, unsigned int, unsigned int) in IMMessageExt(sqlite_store.o)
imcore::SqliteMsgStore::DeleteSystemMsgs(std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > const&, unsigned int, unsigned int, unsigned int, unsigned int) in IMMessageExt(sqlite_store.o)
"std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> >::insert(unsigned long, char const*)", referenced from:
_t_::_p_::FieldDescriptor::DefaultValueAsString(bool) const in QALSDK(descriptor.o)
_t_::_p_::DescriptorBuilder::AddSymbol(std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > const&, void const*, std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> > const&, _t_::_p_::Message const&, _t_::_p_::(anonymous namespace)::Symbol) in QALSDK(descriptor.o)
_t_::_p_::TextFormat::Parser::MergeUsingImpl(_t_::_p_::io::ZeroCopyInputStream*, _t_::_p_::Message*, _t_::_p_::TextFormat::Parser::ParserImpl*) in QALSDK(text_format.o)
openbdh::BdhLog::logToServer(unsigned int, int, char const*, ...) in ImSDK(log.o)
"operator delete(void*)", referenced from:
+[TIMMessage(GetMsgExt) getExtElemFromIMElem:] in IMMessageExt(TIMMessage+MsgExt.o)
-[TIMMessage(MsgExt) setCustomData:] in IMMessageExt(TIMMessage+MsgExt.o)
-[TIMMessage(MsgExt) customData] in IMMessageExt(TIMMessage+MsgExt.o)
-[TIMMessage(MsgExt) locator] in IMMessageExt(TIMMessage+MsgExt.o)
-[TIMMessage(MsgExt) respondsToLocator:] in IMMessageExt(TIMMessage+MsgExt.o)
-[TIMMessage(MsgExt) setSender:] in IMMessageExt(TIMMessage+MsgExt.o)
-[TIMMessageDraft .cxx_destruct] in IMMessageExt(TIMMessage+MsgExt.o)
...
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
``

原因：Build Settings -> Linking -> Mach-0 Type 设成了 Dynamic Library
解决方法：把 Mach-O Type 改成 Static Library


******************************************

### 如果工程切换了文件夹，而 Build Setting 里又开了【Precompile Prefix Header】此时再编译会报错

解决方法：
1、把 Prefix Header 设为相对路径，如：`${SRCROOT}/ReadZone/RZPrefixHeader.pch`；
2、去工程文件夹里，把 Build、Index 和 DerivedData 三个文件夹都删了；
3、回到 Xcode 工程，重新编译工程。


******************************************

### 在 TIMServer 工程里集成小视频发送功能，在会话里发送小视频时，报了 `code: 6224 msg: lack ugc ext lib` 的错误

原因分析：
未正确添加 UGC 相关的 Framework

解决方法：重新添加 IMUGCExt.framework 和 TXRTMPSDK.framework 后，能正常工作了。


******************************************

### 在添加新增好友功能模块时，跑工程时报了错
``
ld: warning: directory not found for option '-F/Users/xieliying/MyCode/ReadZone-iOS/TIMServer/Build/Products/Debug-iphonesimulator'
ld: warning: directory not found for option '-F/Users/xieliying/MyCode/ReadZone-iOS/Build/Products/Debug-iphonesimulator'
ld: warning: directory not found for option '-F/Users/xieliying/MyCode/ReadZone-iOS/IMFrameworks'
Undefined symbols for architecture arm64:
"_OBJC_CLASS_$_TIMAddFriendRequest", referenced from:
objc-class-ref in TIMServer(TSChatViewController.o)
ld: symbol(s) not found for architecture arm64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
``

原因分析： TIMAddFriendRequest 未定义，怀疑编译器没找到 TIMAddFriendRequest 相关的代码或 Framework

解决方法：在 Linked Frameworks and Libraries 里添加 IMFriendshipExt.framework 库
