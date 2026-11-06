# flutter_easy_example

Demonstrates how to use the flutter_easy package.

接入自己应用时需要添加的鸿蒙依赖及支持范围，见[主包 HarmonyOS 接入说明](../README.md#harmonyos鸿蒙基础功能已支持)。

## HarmonyOS 工具链

`ohos/` 为 Flutter OH 生成的 Stage 模型宿主，最低系统版本为 HarmonyOS
5.1.0（API 18）。宿主和工具链准备不代表 `flutter_easy` 的所有原生依赖已完成鸿蒙适配。

使用独立安装的 Flutter OH `3.41.10-ohos-1.0.1`（Dart 3.11.5），不切换全局 FVM：

example 的最低工具版本为 Flutter 3.27 / Dart 3.6.2。启动所需的鸿蒙实现仅加入
example 依赖：`shared_preferences_ohos`、`path_provider_ohos`、
`package_info_plus_harmonyos`、`device_info_plus_harmonyos` 和 `url_launcher_ohos`；
主库的依赖声明未改变。

工具链基线为 DevEco Studio `26.0.0.865 Release`、HarmonyOS SDK API 26、
随附 JDK 25、Node 24.14.1、ohpm 26.0.0.630 和 Hvigor 6.26.9。
SDK API 26 用于编译，应用的最低兼容版本仍为 API 18。

2026-11-06 已验证：无第三方依赖的独立测试应用及本 example 均成功构建
无签名 debug HAP。example 产物位于
`build/ohos/hap/entry-default-unsigned.hap`；本次未进行真机运行验收。
已通过 DevEco Studio 在 HarmonyOS 5.1.0 / API 18 ARM64 模拟器安装、启动并进入主页。

```bash
# 在 example 目录执行；使用锁文件原本的源，避免改写依赖来源或升级依赖。
PUB_HOSTED_URL=https://pub.dev ../tool/flutter_oh pub get --enforce-lockfile
../tool/flutter_oh doctor -v
../tool/flutter_oh build hap --debug --no-codesign --no-pub
```

`tool/flutter_oh` 默认从 FVM 自定义 SDK 目录
`$HOME/fvm/versions/custom_flutter-oh-3.41.10-ohos-1.0.1` 调用 SDK，并从
`/Applications/DevEco-Studio.app/Contents` 使用 DevEco 的 Java、Node、ohpm、
Hvigor 和 SDK。环境变量仅对当前命令生效，不修改 Shell 配置。

自定义安装目录时设置 `FLUTTER_OH_HOME` 和 `DEVECO_HOME`（后者指向 `.app/Contents`）：

```bash
FLUTTER_OH_HOME=/path/to/flutter-oh \
DEVECO_HOME=/path/to/DevEco-Studio.app/Contents \
../tool/flutter_oh doctor -v
```

## DevEco 模拟器运行

先执行上面的 `pub get` 和 HAP 构建命令，准备插件注册文件和鸿蒙依赖。
在 DevEco Studio 中打开本目录下的 `ohos/`，通过 Device Manager 创建并启动
HarmonyOS 5.1 / API 18 或更新版本的 ARM64 手机模拟器。
选择该设备和 `entry` 运行配置，点击 Run（macOS 快捷键 `Control+R`）。
模拟器可安装无签名 debug HAP，无需配置真机调试签名。

## 真机运行

先在 DevEco Studio 中打开 `ohos/`，为自己的应用和设备配置本地调试签名。
连接 HarmonyOS 真机并完成设备端的调试授权后执行：

```bash
../tool/flutter_oh devices
../tool/flutter_oh run --debug -d <device-id> --no-pub
```

无签名 HAP 可用于构建验证和模拟器运行，真机安装仍需有效签名。
`ohos/local.properties`、`ohos/signing/`、证书、插件注册文件和构建缓存已被忽略；
不要将 DevEco 写入的签名密码、证书路径或本机绝对路径提交到仓库。

当前网络状态、分享以及图片和文件选择仍需接入相应鸿蒙实现。
启动成功不代表所有示例功能均已适配，完整支持范围仍需逐项运行和真机验收。
