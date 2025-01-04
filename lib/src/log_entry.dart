part of 'index.dart';

class _LogEntry {
  _LogEntry({
    required this.message,
    required this.level,
    required this.options,
    required this.timestamp,
    this.tag,
  });
  final String message;
  final String? tag;
  final LogLevel level;
  final LogOptions options;
  final DateTime timestamp;
}
