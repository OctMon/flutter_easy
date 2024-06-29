import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtil {
  DeviceInfoUtil._();

  /// 初始化应用信息
  static Future<BaseDeviceInfo> init() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    if (deviceInfo is AndroidDeviceInfo) {
      deviceModel = deviceInfo.model;
      deviceBrand = deviceInfo.brand;
      deviceName = deviceInfo.product;
      deviceSystemVersion = "${deviceInfo.version.sdkInt}";
      deviceIsPhysicalDevice = deviceInfo.isPhysicalDevice;
    } else if (deviceInfo is IosDeviceInfo) {
      deviceModel = deviceInfo.utsname.machine;
      deviceBrand = deviceInfo.model;
      deviceName = deviceInfo.name;
      deviceSystemVersion = deviceInfo.systemVersion;
      deviceIsPhysicalDevice = deviceInfo.isPhysicalDevice;
    } else if (deviceInfo is MacOsDeviceInfo) {
      deviceModel = deviceInfo.model;
      deviceBrand = "Mac";
      deviceName = deviceInfo.computerName;
      deviceSystemVersion = deviceInfo.osRelease;
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
late String deviceBrand = "";

/// iOS iPad Air (5th generation)
/// Android sdk_gphone_x86
/// Mac MacBook Pro
late String deviceName = "";

/// 操作系统版本号
late String deviceSystemVersion = "";

///  如果应用程序在模拟器中运行， true 则为其他情况
late bool deviceIsPhysicalDevice = true;
