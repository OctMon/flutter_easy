import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;

import 'log_backend.dart';

EasyLogBackend createEasyLogBackend(
  EasyLogBackendConfig config, {
  EasyLogWriteFailure? onFailure,
}) {
  return TextEasyLogBackend(config, onFailure: onFailure);
}

/// FIFO plaintext persistence aligned with flutter_logger's ytj adapter.
///
/// Android and iOS intentionally use this backend too. The uploaded artifact is
/// the original `.log` file; there is no MX binary file and no export-time
/// decoding or conversion.
final class TextEasyLogBackend extends QueuedEasyLogBackend {
  TextEasyLogBackend(
    this._config, {
    EasyLogWriteFailure? onFailure,
  })  : _onFailure = onFailure,
        _enable = _config.enabled;

  final EasyLogBackendConfig _config;
  final EasyLogWriteFailure? _onFailure;
  bool _enable;
  IOSink? _sink;
  File? _currentFile;

  @override
  bool get isBinary => false;

  @override
  bool get enable => _enable;

  @override
  set enable(bool value) => _enable = value;

  @override
  String get directoryPath => _config.location;

  @override
  dynamic get directoryObject => Directory(directoryPath);

  @override
  dynamic get currentFileObject => _currentFile;

  @override
  Future<void> initialize() async {
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
    await clearExpired();
  }

  @override
  void write(EasyLogBackendRecord record) {
    if (!_enable || record.level < _config.minLevel) {
      return;
    }
    enqueue(() => _write(record)).catchError((Object error, StackTrace stack) {
      _onFailure?.call(error, stack);
    });
  }

  Future<void> _write(EasyLogBackendRecord record) async {
    final file = await _fileFor(record.timestamp);
    if (_currentFile?.path != file.path || !_currentFile!.existsSync()) {
      await _sink?.flush();
      await _sink?.close();
      _currentFile = file;
      _sink = file.openWrite(mode: FileMode.append);
      await _clearExpiredNow();
    }
    _sink!.writeln(_formatRecord(record));
    await _enforceMaxDiskSize();
  }

  Future<File> _fileFor(DateTime timestamp) async {
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
    final stem = '${_config.nameSpace}_${_formatFileTime(timestamp)}';
    var candidate = File(path.join(directoryPath, '$stem.log'));
    final limit = _config.singleFileSizeBytes;
    if (limit <= 0) {
      return candidate;
    }
    var suffix = 1;
    while (candidate.existsSync() && await candidate.length() >= limit) {
      candidate = File(path.join(directoryPath, '${stem}_$suffix.log'));
      suffix++;
    }
    return candidate;
  }

  @override
  List<EasyLogBackendFile> filesSnapshot() {
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      return const <EasyLogBackendFile>[];
    }
    return directory
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.log'))
        .map(_fileInfo)
        .toList(growable: false);
  }

  @override
  Future<List<EasyLogBackendFile>> files() {
    return enqueueResult(() async {
      await _sink?.flush();
      return filesSnapshot();
    });
  }

  @override
  Future<String> readCurrent() {
    return enqueueResult(() async {
      await _sink?.flush();
      final file = _currentFile;
      if (file == null || !file.existsSync()) {
        return '';
      }
      return file.readAsString();
    });
  }

  @override
  Future<void> clear() {
    return enqueue(() async {
      await _sink?.flush();
      await _sink?.close();
      _sink = null;
      _currentFile = null;
      final directory = Directory(directoryPath);
      if (!directory.existsSync()) {
        return;
      }
      await for (final entity in directory.list()) {
        if (entity is File && _isManagedLogFile(entity)) {
          await entity.delete();
        } else if (entity is Directory &&
            path.basename(entity.path) == _config.nameSpace) {
          // Remove only this logger's legacy MX directory after migration.
          await entity.delete(recursive: true);
        }
      }
    });
  }

  @override
  Future<void> clearExpired() => enqueue(_clearExpiredNow);

  Future<void> _clearExpiredNow() async {
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      return;
    }
    final oldestKeep = _oldestKeepDay(DateTime.now(), _config.retention);
    await for (final entity in directory.list()) {
      if (entity is! File || entity.path == _currentFile?.path) {
        continue;
      }
      final fileDate = _parseLogFileDate(entity.path, _config.nameSpace);
      if (fileDate != null && fileDate.isBefore(oldestKeep)) {
        await entity.delete();
      }
    }
  }

  Future<void> _enforceMaxDiskSize() async {
    final limit = _config.maxDiskSizeBytes;
    if (limit <= 0) {
      return;
    }
    final fileList = filesSnapshot()
      ..sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
    var total = fileList.fold<int>(0, (sum, item) => sum + item.sizeBytes);
    for (final item in fileList) {
      if (total <= limit) {
        break;
      }
      if (item.path == _currentFile?.path) {
        continue;
      }
      final file = File(item.path);
      if (file.existsSync()) {
        await file.delete();
        total -= item.sizeBytes;
      }
    }
  }

  @override
  Future<String?> createArchive(String outputDirectory) async {
    await flush();
    return _archiveDirectory(directoryPath, outputDirectory);
  }

  @override
  Future<void> dispose() {
    return enqueue(() async {
      await _sink?.flush();
      await _sink?.close();
      _sink = null;
      _currentFile = null;
    });
  }

  EasyLogBackendFile _fileInfo(File file) {
    final stat = file.statSync();
    return EasyLogBackendFile(
      path: file.path,
      sizeBytes: stat.size,
      createdAt: stat.changed,
      updatedAt: stat.modified,
    );
  }

  String _formatRecord(EasyLogBackendRecord record) {
    final buffer = StringBuffer()
      ..write(record.timestamp.toIso8601String())
      ..write(' #${record.sequenceId} ')
      ..write(_levelName(record.level));
    if (record.tag != null && record.tag!.isNotEmpty) {
      buffer.write(' [${record.tag}]');
    }
    buffer
      ..write(' ')
      ..write(record.message);
    if (record.error != null) {
      buffer.write(' error=${record.error}');
    }
    if (record.stackTrace != null) {
      buffer
        ..write('\n')
        ..write(record.stackTrace);
    }
    return buffer.toString();
  }

  String _formatFileTime(DateTime value) {
    final policyHours = _nearestRotationHours(_config.rotationHours);
    final date = '${value.year}_${_two(value.month)}_${_two(value.day)}';
    switch (policyHours) {
      case 1:
        return '${date}_${_two(value.hour)}';
      case 168:
        return '${value.year}_w${_two(_isoWeek(value))}';
      case 720:
        return '${value.year}_${_two(value.month)}';
      default:
        return date;
    }
  }
}

