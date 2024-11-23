import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtil {
  DeviceInfoUtil._();

  static late BaseDeviceInfo deviceInfo;

  /// 初始化应用信息
  static Future<BaseDeviceInfo> init() async {
    final tmp = await DeviceInfoPlugin().deviceInfo;
    deviceInfo = tmp;
    if (tmp is AndroidDeviceInfo) {
      deviceModel = tmp.model;
      deviceBrand = tmp.brand;
      deviceName = tmp.product;
      deviceSystemVersion = "${tmp.version.sdkInt}";
      deviceIsPhysicalDevice = tmp.isPhysicalDevice;
    } else if (tmp is IosDeviceInfo) {
      deviceModel = tmp.utsname.machine;
      deviceBrand = tmp.model;
      deviceName = tmp.name;
      deviceSystemVersion = tmp.systemVersion;
      deviceIsPhysicalDevice = tmp.isPhysicalDevice;
    } else if (tmp is MacOsDeviceInfo) {
      deviceModel = tmp.model;
      deviceBrand = "Mac";
      deviceName = tmp.computerName;
      deviceSystemVersion = tmp.osRelease;
      deviceIsPhysicalDevice = true;
    } else if (tmp is WebBrowserInfo) {
      deviceModel = tmp.appName ?? "";
      deviceBrand = tmp.appCodeName ?? "";
      deviceName = tmp.browserName.name;
      deviceSystemVersion = tmp.appVersion ?? "";
      deviceIsPhysicalDevice = true;
    }
    return deviceInfo;
  }
}

/// iOS 硬件类型 iPad13,17
/// Android 最终产品的最终用户可见名称
/// Mac MacBookPro16,1
String deviceModel = "";

/// iOS 设备型号 iPad
/// Android 与产品/ 硬件相关联的消费者可见品牌
/// Mac Mac
String deviceBrand = "";

/// iOS iPad Air (5th generation)
/// Android sdk_gphone_x86
/// Mac MacBook Pro
String deviceName = "";

/// 操作系统版本号
String deviceSystemVersion = "";

///  如果应用程序在模拟器中运行， true 则为其他情况
bool deviceIsPhysicalDevice = true;
