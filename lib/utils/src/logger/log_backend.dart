import 'dart:async';

class EasyLogBackendConfig {
  const EasyLogBackendConfig({
    required this.location,
    required this.nameSpace,
    required this.enabled,
    required this.minLevel,
    required this.rotationHours,
    required this.singleFileSizeBytes,
    required this.retention,
    required this.maxDiskSizeBytes,
  });

  final String location;
  final String nameSpace;
  final bool enabled;
  final int minLevel;
  final int rotationHours;
  final int singleFileSizeBytes;
  final Duration retention;
  final int maxDiskSizeBytes;
}

class EasyLogBackendRecord {
  const EasyLogBackendRecord({
    required this.sequenceId,
    required this.timestamp,
    required this.level,
    required this.message,
    required this.formattedMessage,
    this.name,
    this.tag,
    this.error,
    this.stackTrace,
  });

  final int sequenceId;
  final DateTime timestamp;
  final int level;
  final String message;
  final String formattedMessage;
  final String? name;
  final String? tag;
  final String? error;
  final String? stackTrace;
}

class EasyLogBackendFile {
  const EasyLogBackendFile({
    required this.path,
    required this.sizeBytes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String path;
  final int sizeBytes;
  final DateTime createdAt;
  final DateTime updatedAt;
}

abstract interface class EasyLogBackend {
  bool get isBinary;

  bool get enable;

  set enable(bool value);

  String get directoryPath;

  dynamic get directoryObject;

  dynamic get currentFileObject;

  Future<void> initialize();

  void write(EasyLogBackendRecord record);

  Future<void> flush();

  List<EasyLogBackendFile> filesSnapshot();

  Future<List<EasyLogBackendFile>> files();

  Future<String> readCurrent();

  Future<void> clear();

  Future<void> clearExpired();

  Future<String?> createArchive(String outputDirectory);

  Future<void> dispose();
}

typedef EasyLogWriteFailure = void Function(
    Object error, StackTrace stackTrace);

abstract base class QueuedEasyLogBackend implements EasyLogBackend {
  Future<void> _tail = Future<void>.value();

  Future<void> enqueue(FutureOr<void> Function() operation) {
    final next = _tail.then((_) => operation());
    _tail = next.catchError((Object _) {});
    return next;
  }

  Future<T> enqueueResult<T>(FutureOr<T> Function() operation) {
    final next = _tail.then((_) => operation());
    _tail = next.then<void>((_) {}).catchError((Object _) {});
    return next;
  }

  @override
  Future<void> flush() => _tail;
}
