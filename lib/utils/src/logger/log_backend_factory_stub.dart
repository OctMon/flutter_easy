import 'log_backend.dart';

EasyLogBackend createEasyLogBackend(
  EasyLogBackendConfig config, {
  EasyLogWriteFailure? onFailure,
}) {
  return _ConsoleEasyLogBackend(config);
}

class _ConsoleEasyLogBackend implements EasyLogBackend {
  _ConsoleEasyLogBackend(EasyLogBackendConfig config)
      : _enable = config.enabled;

  bool _enable;

  @override
  bool get isBinary => false;

  @override
  bool get enable => _enable;

  @override
  set enable(bool value) => _enable = value;

  @override
  String get directoryPath => '';

  @override
  dynamic get directoryObject => const _UnsupportedDirectory();

  @override
  dynamic get currentFileObject => null;

  @override
  Future<void> initialize() async {}

  @override
  void write(EasyLogBackendRecord record) {}

  @override
  Future<void> flush() async {}

  @override
  List<EasyLogBackendFile> filesSnapshot() => const <EasyLogBackendFile>[];

  @override
  Future<List<EasyLogBackendFile>> files() async =>
      const <EasyLogBackendFile>[];

  @override
  Future<String> readCurrent() async => '';

  @override
  Future<void> clear() async {}

  @override
  Future<void> clearExpired() async {}

  @override
  Future<String?> createArchive(String outputDirectory) async => null;

  @override
  Future<void> dispose() async {}
}

class _UnsupportedDirectory {
  const _UnsupportedDirectory();

  String get path => '';

  bool existsSync() => false;
}
