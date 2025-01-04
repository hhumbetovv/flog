import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'ansi_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

part 'log_entry.dart';
part 'log_level.dart';
part 'log_options.dart';
part 'log_strategy.dart';

class Flog {
  static LogOptions _options = LogOptions.initial();

  static const String _resetColor = '\x1B[0m';

  static final Queue<_LogEntry> _logQueue = Queue<_LogEntry>();
  static bool _isProcessing = false;
  static final _topDivider = '${_options.dividerColor.code}┃┏${'━' * _options.dividerWidth}$_resetColor';
  static final _bottomDivider = '${_options.dividerColor.code}┃┗${'━' * _options.dividerWidth}$_resetColor';

  static LogLevel? lastLevel;
  static String? lastTag;
  static String? lastMessage;
  static int repeatCount = 1;

  static void initialize(LogOptions options) {
    _options = options;
  }

  static void v(dynamic message, {String? tag, LogOptions? options}) {
    _enqueueLog(message, tag: tag, level: LogLevel.verbose, options: options);
  }

  static void d(dynamic message, {String? tag, LogOptions? options}) {
    _enqueueLog(message, tag: tag, options: options);
  }

  static void i(dynamic message, {String? tag, LogOptions? options}) {
    _enqueueLog(message, tag: tag, level: LogLevel.info, options: options);
  }

  static void w(dynamic message, {String? tag, LogOptions? options}) {
    _enqueueLog(message, tag: tag, level: LogLevel.warning, options: options);
  }

  static void e(dynamic message, {String? tag, LogOptions? options}) {
    _enqueueLog(message, tag: tag, level: LogLevel.error, options: options);
  }

  static void f(dynamic message, {String? tag, LogOptions? options}) {
    _enqueueLog(message, tag: tag, level: LogLevel.error, options: options);
  }

  static void _enqueueLog(
    dynamic message, {
    String? tag,
    LogLevel level = LogLevel.debug,
    LogOptions? options,
  }) {
    if (kReleaseMode) return;

    final logEntry = _LogEntry(
      message: message.toString(),
      tag: tag,
      level: level,
      options: options ?? _options,
      timestamp: DateTime.now(),
    );

    _logQueue.add(logEntry);
    _processQueue();
  }

  static Future<void> _processQueue() async {
    if (_isProcessing || _logQueue.isEmpty) return;

    _isProcessing = true;

    while (_logQueue.isNotEmpty) {
      final logEntry = _logQueue.removeFirst();
      _processLog(logEntry);

      final delay = _calculateDelay(logEntry.message.length);
      await Future.delayed(delay, () {});
    }

    _isProcessing = false;
  }

  static Duration _calculateDelay(int messageLength) {
    const baseDelay = 20;
    const delayPer100Chars = 10;
    const maxDelay = 200;

    final delayMs = (baseDelay + (messageLength ~/ 100) * delayPer100Chars).clamp(baseDelay, maxDelay);
    return Duration(milliseconds: delayMs);
  }

  static void _processLog(_LogEntry entry) {
    final divider = '${Flog._options.dividerColor.code}┃┃ ';

    var formattedMessage = entry.options.showDivider ? divider : '';
    formattedMessage += '${entry.options.levelColors(entry.level).code}[${entry.level.prefix}] ';
    formattedMessage += "${entry.options.tagColor.code}${entry.tag != null ? '[${entry.tag}] ' : ''}";
    formattedMessage += (entry.options.messageColor.code) + entry.message;

    String date;
    if (entry.options.dateFormat != null) {
      date = DateFormat(entry.options.dateFormat).format(entry.timestamp);
    } else {
      date = entry.timestamp.toString();
    }

    if (entry.message == lastMessage && entry.tag == lastTag) {
      repeatCount++;
    } else {
      lastMessage = entry.message;
      repeatCount = 1;
    }

    if (entry.options.showRepeatCount) {
      formattedMessage += entry.options.repeatColor.code;
      formattedMessage += repeatCount != 1 ? ' $divider ${entry.options.repeatColor.code}($repeatCount)' : '';
    }

    formattedMessage += _resetColor;

    if ((entry.level != lastLevel || entry.tag != lastTag) && entry.options.showDivider) {
      if (lastLevel != null) {
        log(
          entry.options.dividerColor.code + _bottomDivider,
          name: date,
          level: entry.level.severityLevel,
        );
      }
      log(
        entry.options.dividerColor.code + _topDivider,
        name: date,
        level: entry.level.severityLevel,
      );
      lastLevel = entry.level;
      lastTag = entry.tag;
    }
    log(formattedMessage, name: date, level: entry.level.severityLevel);
  }
}
