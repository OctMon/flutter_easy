# flutter_easy_example

Demonstrates how to use the flutter_easy package.

接入自己应用时需要添加的鸿蒙依赖及支持范围，见[主包 HarmonyOS 接入说明](../README.md#harmonyos鸿蒙基础功能已支持)。

## 普通平台与鸿蒙环境隔离

Android、iOS、Web 等平台继续使用原来的标准 Flutter 3.44.9，在 example 目录运行普通的
`flutter pub get`、`flutter run` 和构建命令。无需切换全局 FVM，也不要在主包或 example
目录直接执行 Flutter OH 的 `pub get`。

鸿蒙使用 Flutter OH `3.41.10-ohos-1.0.1`（Dart 3.11.5），默认目录为
`$HOME/fvm/versions/custom_flutter-oh-3.41.10-ohos-1.0.1`。
工具链基线为 DevEco Studio `26.0.0.865 Release`，最低系统版本为
HarmonyOS 5.1.0（API 18），使用 ARM64 手机模拟器验证。

鸿蒙插件声明和锁文件单独保存在 `ohos/scripts/harmony_overrides.yaml`、
`ohos/scripts/pubspec_ohos.lock`。脚本将 example 和当前 flutter_easy 主包源码复制到
`example/.dart_tool/harmony_project/`，只在这个隔离目录中使用 Flutter OH。
普通平台的依赖声明、锁文件及 `.dart_tool/package_config.json` 不会被鸿蒙命令覆盖。

## 一键构建鸿蒙

在仓库根目录执行：

```bash
example/ohos/build_ohos
```

也可以在 example 目录执行 `ohos/build_ohos`，或进入 `example/ohos/` 执行
`./build_ohos`。对外只保留这个构建入口，辅助脚本统一放在 `ohos/scripts/`。

脚本自动准备隔离依赖、同步原生插件、编译 Flutter 和鸿蒙工程，并检查 HAP 内的
版本号、debug 标识、启动 Ability、ARM64 引擎和 Flutter 资源。产物为：

```text
example/ohos/entry/build/default/outputs/default/entry-default-unsigned.hap
example/build/ohos/hap/entry-default-unsigned.hap
```

这是 debug 未签名 HAP，用于模拟器调试；商店发布需要另行构建 release APP 并签名。
删除 `example/.dart_tool/` 后，下一次构建会自动重新准备依赖，无需手动恢复注册文件。

自定义 SDK 或 DevEco 安装位置时，可在当前终端设置：

```bash
export FLUTTER_OH_HOME="$HOME/fvm/versions/custom_flutter-oh-3.41.10-ohos-1.0.1"
export DEVECO_HOME="/Applications/DevEco-Studio.app/Contents"
example/ohos/build_ohos
```

这些工具链环境只用于当前脚本进程，不修改普通平台的 SDK 配置。
需要单独执行 Flutter OH 命令时，在仓库根目录使用：

```bash
example/ohos/scripts/flutter_oh doctor -v
example/ohos/scripts/flutter_oh pub get
example/ohos/scripts/flutter_oh build hap --debug --no-codesign --no-pub
example/ohos/scripts/flutter_oh devices
```

## DevEco 模拟器运行

1. 先执行 `example/ohos/build_ohos`。
2. 在 DevEco Studio 选择 Open，打开仓库中的 **`example/ohos/`**。
3. 在 Device Manager 启动 HarmonyOS 5.1 / API 18 或更新版本的 ARM64 手机模拟器。
4. 选择该设备和 `entry` 运行配置，点击 Run（macOS 快捷键 `Control+R`）。

DevEco Sync/构建也会自动准备隔离依赖，包括在缓存删除后恢复 `flutter-hvigor-plugin`。
日常修改仓库中的主包 `lib/`、`example/lib/` 和 `example/ohos/`；重新构建或同步工程时，
这些源码会复制到隔离目录。不要修改隔离目录中的副本。

`ohos/scripts/flutter-project.ts` 负责连接原始 ohos 工程与隔离的 Flutter 工程，
使 DevEco 可以直接打开 `example/ohos/`，同时使用正确的 SDK、依赖和版本号。

## 真机运行与支持范围

真机需先在 DevEco Studio 的 `example/ohos/` 工程中配置本地调试签名，连接设备并完成调试授权。
模拟器可安装 debug 未签名 HAP，真机安装需要有效签名。

`ohos/local.properties`、`ohos/signing/`、证书、生成的插件注册文件和构建缓存已忽略，
不要提交 DevEco 写入的签名密码、证书路径或本机绝对路径。

此前已通过 HarmonyOS 5.1.0 / API 18 ARM64 模拟器的安装、启动和主页跳转验证，
尚未完成真机及全部功能验收。当前网络状态、分享以及图片和文件选择仍需接入相应鸿蒙实现。
本次环境隔离沿用现有适配包，不能据此宣称所有功能都已支持鸿蒙。
