# flutter_easy_example

Demonstrates how to use the flutter_easy package.

## HarmonyOS 工具链

`ohos/` 为 Flutter OH 生成的 Stage 模型宿主，最低系统版本为 HarmonyOS
5.1.0（API 18）。宿主和工具链准备不代表 `flutter_easy` 的所有原生依赖已完成鸿蒙适配。

使用独立安装的 Flutter OH `3.41.10-ohos-1.0.1`（Dart 3.11.5），不切换全局 FVM：

工具链基线为 DevEco Studio `26.0.0.865 Release`、HarmonyOS SDK API 26、
随附 JDK 25、Node 24.14.1、ohpm 26.0.0.630 和 Hvigor 6.26.9。
SDK API 26 用于编译，应用的最低兼容版本仍为 API 18。

2026-11-06 已验证：无第三方依赖的独立测试应用及本 example 均成功构建
无签名 debug HAP。example 产物位于
`build/ohos/hap/entry-default-unsigned.hap`；本次未进行真机运行验收。

```bash
# 在 example 目录执行；使用锁文件原本的源，避免改写依赖来源或升级依赖。
PUB_HOSTED_URL=https://pub.dev ../tool/flutter_oh pub get --enforce-lockfile
../tool/flutter_oh doctor -v
../tool/flutter_oh build hap --debug --no-codesign --no-pub
```

`tool/flutter_oh` 默认从仓库同级的
`sdk/flutter-oh-3.41.10-ohos-1.0.1` 调用 SDK，并从
`/Applications/DevEco-Studio.app/Contents` 使用 DevEco 的 Java、Node、ohpm、
Hvigor 和 SDK。环境变量仅对当前命令生效，不修改 Shell 配置。

自定义安装目录时设置 `FLUTTER_OH_HOME` 和 `DEVECO_HOME`（后者指向 `.app/Contents`）：

```bash
FLUTTER_OH_HOME=/path/to/flutter-oh \
DEVECO_HOME=/path/to/DevEco-Studio.app/Contents \
../tool/flutter_oh doctor -v
```

## 真机运行

先在 DevEco Studio 中打开 `ohos/`，为自己的应用和设备配置本地调试签名。
连接 HarmonyOS 真机并完成设备端的调试授权后执行：

```bash
../tool/flutter_oh devices
../tool/flutter_oh run --debug -d <device-id> --no-pub
```

无签名 HAP 仅用于验证构建，不能代替真机安装所需的有效签名。
`ohos/local.properties`、`ohos/signing/`、证书、插件注册文件和构建缓存已被忽略；
不要将 DevEco 写入的签名密码、证书路径或本机绝对路径提交到仓库。

当前依赖中的存储、目录、设备信息、应用信息、网络状态、分享、URL 打开以及
example 的图片和文件选择仍需接入相应鸿蒙实现。即使 HAP 编译成功，
也必须完成这些原生能力的适配和真机验收后才能宣称 example 已完整支持鸿蒙。
