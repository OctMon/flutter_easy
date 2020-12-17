import 'package:uuid/uuid.dart';

/// 基于时间戳实现
getUuidV1() => Uuid().v1();

/// 基于随机算法实现
getUuidV4() => Uuid().v4();
