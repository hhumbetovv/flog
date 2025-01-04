part of 'index.dart';

class LogOptions {
  LogOptions({
    bool? showRepeatCount,
    ValueGetter<String?>? dateFormat,
    AnsiColors? repeatColor,
    AnsiColors? tagColor,
    AnsiColors? messageColor,
  })  : showDivider = _default.showDivider,
        dividerWidth = _default.dividerWidth,
        dividerColor = _default.dividerColor,
        showRepeatCount = showRepeatCount ?? _default.showRepeatCount,
        dateFormat = dateFormat != null ? dateFormat() : _default.dateFormat,
        messageColor = messageColor ?? _default.messageColor,
        repeatColor = repeatColor ?? _default.repeatColor,
        tagColor = tagColor ?? _default.tagColor,
        levelColors = _default.levelColors;

  LogOptions.initial({
    this.dividerWidth = 100,
    this.showDivider = true,
    this.dividerColor = AnsiColors.kDefault,
    this.showRepeatCount = true,
    this.dateFormat,
    this.messageColor = AnsiColors.kDefault,
    this.tagColor = AnsiColors.kDefault,
    this.repeatColor = AnsiColors.purple,
    this.levelColors = LogOptions.defaultLevelColors,
  });

  static AnsiColors defaultLevelColors(LogLevel level) {
    return switch (level) {
      LogLevel.verbose => AnsiColors.white,
      LogLevel.debug => AnsiColors.blue,
      LogLevel.info => AnsiColors.green,
      LogLevel.warning => AnsiColors.yellow,
      LogLevel.error => AnsiColors.red,
      LogLevel.fatal => AnsiColors.purple,
    };
  }

  static LogOptions get _default => Flog._options;

  final int dividerWidth;
  final bool showDivider;
  final AnsiColors dividerColor;
  final bool showRepeatCount;
  final String? dateFormat;
  final AnsiColors messageColor;
  final AnsiColors tagColor;
  final AnsiColors repeatColor;
  final AnsiColors Function(LogLevel level) levelColors;
}