Future<String?> _archiveDirectory(
  String directoryPath,
  String outputDirectory,
) async {
  if (directoryPath.isEmpty) {
    return null;
  }
  final directory = Directory(directoryPath);
  if (!directory.existsSync()) {
    return null;
  }
  final sourceFiles = directory
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .where(_isArchiveLogFile)
      .toList(growable: false);
  if (sourceFiles.isEmpty) {
    return null;
  }
  final outputDir = Directory(outputDirectory);
  if (!outputDir.existsSync()) {
    await outputDir.create(recursive: true);
  }
  final output = File(path.join(
    outputDirectory,
    'log_zip_${DateTime.now().millisecondsSinceEpoch}.zip',
  ));
  final encoder = ZipFileEncoder();
  var encoderOpened = false;
  try {
    encoder.create(output.path, level: 3);
    encoderOpened = true;
    final archiveRoot = path.basename(path.normalize(directory.path));
    for (final file in sourceFiles) {
      final relativePath = path.relative(file.path, from: directory.path);
      final archivePath = path.posix.join(
        archiveRoot,
        relativePath.split(path.separator).join('/'),
      );
      await encoder.addFile(file, archivePath, 3);
    }
    await encoder.close();
    encoderOpened = false;
    return output.path;
  } catch (_) {
    if (encoderOpened) {
      try {
        encoder.closeSync();
      } catch (_) {}
    }
    if (output.existsSync()) {
      await output.delete();
    }
    rethrow;
  }
}

bool _isArchiveLogFile(File file) => file.path.toLowerCase().endsWith('.log');

bool _isManagedLogFile(File file) {
  final name = path.basename(file.path).toLowerCase();
  return name.endsWith('.log') || name.endsWith('.mx') || name == 'error.txt';
}

String _levelName(int level) {
  switch (level) {
    case 1:
      return 'INFO';
    case 2:
      return 'WARN';
    case 3:
      return 'ERROR';
    case 4:
      return 'FATAL';
    default:
      return 'DEBUG';
  }
}

int _nearestRotationHours(int hours) {
  const policies = <int>[1, 24, 24 * 7, 24 * 30];
  return policies.reduce((nearest, candidate) {
    final nearestDistance = (hours - nearest).abs();
    final candidateDistance = (hours - candidate).abs();
    return candidateDistance < nearestDistance ? candidate : nearest;
  });
}

String _two(int number) => number.toString().padLeft(2, '0');

int _isoWeek(DateTime date) {
  final day = DateTime(date.year, date.month, date.day);
  final thursday = day.add(Duration(days: 4 - day.weekday));
  final firstThursday = DateTime(thursday.year, 1, 4);
  return 1 +
      (thursday.difference(firstThursday).inDays + firstThursday.weekday - 1) ~/
          7;
}

DateTime _oldestKeepDay(DateTime now, Duration retention) {
  final today = DateTime(now.year, now.month, now.day);
  final keepDays = retention.inDays >= 1 ? retention.inDays : 1;
  return today.subtract(Duration(days: keepDays - 1));
}

DateTime? _parseLogFileDate(String filePath, String nameSpace) {
  final name = path.basename(filePath);
  if (!name.endsWith('.log')) {
    return null;
  }
  final prefix = '${nameSpace}_';
  final withoutExtension = name.substring(0, name.length - 4);
  if (!withoutExtension.startsWith(prefix)) {
    return null;
  }
  final parts = withoutExtension.substring(prefix.length).split('_');
  if (parts.length < 3) {
    return null;
  }
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) {
    return null;
  }
  final date = DateTime(year, month, day);
  if (date.year != year || date.month != month || date.day != day) {
    return null;
  }
  return date;
}
