part of '../flog.dart';

enum LogLevel {
  verbose('VERBOSE', 0),
  debug('DEBUG', 1),
  info('INFO', 2),
  warning('WARN', 3),
  error('ERROR', 4),
  fatal('FATAL', 5);

  const LogLevel(this.prefix, this.severityLevel);

  final String prefix;
  final int severityLevel;
}
