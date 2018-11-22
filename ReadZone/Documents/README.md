#  README

## 错误处理
问题：11月21日晚，在家合并代码时，破坏了 project.pbxproj 工程文件，导致 ReadZone 工程打不开
解决方法：
1、检查 project.pbxproj 工程文件（内容太繁杂，无从下手，试了一下放弃了）；
2、版本回退，把 Git 仓库回退到【腾讯 IM 服务大换血】。

操作：
``
git reset --hard aef652d00d56b23dd9224581e3889c2556120d61       // 回滚
git push --force                                                // 强行推送到远程
``

Done




